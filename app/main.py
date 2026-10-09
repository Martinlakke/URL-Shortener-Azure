from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse, FileResponse
from pydantic import BaseModel
import string
import random
import psycopg
import time
import os

app = FastAPI()

# Datos de conexión a PostgreSQL (los mismos del docker run)
DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "dbname": os.getenv("DB_NAME", "urlshortener"),
    "user": os.getenv("DB_USER", "admin"),
    "password": os.getenv("DB_PASSWORD", "secreto123"),
}

BASE_URL = os.getenv("BASE_URL")

def get_connection():
    return psycopg.connect(**DB_CONFIG)

# Al arrancar la app, crea la tabla si no existe

@app.on_event("startup")
def crear_tabla():
    for intento in range(10):
        try:
            with get_connection() as conn:
                conn.execute("""
                    CREATE TABLE IF NOT EXISTS urls (
                        codigo VARCHAR(6) PRIMARY KEY,
                        url_original TEXT NOT NULL
                    )
                """)
            print("Conectado a la base de datos y tabla lista.")
            return
        except psycopg.OperationalError:
            print(f"Base de datos no lista, reintento {intento + 1}/10...")
            time.sleep(2)
    raise Exception("No se pudo conectar a la base de datos tras varios intentos.")

class URLInput(BaseModel):
    url: str

def generar_codigo():
    caracteres = string.ascii_letters + string.digits
    return "".join(random.choices(caracteres, k=6))

@app.get("/")
def pagina_principal():
    return FileResponse("static/index.html")


@app.post("/acortar")
def acortar_url(entrada: URLInput, request: Request):
    codigo = generar_codigo()
    with get_connection() as conn:
        conn.execute(
            "INSERT INTO urls (codigo, url_original) VALUES (%s, %s)",
            (codigo, entrada.url),
        )
    base = BASE_URL or str(request.base_url).rstrip("/")
    return {"url_corta": f"{base}/{codigo}"}

@app.get("/{codigo}")
def redirigir(codigo: str):
    with get_connection() as conn:
        resultado = conn.execute(
            "SELECT url_original FROM urls WHERE codigo = %s",
            (codigo,),
        ).fetchone()
    if resultado is None:
        raise HTTPException(status_code=404, detail="URL no encontrada")
    return RedirectResponse(url=resultado[0])
README.md
# PROYECTO_TAREA1_PIPELINES

Este repositorio contiene un **script básico en Python**, un archivo `requirements.txt` con las dependencias necesarias y las instrucciones para crear un entorno virtual, correr el script en tu computadora y documentar los pasos.

---

## 1. Requisitos

- Python 3.10+ instalado en tu máquina.
- Git para clonar el repositorio (opcional si ya lo descargaste como ZIP).

---

## 2. Clonar el repositorio

```bash
git clone https://github.com/Ivano2021/PROYECTO_TAREA1_PIPELINES.git
cd PROYECTO_TAREA1_PIPELINES

3. Crear el entorno virtual
macOS / Linux
python3 -m venv venv
source venv/bin/activate
pip install -U pip
pip install -r requirements.txt

Windows (PowerShell)
py -m venv venv
.\venv\Scripts\Activate.ps1
pip install -U pip
pip install -r requirements.txt

4. Ejecutar el script
4.1 Usando datos sintéticos (sin CSV propio)
python src/script_basico.py


Esto va a:

Imprimir estadísticas en la terminal.

Crear el archivo outputs/estadisticas.csv.

4.2 Usando un CSV propio

Colocá tu archivo en la carpeta data/ (ejemplo: data/mi_archivo.csv).
El CSV debe tener al menos estas columnas: grupo y valor.

Corré:

python src/script_basico.py -i data/mi_archivo.csv -o outputs/estadisticas.csv

5. Resultados

El script imprime estadísticas globales y por grupo en la terminal.

También guarda un archivo CSV con esos resultados en outputs/.

6. Notas

El archivo .gitignore evita subir el entorno virtual (venv/), la carpeta outputs/ y otros archivos temporales.

Si algo no funciona, asegurate de tener activado el entorno virtual antes de correr el script.

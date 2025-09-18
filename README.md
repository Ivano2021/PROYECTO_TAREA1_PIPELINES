## README.md

````markdown
# PROYECTO_TAREA1_PIPELINES

Este repositorio contiene la **Tarea 1**:

- Script básico en Python  
- Archivo `requirements.txt` con dependencias  
- Entorno virtual (local)  
- Pasos de ejecución en mi computadora  
- Dockerfile para contenedor  
- Ejecución con `docker build` y `docker run`  
- Montaje de carpetas entre host y contenedor  

---

## 1. Ejecución local (Python)

### 1.1 Crear y activar entorno virtual
**macOS / Linux:**
```bash
python3 -m venv venv
source venv/bin/activate
````

**Windows (PowerShell):**

```powershell
py -m venv venv
.\venv\Scripts\Activate.ps1
```

### 1.2 Instalar dependencias

```bash
pip install -U pip
pip install -r requirements.txt
```

### 1.3 Ejecutar el script

Con datos sintéticos:

```bash
python src/script_basico.py
```

Con un CSV propio (ej: `data/mi_archivo.csv` con columnas `grupo, valor`):

```bash
python src/script_basico.py -i data/mi_archivo.csv -o outputs/estadisticas.csv
```

Esto genera el archivo `outputs/estadisticas.csv`.

---

## 2. Ejecución con Docker

### 2.1 Construir la imagen

Desde la raíz del repositorio:

```bash
docker build -f docker/Dockerfile -t tarea1:latest .
```

### 2.2 Ejecutar el contenedor

Con datos sintéticos:

```bash
docker run --rm tarea1:latest python src/script_basico.py
```

Con un CSV propio y guardando salida en mi máquina:

```bash
mkdir -p data outputs
docker run --rm \
  -v "$PWD/data:/app/data" \
  -v "$PWD/outputs:/app/outputs" \
  tarea1:latest \
  python src/script_basico.py -i data/mi_archivo.csv -o outputs/estadisticas.csv
```

En Windows (PowerShell):

```powershell
mkdir data; mkdir outputs
docker run --rm `
  -v "${PWD}\data:/app/data" `
  -v "${PWD}\outputs:/app/outputs" `
  tarea1:latest `
  python src/script_basico.py -i data/mi_archivo.csv -o outputs/estadisticas.csv
```

---

## 3. Resultados

* El script imprime estadísticas **globales** y **por grupo** en la terminal.
* También guarda un archivo CSV en `outputs/estadisticas.csv`.

---

## 4. Notas

* `.gitignore` evita subir `venv/`, `outputs/` y archivos temporales.
* `.dockerignore` evita copiar contenido innecesario al contenedor.



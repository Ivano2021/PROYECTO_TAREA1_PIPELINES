🧬 Resumen del proyecto

Este pipeline implementa un flujo de trabajo en Nextflow con procesos en Bash para el conteo de líneas y secuencias en archivos de texto y FASTA, incluyendo un análisis de longitud y contenido GC.
El proyecto está diseñado para ejecutarse tanto en modo local como dentro de contenedores Docker, garantizando reproducibilidad, portabilidad y trazabilidad en cualquier entorno.

¿Querés que te lo combine todo en un README.md final completo (con resumen, objetivos, comandos y explicación técnica) listo para subir al repo?
Así tenés la Tarea 2 presentada de forma impecable.

Dijiste:
ok
ChatGPT dijo:

Perfecto 💪 Iván.
Acá te dejo el README.md completo y final, listo para subir a tu carpeta tarea2 en GitHub.
Está redactado con formato profesional, claro y alineado con los criterios de tu curso (claridad técnica, evidencia y comprensión de Nextflow + Docker).

🧬 Tarea 2 — Pipeline básico en Nextflow (Bash + Docker)
🧩 Resumen del proyecto

Este pipeline implementa un flujo de trabajo en Nextflow con procesos en Bash para el conteo de líneas y secuencias en archivos de texto y FASTA, incluyendo un análisis de longitud y contenido GC.
El proyecto está diseñado para ejecutarse tanto en modo local como dentro de contenedores Docker, garantizando reproducibilidad, portabilidad y trazabilidad en cualquier entorno.

🎯 Objetivos

Instalar y ejecutar Nextflow.

Crear una carpeta de trabajo (tarea2/) con un ejemplo funcional.

Implementar procesos en Bash para:

Contar líneas de un archivo .txt.

Contar secuencias de tipo X en un archivo .fasta.

Calcular longitud y %GC de cada secuencia.

Probar el mismo pipeline con los perfiles:

-profile local (sin contenedores).

-profile docker (ejecutando en contenedores).

⚙️ Estructura del proyecto
tarea2/
├── data/
│   ├── example.txt
│   └── example.fasta
├── main.nf
├── nextflow.config
├── results/
│   ├── line_count.txt
│   ├── seq_type_count.txt
│   ├── seq_lengths_gc.tsv
│   ├── seq_lengths_gc_summary.txt
│   ├── report.html
│   ├── timeline.html
│   └── trace.txt
└── README.md

🧪 Ejecución local

Para correr el pipeline en modo local (sin contenedores):

cd ~/PROYECTO_TAREA1_PIPELINES/tarea2
nextflow run . -profile local

🐋 Ejecución con Docker

Para ejecutar el mismo pipeline dentro de contenedores:

nextflow run . -profile docker

Evidencia de ejecución con Docker

En results/report.html, el encabezado muestra:
Container engine: Docker

En results/trace.txt, la columna container indica la imagen usada:
ubuntu:22.04

Los contenedores son efímeros: se crean y eliminan automáticamente tras cada proceso, por eso no permanecen visibles en Docker Desktop.

📊 Archivos de salida

line_count.txt → total de líneas del archivo de texto.

seq_type_count.txt → número de secuencias del tipo especificado.

seq_lengths_gc.tsv → longitud y %GC por secuencia.

seq_lengths_gc_summary.txt → resumen global del %GC y longitud media.

report.html, timeline.html, trace.txt → reportes generados por Nextflow.

🧠 Explicación técnica y utilidad del pipeline

El pipeline desarrollado implementa una estructura reproducible en Nextflow, compuesta por tres procesos Bash:

COUNT_LINES: cuenta el número total de líneas en un archivo de texto.

COUNT_SEQ_TYPE: identifica cuántas secuencias del archivo FASTA pertenecen a un tipo específico, indicado en los headers como [type:X].

SEQ_STATS_LONG: calcula para cada secuencia su longitud y contenido GC (%GC), generando además un resumen estadístico global.

La configuración (nextflow.config) permite ejecutar el mismo flujo tanto en modo local como en modo Docker, utilizando la imagen base ubuntu:22.04.
Esto garantiza portabilidad y reproducibilidad: cualquier persona puede ejecutar el pipeline en su propia máquina con solo tener Nextflow y Docker instalados.

💡 Cómo reutilizarlo

Cualquier usuario puede clonar y ejecutar el pipeline directamente:

git clone https://github.com/Ivano2021/PROYECTO_TAREA1_PIPELINES.git
cd PROYECTO_TAREA1_PIPELINES/tarea2
nextflow run . -profile docker


Nextflow descargará la imagen necesaria, ejecutará los procesos en contenedores y generará los resultados en results/.

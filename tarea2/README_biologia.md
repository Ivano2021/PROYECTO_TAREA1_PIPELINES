# Explicación biológica del pipeline (Tarea 2)

## Objetivo biológico
Este pipeline de Nextflow ejecuta tres tareas simples sobre datos de ejemplo para ilustrar conceptos básicos en análisis de secuencias:

1. **Conteo de líneas en un archivo de texto** (control técnico).
2. **Conteo de secuencias por “tipo”** en un archivo FASTA, donde el “tipo” está anotado en el *header* como `[type:X]` (p. ej., `16S`, `18S`, `ITS`).
3. **Cálculo de longitud y %GC por secuencia** para caracterizar composición y variación básica de los fragmentos.

> Nota: Es un pipeline **didáctico**. No realiza alineamientos, control de calidad ni anotación funcional; solo operaciones de parsing y métricas simples.

---

## Contexto genético de los “tipos”
- **16S** (rRNA 16S): marcador ampliamente usado en bacterias y arqueas para estudios de diversidad microbiana.
- **18S** (rRNA 18S): análogo en eucariotas; útil para comunidades eucariotas (protistas, etc.).
- **ITS** (Internal Transcribed Spacer): región altamente variable, muy utilizada para identificación de hongos.

En el FASTA de ejemplo, cada *header* lleva una etiqueta como `[type:16S]`. El pipeline cuenta cuántas secuencias corresponden al tipo elegido (`--type`, por defecto `16S`).

---

## ¿Qué mide el %GC y por qué importa?
El **contenido GC** (porcentaje de bases G o C) es una métrica de composición que:
- Varía entre genomas y regiones genómicas.
- Afecta propiedades físicas del ADN/ARN (temperatura de fusión, estabilidad).
- Puede correlacionarse con sesgos de codificación, estructura de genoma, o sesgos de amplificación/secuenciación.

Aquí se calcula **por secuencia** y se reporta un **promedio global** para el conjunto procesado.

---

## Entradas y salidas clave
**Entrada:**
- `data/example.fasta` — secuencias con headers del tipo `>seqX [type:16S]`.

**Salidas:**
- `seq_type_count.txt` — número de secuencias del tipo elegido (`--type`).
- `seq_lengths_gc.tsv` — por secuencia: ID, longitud y %GC.
- `seq_lengths_gc_summary.txt` — resumen global: n° de secuencias, longitud media, %GC medio.

---

## Interpretación mínima de resultados (ejemplo)
- Si `seq_type_count.txt` muestra `Secuencias de tipo 16S: 2`, significa que en el FASTA hay 2 *headers* con `[type:16S]`.
- En `seq_lengths_gc.tsv`, cada fila resume una secuencia. Diferencias marcadas en longitud o %GC pueden sugerir distintos loci, regiones hipervariables, o artefactos (en un dataset real).
- El `GC% medio` en `seq_lengths_gc_summary.txt` ofrece una medida rápida de composición promedio del conjunto.

---

## Limitaciones y supuestos
- El “tipo” se infiere **solo** del *header* (`[type:X]`), no del contenido de la secuencia.
- No se realiza control de calidad (trimming, filtrado), ni alineamientos, ni taxonomía.
- El cálculo de %GC es directo (conteo de G/C); no maneja IUPAC ambiguas (R, Y, N…) de forma especial.
- Archivos pequeños: enfocado en didáctica y reproducibilidad (local o en contenedor Docker).

---

## Extensiones posibles (trabajo futuro)
- Validar formato FASTA y caracteres válidos; manejar IUPAC extendido.
- Añadir **estadísticas por tipo** (longitud media y %GC por cada categoría 16S/18S/ITS).
- Incorporar **QC** (FastQC/MultiQC), **filtrado** y **deduplicación**.
- Alinear 16S/18S/ITS a referencias (p. ej., SILVA/UNITE) y reportar taxonomía básica.
- Exportar gráficos (distribución de longitudes, histograma de %GC).

---

## Reproducibilidad
El pipeline corre:
- **Local**: `nextflow run . -profile local`
- **Docker**: `nextflow run . -profile docker` (usa un contenedor definido en `nextflow.config`)

Los reportes (`report.html`, `timeline.html`, `trace.txt`) permiten auditar procesos y tiempos.

/*
 * Tarea 2 - Nextflow (bash)
 * - Contar líneas de un .txt (COUNT_LINES)
 * - Contar secuencias de tipo X en FASTA buscando [type:X] en el header (COUNT_SEQ_TYPE)
 * - Proceso extra: longitud y GC% por secuencia (SEQ_STATS_LONG)
 * Perfiles: -profile local / -profile docker
 */
nextflow.enable.dsl = 2

// Defaults (se pueden overridear por CLI)
params.txt    = 'data/example.txt'
params.fasta  = 'data/example.fasta'
params.type   = '16S'
params.outdir = 'results'

// Canales de entrada (nombres simples, sin .set{})
TEXT_FILE  = Channel.fromPath(params.txt)
FASTA_FILE = Channel.fromPath(params.fasta)

// ---------- PROCESO 1: contar líneas de un .txt ----------
process COUNT_LINES {
  publishDir params.outdir, mode: 'copy', overwrite: true

  input:
  path txt from TEXT_FILE

  output:
  path "line_count.txt"

  script:
  """
  echo "Archivo: ${txt}" > line_count.txt
  echo -n "Total de líneas: " >> line_count.txt
  wc -l < "${txt}" >> line_count.txt
  """
}

// ---------- PROCESO 2: contar secuencias de tipo X en FASTA ----------
process COUNT_SEQ_TYPE {
  publishDir params.outdir, mode: 'copy', overwrite: true

  input:
  path fa from FASTA_FILE

  output:
  path "seq_type_count.txt"

  script:
  """
  echo "FASTA: ${fa}" > seq_type_count.txt
  echo "Tipo buscado: ${params.type}" >> seq_type_count.

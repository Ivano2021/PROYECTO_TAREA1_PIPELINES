/*
 * Tarea 2 - Nextflow (bash)
 * - Contar líneas de un .txt (COUNT_LINES)
 * - Contar secuencias de tipo X en un FASTA por header [type:X] (COUNT_SEQ_TYPE)
 * - Proceso extra "más largo": calcular longitud y GC% por secuencia (SEQ_STATS_LONG)
 * Perfiles: -profile local, -profile docker
 */
nextflow.enable.dsl=2

params.txt    = params.txt   ?: 'data/example.txt'
params.fasta  = params.fasta ?: 'data/example.fasta'
params.type   = params.type  ?: '16S'     // tipo X por defecto
params.outdir = params.outdir ?: 'results'

// Canales de entrada
Channel.fromPath(params.txt).set { TEXT_FILE }
Channel.fromPath(params.fasta).set { FASTA_FILE }

// ---- PROCESO 1: contar líneas de un .txt ----
process COUNT_LINES {
  tag { file(params.txt).getName() }

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

// ---- PROCESO 2: contar secuencias de tipo X en FASTA ----
process COUNT_SEQ_TYPE {
  tag { "${params.type}" }

  publishDir params.outdir, mode: 'copy', overwrite: true

  input:
  path fa from FASTA_FILE

  output:
  path "seq_type_count.txt"

  script:
  """
  echo "FASTA: ${fa}" > seq_type_count.txt
  echo "Tipo buscado: ${params.type}" >> seq_type_count.txt
  COUNT=\$(grep -c "^>.*\\[type:${params.type}\\]" "${fa}" || true)
  echo "Secuencias de tipo ${params.type}: \$COUNT" >> seq_type_count.txt
  """
}

// ---- PROCESO 3 (más largo): longitudes y GC% por secuencia ----
process SEQ_STATS_LONG {
  tag { "stats" }

  publishDir params.outdir, mode: 'copy', overwrite: true

  input:
  path fa from FASTA_FILE

  output:
  path "seq_lengths_gc.tsv"
  path "seq_lengths_gc_summary.txt"

  script:
  """
  # Extraer por secuencia: id, length, GC%
  awk '
    BEGIN{FS=""; id=""; seq=""}
    /^>/{
      if (id!="") {
        len=length(seq)
        gc=0
        for(i=1;i<=len;i++){ base=toupper(substr(seq,i,1)); if(base=="G" || base=="C") gc++ }
        gcperc=(len>0)? (100.0*gc/len):0
        printf "%s\t%d\t%.3f\n", id, len, gcperc
      }
      id=\$0; gsub(/^>/,"",id); seq=""
      next
    }
    !/^>/{ seq=seq \$0 }
    END{
      if (id!="") {
        len=length(seq)
        gc=0
        for(i=1;i<=len;i++){ base=toupper(substr(seq,i,1)); if(base=="G" || base=="C") gc++ }
        gcperc=(len>0)? (100.0*gc/len):0
        printf "%s\t%d\t%.3f\n", id, len, gcperc
      }
    }
  ' "${fa}" > seq_lengths_gc.tsv

  # Resumen global (promedios)
  awk '
    BEGIN{n=0; sumlen=0; sumgc=0}
    { n++; sumlen+=\$2; sumgc+=\$3 }
    END{
      if(n>0){
        printf "Secuencias: %d\\nLongitud media: %.2f\\nGC%% medio: %.2f\\n", n, (sumlen/n), (sumgc/n)
      } else {
        print "Secuencias: 0\\nLongitud media: NA\\nGC% medio: NA"
      }
    }
  ' seq_lengths_gc.tsv > seq_lengths_gc_summary.txt
  """
}

// ---- Flujo principal ----
workflow {
  COUNT_LINES(TEXT_FILE)
  COUNT_SEQ_TYPE(FASTA_FILE)
  SEQ_STATS_LONG(FASTA_FILE)
}

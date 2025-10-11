/*
 * Tarea 2 - Nextflow (bash)
 * - Contar líneas de un .txt (COUNT_LINES)
 * - Contar secuencias de tipo X en FASTA [type:X] (COUNT_SEQ_TYPE)
 * - Proceso extra: longitud y GC% por secuencia (SEQ_STATS_LONG)
 * Perfiles: -profile local / -profile docker
 */
nextflow.enable.dsl = 2

// ===== Defaults sin warnings =====
if( !params.txt )    params.txt    = 'data/example.txt'
if( !params.fasta )  params.fasta  = 'data/example.fasta'
if( !params.type )   params.type   = '16S'
if( !params.outdir ) params.outdir = 'results'


// ---------- PROCESO 1: contar líneas ----------
process COUNT_LINES {
  publishDir params.outdir, mode: 'copy', overwrite: true

  input:
  path txt

  output:
  path "line_count.txt"

  script:
  """
  echo "Archivo: ${txt}" > line_count.txt
  echo -n "Total de líneas: " >> line_count.txt
  wc -l < "${txt}" >> line_count.txt
  """
}

// ---------- PROCESO 2: contar secuencias de tipo X ----------
process COUNT_SEQ_TYPE {
  publishDir params.outdir, mode: 'copy', overwrite: true

  input:
  path fa

  output:
  path "seq_type_count.txt"

  script:
  """
  echo "FASTA: ${fa}" > seq_type_count.txt
  echo "Tipo buscado: ${params.type}" >> seq_type_count.txt
  COUNT=\$(grep -c '^>.*\\[type:${params.type}\\]' "${fa}" || true)
  echo "Secuencias de tipo ${params.type}: \$COUNT" >> seq_type_count.txt
  """
}

// ---------- PROCESO 3: longitud y GC% por secuencia ----------
process SEQ_STATS_LONG {
  publishDir params.outdir, mode: 'copy', overwrite: true

  input:
  path fa

  output:
  path "seq_lengths_gc.tsv"
  path "seq_lengths_gc_summary.txt"

  script:
  """
  awk '
    BEGIN{FS=\"\"; id=\"\"; seq=\"\"}
    /^>/{
      if (id!=\"\") {
        len=length(seq)
        gc=0
        for(i=1;i<=len;i++){
          b=toupper(substr(seq,i,1));
          if(b==\"G\" || b==\"C\") gc++
        }
        gcperc=(len>0)? (100.0*gc/len):0
        printf \"%s\\t%d\\t%.3f\\n\", id, len, gcperc
      }
      id=\$0; gsub(/^>/,\"\",id); seq=\"\"
      next
    }
    !/^>/{ seq=seq \$0 }
    END{
      if (id!=\"\") {
        len=length(seq)
        gc=0
        for(i=1;i<=len;i++){
          b=toupper(substr(seq,i,1));
          if(b==\"G\" || b==\"C\") gc++
        }
        gcperc=(len>0)? (100.0*gc/len):0
        printf \"%s\\t%d\\t%.3f\\n\", id, len, gcperc
      }
    }
  ' "${fa}" > seq_lengths_gc.tsv

  awk '
    BEGIN{n=0; sumlen=0; sumgc=0}
    { n++; sumlen+=\$2; sumgc+=\$3 }
    END{
      if(n>0){
        printf \"Secuencias: %d\\nLongitud media: %.2f\\nGC%% medio: %.2f\\n\", n, (sumlen/n), (sumgc/n)
      } else {
        print \"Secuencias: 0\\nLongitud media: NA\\nGC% medio: NA\"
      }
    }
  ' seq_lengths_gc.tsv > seq_lengths_gc_summary.txt
  """
}

// ---------- WORKFLOW: crear canales y pasarlos por posición ----------
workflow {
  TXT   = Channel.value( file(params.txt) )
  FASTA = Channel.value( file(params.fasta) )

  COUNT_LINES( TXT )
  COUNT_SEQ_TYPE( FASTA )
  SEQ_STATS_LONG( FASTA )
}

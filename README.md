Práctica 2. Detección de candidatos BRAF V600E

Coloca los archivos .fasta en la carpeta centros_BRAF y deja
detectar_braf.sh junto a esa carpeta.

Abre una terminal en la carpeta del proyecto y ejecuta:

    ./detectar_braf.sh
En caso de que haya perdido los permisos al subirlo al github,
ejecuta:

  "chmod u+x detectar_braf.sh"
  
El script busca el fragmento "CTACAGAGAAATC",   guarda la cabecera y la
secuencia de cada candidato en "pacientes_candidatos_BRAF.fasta."

Con los cuatro archivos de la práctica, el resultado esperado es 14.

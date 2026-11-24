#!/bin/bash

# Indicamos la carpeta de entrada, el fragmento y el nombre de la salida.
carpeta="centros_BRAF"
motivo="CTACAGAGAAATC"
salida="pacientes_candidatos_BRAF.fasta"
hay_fasta="no"

# Miramos si hay algún archivo FASTA antes de crear la salida.
for archivo in "$carpeta"/*.fasta
do
    if [[ -f "$archivo" ]]
    then
        hay_fasta="si"
    fi
done

# Creamos una salida vacía y guardamos el estado de esa operación.
if [ "$hay_fasta" = "si" ]
then
    > "$salida"
    estado_salida="$?"
fi

# Comprobamos los dos posibles fallos antes de leer los archivos.
if [ "$hay_fasta" = "no" ]
then
    echo "Error: no hay archivos FASTA en $carpeta."
elif [ "$estado_salida" -ne 0 ]
then
    echo "Error: no se pudo crear $salida."
else
    for archivo in "$carpeta"/*.fasta
    do
        if [[ -f "$archivo" ]]
        then
            echo "Procesando $archivo"
            registro=""
            secuencia=""

            # Leemos cada línea y comprobamos si empieza por >.
            while read linea
            do
                cabecera=$(echo "$linea" | grep -c '^>')

                if [ "$cabecera" -gt 0 ]
                then
                    # Ha terminado el registro anterior. Lo guardamos si coincide.
                    coincide=$(echo "$secuencia" | tr atcg ATCG | grep -c "$motivo")
                    [ "$coincide" -gt 0 ] && echo "$registro" >> "$salida"

                    registro="$linea"
                    secuencia=""
                else
                    # Juntamos las letras para buscar y conservamos las líneas.
                    secuencia="$secuencia$linea"
                    registro="$registro
$linea"
                fi
            done < "$archivo"

            # Al llegar al final evaluamos el último registro.
            coincide=$(echo "$secuencia" | tr atcg ATCG | grep -c "$motivo")
            [ "$coincide" -gt 0 ] && echo "$registro" >> "$salida"
        fi
    done
    echo "Resultado guardado en $salida."
    #Muestra el numero de pacientes que pueden aspirar al tratamiento
    candidatos=$(grep -c '^>' "$salida")
    echo "Número de candidatos: $candidatos"

fi

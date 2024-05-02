#!/bin/bash

# Este script sube un archivo a un bucket de AWS S3 usando opciones especificadas.

# Función para validar los parámetros requeridos
validate_params() {
    if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$FILE_TO_UPLOAD" ] || [ -z "$S3_BUCKET" ]; then
        echo "Faltan uno o más argumentos obligatorios."
        echo "Uso: $0 -k <aws_access_key_id> -s <aws_secret_access_key> -f <archivo_a_subir> -b <bucket_de_s3>"
        exit 1
    fi
}

# Función para verificar si el archivo existe
check_file_exists() {
    if [ ! -f "$FILE_TO_UPLOAD" ]; then
        echo "El archivo especificado no existe: $FILE_TO_UPLOAD"
        exit 1
    fi
}

# Inicializar variables
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
FILE_TO_UPLOAD=""
S3_BUCKET=""

# Extraer opciones
while getopts "k:s:f:b:" opt; do
    case ${opt} in
        k )
        AWS_ACCESS_KEY_ID=$OPTARG
        ;;
        s )
        AWS_SECRET_ACCESS_KEY=$OPTARG
        ;;
        f )
        FILE_TO_UPLOAD=$OPTARG
        ;;
        b )
        S3_BUCKET=$OPTARG
        ;;
        \? )
        echo "Opción inválida: -$OPTARG"
        echo "Uso: $0 -k <aws_access_key_id> -s <aws_secret_access_key> -f <archivo_a_subir> -b <bucket_de_s3>"
        exit 1
        ;;
    esac
done

# Validar parámetros
validate_params

# Verificar si el archivo existe
check_file_exists

# Configuración de las credenciales de AWS
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# Comando para subir el archivo al bucket de S3
output=$(aws s3 cp "$FILE_TO_UPLOAD" "s3://$S3_BUCKET/" 2>&1)
status=$?

# Verificar si el comando fue exitoso
if [ $status -eq 0 ]; then
    echo "Archivo subido correctamente."
else
    echo "Error al subir el archivo: $output"
fi
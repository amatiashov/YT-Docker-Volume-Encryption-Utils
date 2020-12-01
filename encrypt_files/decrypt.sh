#!/bin/bash
DATE=`date '+%d-%m-%Y--%H-%M-%S'`

TARGET_FOLDER="decrypt"

ENCRYPTED_FILE_PATH=$1
ENCRYPTED_KEY_FILE_PATH=$2
PRIVATE_KEY_FILE_PATH=$3
OUTPUT_FILE_NAME=$4

KEY_FILE_NAME="$(basename -- "$ENCRYPTED_KEY_FILE_PATH").decrypt"

usage() {
  echo "Usage: $0 [file] [encrypted key] [private key] [output file]"
  exit 1
}

if [ -z $ENCRYPTED_FILE_PATH ]
then
  echo "Error: missing encrypted file path parameter."
  usage
fi

if [ -z $ENCRYPTED_KEY_FILE_PATH ]
then
  echo "Error: missing encrypted key file path parameter."
  usage
fi

if [ -z $PRIVATE_KEY_FILE_PATH ]
then
  echo "Error: missing encrypted private key file path parameter."
  usage
fi

if [ -z $OUTPUT_FILE_NAME ]
then
  echo "Error: missing output file name parameter."
  usage
fi

# decrypt key
openssl rsautl -decrypt -inkey ${PRIVATE_KEY_FILE_PATH} -in ${ENCRYPTED_KEY_FILE_PATH} -out ${TARGET_FOLDER}/${KEY_FILE_NAME}

# decrypt file
openssl enc -d -md sha256 -aes256 -in ${ENCRYPTED_FILE_PATH} -out ${TARGET_FOLDER}/${OUTPUT_FILE_NAME} -pass file:./${TARGET_FOLDER}/${KEY_FILE_NAME}

# delete ecrypted file key
rm ${TARGET_FOLDER}/${KEY_FILE_NAME}

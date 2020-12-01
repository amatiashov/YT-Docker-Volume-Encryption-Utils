#!/bin/bash
# Data in given volume is saved in a tar archive.
DATE=`date '+%d-%m-%Y--%H-%M-%S'`

CONTAINER_NAME=$1
VOLUME_NAME=$2

BACKUP_FOLDER="$(pwd)/backups/encrypted"
BACKUP_NAME="${CONTAINER_NAME}_${DATE}_volume_backup.tar"
ENCRYPTED_BACKUP_NAME="${BACKUP_NAME}.enc"

PUB_KEY_FILE_PATH="$(pwd)/keys/pem/id_rsa.pub.pem"
ENCRYPTED_BACKUP_NAME="${CONTAINER_NAME}_${DATE}_volume_backup.tar.enc"
KEY_FILE_NAME="${BACKUP_FOLDER}/${CONTAINER_NAME}.key.bin"
ENCRYPTED_KEY_FILE_NAME="${KEY_FILE_NAME}.enc"

usage() {
  echo "Usage: $0 [container name] [volume name]"
  exit 1
}

if [ -z $CONTAINER_NAME ]
then
  echo "Error: missing container name parameter."
  usage
fi

if [ -z $VOLUME_NAME ]
then
  echo "Error: missing volume name parameter."
  usage
fi

docker run --rm --volumes-from $CONTAINER_NAME -v ${BACKUP_FOLDER}:/backup busybox tar cvf /backup/${BACKUP_NAME} $VOLUME_NAME

# generating a 1024 bit (128 byte) random key
openssl rand -base64 128 > ${KEY_FILE_NAME}

# encrypting the key
openssl rsautl -encrypt -inkey  ${PUB_KEY_FILE_PATH} -pubin -in ${KEY_FILE_NAME} -out ${ENCRYPTED_KEY_FILE_NAME}

# Encrypt source file
openssl enc -aes-256-cbc -salt -in ${BACKUP_FOLDER}/${BACKUP_NAME} -out ${BACKUP_FOLDER}/${ENCRYPTED_BACKUP_NAME} -pass file:${KEY_FILE_NAME}


rm ${KEY_FILE_NAME}
rm ${BACKUP_FOLDER}/${BACKUP_NAME}

echo "========================="
echo "ENCRYPTED FILE PATH: " ${BACKUP_FOLDER}/$ENCRYPTED_BACKUP_NAME
echo "ENCRYPTED KEY FILE PATH: " $ENCRYPTED_KEY_FILE_NAME
echo "========================="
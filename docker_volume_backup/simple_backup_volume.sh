#!/bin/bash
# Data in given volume is saved in a tar archive.
DATE=`date '+%d-%m-%Y--%H-%M-%S'`

CONTAINER_NAME=$1
VOLUME_NAME=$2

BACKUP_FOLDER="$(pwd)/backups"
BACKUP_NAME="${CONTAINER_NAME}_${DATE}_volume_backup.tar"


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

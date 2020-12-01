#!/bin/bash
CONTAINER_NAME=$1
BACKUP_FILE_NAME=$2


usage() {
  echo "Usage: $0 [container name] [backup file path]"
  exit 1
}

if [ -z $CONTAINER_NAME ]
then
  echo "Error: missing container name parameter."
  usage
fi

if [ -z $BACKUP_FILE_NAME ]
then
  echo "Error: missing backup file name parameter."
  usage
fi

docker run --rm --volumes-from $CONTAINER_NAME -v $(pwd):/backup busybox tar xvf /backup/${BACKUP_FILE_NAME}

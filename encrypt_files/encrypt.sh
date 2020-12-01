#!/bin/bash
DATE=`date '+%d-%m-%Y--%H-%M-%S'`

TARGET_FOLDER="encrypt"

SOURCE_FILE_PATH=$1
PUB_KEY_FILE_PATH=$2

KEY_FILE_NAME=${TARGET_FOLDER}/"$(basename -- "$SOURCE_FILE_PATH").key.bin"
ENCRYPTED_FILE_PATH="${TARGET_FOLDER}/$(basename -- "$SOURCE_FILE_PATH").enc"
ENCRYPTED_KEY_FILE_NAME="${KEY_FILE_NAME}.enc"


while [ ! $# -eq 0 ]
do
	case "$1" in
		--uuid | -u)
			ID=$(openssl rand -hex 12)
			ENCRYPTED_FILE_PATH="${TARGET_FOLDER}/${ID^^}"
			ID=$(openssl rand -hex 12)
			ENCRYPTED_KEY_FILE_NAME="${TARGET_FOLDER}/${ID^^}"
			;;
	esac
	case "$1" in
		--silence | -s)
			# set default parameters
			PUB_KEY_FILE_PATH="keys/pem/id_rsa.pub.pem"
			;;
	esac
	shift
done

usage() {
  echo "Usage: $0 [source file path] [public key file path]"
  exit 1
}

if [ -z $SOURCE_FILE_PATH ]
then
  echo "Error: missing source file path parameter."
  usage
fi

if [ -z $PUB_KEY_FILE_PATH ]
then
  echo "Error: missing public key parameter."
  usage
fi


# generating a 1024 bit (128 byte) random key
openssl rand -base64 128 > ${KEY_FILE_NAME}

# encrypting the key
openssl rsautl -encrypt -inkey  ${PUB_KEY_FILE_PATH} -pubin -in ${KEY_FILE_NAME} -out ${ENCRYPTED_KEY_FILE_NAME}

# Encrypt source file
openssl enc -e -md sha256 -aes256 -salt -in ${SOURCE_FILE_PATH} -out ${ENCRYPTED_FILE_PATH} -pass file:./${KEY_FILE_NAME}

rm -rf ${KEY_FILE_NAME}

echo "========================="
echo "ENCRYPTED FILE PATH: " $ENCRYPTED_FILE_PATH
echo "ENCRYPTED KEY FILE PATH: " $ENCRYPTED_KEY_FILE_NAME
echo "========================="

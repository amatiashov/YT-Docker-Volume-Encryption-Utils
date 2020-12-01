#!/bin/bash

KEYS_BASE_FOLDER='keys'
KEY_FILE_NAME="id_rsa"


if [[ -d ${KEYS_BASE_FOLDER} ]]
	then
	  read -p "Folder ${KEYS_BASE_FOLDER} exists. Are you sure you want to delete it? (y/N) " answer
	  if [[ "$answer" == "y" ]]
	  	then
	  		randNumber=$((999 + RANDOM % 10000))
	  		echo "WARNING! Old keys will be delleted!"
	  		read -p "type: $randNumber: " number
	  		if [[ $number -eq randNumber ]]
	  			then
		  			echo "Errasing keys folder..."
		  			rm -rf keys
		  			mkdir -p keys/pem
		  		else
		  			echo "Wrong check number! exit"
		  			exit 0
	  			fi
	  	else
	  		echo "exit"
	  		exit 0
	  	fi
	else
		mkdir -p keys/pem
	fi

mkdir -p backups/encrypted


echo "generation base rsa keys..."
ssh-keygen -b 4096 -t rsa -f ${KEYS_BASE_FOLDER}/${KEY_FILE_NAME} -q -N '' -m PEM

echo "converting private key into pem format..."
openssl rsa -in ${KEYS_BASE_FOLDER}/${KEY_FILE_NAME} -outform pem > ${KEYS_BASE_FOLDER}/pem/${KEY_FILE_NAME}.pem

echo "converting public key into pem format..."
openssl rsa -in ${KEYS_BASE_FOLDER}/${KEY_FILE_NAME} -pubout -outform pem > ${KEYS_BASE_FOLDER}/pem/${KEY_FILE_NAME}.pub.pem

#!/bin/bash

bash ./soal3a.sh
now=$(date +"%d-%m-%Y")
mkdir "$now"
mv ./Koleksi_* "./$now/"
mv ./Foto.log "./$now/"

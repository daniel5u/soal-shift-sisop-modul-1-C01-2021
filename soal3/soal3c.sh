#!/bin/bash

N=23
sama=0
now=$(date +"%d-%m-%Y")
yest=$(date -d yesterday +"%d-%m-%Y")
cek=$(ls Kelinci_$yest)
salah=$?
if (($salah==0)) 
then
	mkdir "Kucing_$now"
	for((a=1;a<=N;a=a+1))
	do
		if ((a<10))
		then
			wget -O Koleksi_0$a.jpg -a Foto.log https://loremflickr.com/320/240/kitten
			for((b=1;b<a;b=b+1))
			do
				s=$(cmp "./Koleksi_0$a.jpg" "./Koleksi_0$b.jpg")
				x=$?
				if [ $x -eq 0 ]
				then
					sama=$((sama+1))
					rm "./Koleksi_0$a.jpg"
					N=$((N-1))
					a=$((a-1))
					break
				fi
			done
		else
			wget -O Koleksi_$a.jpg -a Foto.log https://loremflickr.com/320/240/kitten
			for((b=1;b<a;b=b+1))
			do
				if ((b<10))
				then
					s=$(cmp "./Koleksi_$a.jpg" "./Koleksi_0$b.jpg")
					x=$?
					if [ $x -eq 0 ]
					then
						sama=$((sama+1))
						rm "./Koleksi_$a.jpg"
						N=$((N-1))
						a=$((a-1))
						break
					fi
				else
					s=$(cmp "./Koleksi_$a.jpg" "./Koleksi_$b.jpg")
					x=$?
					if [ $x -eq 0 ]
					then
						sama=$((sama+1))
						rm "./Koleksi_$a.jpg"
						N=$((N-1))
						a=$((a-1))
						break
					fi
				fi
			done
		fi
	done
	mv ./Koleksi_* "./Kucing_$now"
	mv ./Foto.log "./Kucing_$now"
else
	mkdir "Kelinci_$now"
	for((a=1;a<=N;a=a+1))
	do
		if ((a<10))
		then
			wget -O Koleksi_0$a.jpg -a Foto.log https://loremflickr.com/320/240/bunny
			for((b=1;b<a;b=b+1))
			do
				s=$(cmp "./Koleksi_0$a.jpg" "./Koleksi_0$b.jpg")
				x=$?
				if [ $x -eq 0 ]
				then
					sama=$((sama+1))
					rm "./Koleksi_0$a.jpg"
					N=$((N-1))
					a=$((a-1))
					break
				fi
			done
		else
			wget -O Koleksi_$a.jpg -a Foto.log https://loremflickr.com/320/240/bunny
			for((b=1;b<a;b=b+1))
			do
				if ((b<10))
				then
					s=$(cmp "./Koleksi_$a.jpg" "./Koleksi_0$b.jpg")
					x=$?
					if [ $x -eq 0 ]
					then
						sama=$((sama+1))
						rm "./Koleksi_$a.jpg"
						N=$((N-1))
						a=$((a-1))
						break
					fi
				else
					s=$(cmp "./Koleksi_$a.jpg" "./Koleksi_$b.jpg")
					x=$?
					if [ $x -eq 0 ]
					then
						sama=$((sama+1))
						rm "./Koleksi_$a.jpg"
						N=$((N-1))
						a=$((a-1))
						break
					fi
				fi
			done
		fi
	done
	mv ./Koleksi_* "./Kelinci_$now"
	mv ./Foto.log "./Kelinci_$now"
fi
echo "sama = $sama"

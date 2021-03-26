#!/bin/bash
N=23
sama=0
for((i=1;i<=N;i=i+1))
do
	if ((i<10))
	then
		wget -O Koleksi_0$i.jpg -a Foto.log https://loremflickr.com/320/240/kitten
		for((j=1;j<i;j=j+1))
		do
			s=$(cmp "./Koleksi_0$j.jpg" "./Koleksi_0$i.jpg")
			x=$?
			if [ $x -eq 0 ]
			then
				sama=$((sama+1))
				rm "./Koleksi_0$i.jpg"
				N=$((N-1))
				i=$((i-1))
				break
			fi
		done
	else
		wget -O Koleksi_$i.jpg -a Foto.log https://loremflickr.com/320/240/kitten
		for((j=1;j<i;j=j+1))
		do
			if((j<10))
			then
				s=$(cmp "./Koleksi_0$j.jpg" "./Koleksi_$i.jpg")
				x=$?
				if [ $x -eq 0 ]
				then
					sama=$((sama+1))
					rm "./Koleksi_$i.jpg"
					N=$((N-1))
					i=$((i-1))
					break
				fi
			else
				s=$(cmp "./Koleksi_$j.jpg" "./Koleksi_$i.jpg")
				x=$?
				if [ $x -eq 0 ]
				then
					sama=$((sama+1))
					rm "./Koleksi_$i.jpg"
					N=$((N-1))
					i=$((i-1))
					break
				fi
			fi
		done
	fi
done
echo "sama = $sama"

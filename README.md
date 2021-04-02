# Laporan soal-shift-sisop-modul-1-C01-2021
## Anggota Kelompok C01
* Fais Rafii Akbar Hidiya 05111940000026 (mengerjakan soal nomor 1)
* Daniel Sugianto         05111940000075 (mengerjakan soal nomor 2)
* Dwinanda Bagoes Ansori  05111940000010 (mengerjakan soal nomor 3)

## Soal Asli
https://docs.google.com/document/d/1T3Y4o2lt5JvLTHdgzA5vRBQ0QYempbC5z-jcDAjela0/edit

# Penjelasan dan Pembahasan Soal

## Soal 1
Ryujin menjadi IT Support di perusahaan Bukapedia.Ia diberi 2 tugas untuk membuat laporan harian aplikasi internal perusahaan yang bernama ticky.Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky.
dari soal tersebut ditemukan solusinya yaitu kita harus mengakses file syslog.log terlebih dahulu untuk mendapatkan data errornya kemudian kita read datanya menggunakan cat setelah itu kita gunakan regex untuk sortir datanya.

### Soal 1a
Diminta ,mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. 
**Solusi:**
Pertama, buat file bash yang berisi command untuk menjalankan file bash dari soal
Kemudian kita input syslog untuk mengakses data 
Kita dapatkan data error dengan grep command setelah itu kita read data dari grep tersebut dengan menggunakan fungsi cat dan regex
lalu terakhir kita dapatkan hasilnya
```
#!/bin/bash
input="syslog.log"
cut -d " " -f 1-3 $input
grep -oE "(ERROR)(.*)\(.*\)" syslog.log | sort | uniq | cut -d " " -f 2-  
input3=$(cat syslog.log)
regex="(ERROR |INFO )(.*) \((.*)\)"
regex2="(ERROR )(.*) \((.*)\)"
grep -oP "$regex" "$input"
```

### Soal 1b
Kemudian, Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.

**Solusi:**

Pertama, dibuatkan fungsi untuk mengakses data error
```
get_error_log(){
 local s=$1 regex=$2 
 while [[ $s =~ $regex ]]; do
  printf "${BASH_REMATCH[2]}\n"
  s=${s#*"${BASH_REMATCH[0]}"}
 done
}
```
Kemudian Dapatkan semua pesan error dan sorting kemudian munculkan pesan
```
errorlog=$(
while read -r line
do
 get_error_log "$line" "$regex2"
done < "$input")

sortederrorlog=$(echo $errorlog | sort | uniq -c | sort -nr | tr -s [:space:])
echo $sortederrorlog
```
### Soal 1c
Ryujin juga harus dapat menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.

**Solusi:**
Pertama kita buat fungsi untuk menampilkan error log untuk setiap user
```
get_user_log(){
 local s=$1 regex=$2
 ```
 Kemudian kita iterasikan menggunakan while
 ```
 while [[ $s =~ $regex ]]; do
  printf "${BASH_REMATCH[3]}\n"
  s=${s#*"${BASH_REMATCH[0]}"}
 done
}
userlog=$(
while read -r line
do
 get_user_log "$line" "$regex"
done < "$input")
```
kemudian tampilkan datanya
```
sorteduserlog=$(echo $userlog | sort | uniq | sort)
```
### Soal 1d
Semua informasi yang didapatkan pada poin b dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak.

**Solusi:**
Pertama inisiasi poin b yang sudah dituliskan menggunakan echo 
kemudian read data poin b yang sudah di inisiasi
lalu redirect menjadi file csv.
```
printf "Error,Count\n" >> "error_message.csv"
echo "$sortederrorlog" | grep -oP "^ *[0-9]+ \K.*" | while read -r line
do
 count=$(grep "$line" "$input" | wc -l)
 printf "$line,$count\n"
done >> "error_message.csv"
```

### Soal 1e
Semua informasi yang didapatkan pada poin c dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.

**Solusi:**
Solusi sama dengan poin 1d  hanya diberi header 
setelah itu langsung redirect ke dalam file csv
```
error=$(grep "ERROR" "$input") 
info=$(grep "INFO" "$input")
printf "Username,INFO,ERROR\n" >> "user_statistic.csv"
echo "$sorteduserlog" | while read -r line
do
 errcount=$(echo "$error" | grep -w "$line" | wc -l)
 infocount=$(echo "$info" | grep -w "$line" | wc -l)
 printf "$line,$infocount,$errcount\n"
done >> "user_statistic.csv"
```

## Soal 2
Pendiri dan manager dari TokoShiSop meminta agar dicarikan beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.
Agar file “Laporan-TokoShiSop.tsv” dapat diolah menggunakan awk, field separator yang digunakan adalah `\t`. Maka dari itu, digunakan command `awk -F '\t'`. Selanjutnya, untuk setiap subsoal (2a sampai 2d), baris yang digunakan adalah baris ke-2 sampai baris terakhir karena baris ke-1 hanya berisi header. Maka dari itu, digunakan statement if seperti berikut.

```
if(NR > 1) {
    ...
}
```

Keterangan field dari data penjualan “Laporan-TokoShiSop.tsv” adalah sebagai berikut.

```
# Keterangan field
# $1 = Row ID
# $2 = Order ID
# $3 = Order Date
# $4 = Ship Date
# $5 = Ship Mode
# $6 = Customer ID
# $7 = Customer Name
# $8 = Segment
# $9 = Country
# $10 = City
# $11 = State
# $12 = Postal Code
# $13 = Region
# $14 = Product ID
# $15 = Category
# $16 = Sub-Category
# $17 = Product Name
# $18 = Sales
# $19 = Quantity
# $20 = Discount
# $21 = Profit
```

### Soal 2a
Diminta untuk mencari Row ID dan profit percentage terbesar dan jika profit percentage terbesar lebih dari satu, maka gunakan Row ID yang terbesar. Rumus:

<img src="https://render.githubusercontent.com/render/math?math=profit percentage = (profit \div cost price) \times 100">

<img src="https://render.githubusercontent.com/render/math?math=cost price = sales - profit">

**Solusi:**

Pertama, dibuatkan fungsi untuk menghitung profit percentage, cost price, dan profit ratio seperti berikut.

```
#fungsi untuk menghitung cost price
function cost_price(s, p) {
    return (s - p);
}
#fungsi untuk menghitung profit ratio
function profit_ratio(p, cp) {
    return (p / cp);
}
#fungsi untuk menghitung profit percentage
function profit_percentage(pr) {
    return (pr * 100);
}
```

Rumus profit ratio:

<img src="https://render.githubusercontent.com/render/math?math=profit ratio = (profit \div cost price)">

Kedua, inisialisasi variabel yang akan digunakan dalam block BEGIN.

```
max_pr = 0;
max_row_id = 0;
```

Ketiga, untuk setiap baris yang digunakan, hitung cost price. Jika cost price tersebut tidak bernilai nol, maka cari profit ratio terbesar. Untuk mencari profit ratio terbesar, profit ratio dari baris ke-2 digunakan sebagai nilai awal yang disimpan di variabel `max_pr` dan `max_row_id` diberi nilai Row ID baris ke-2. Selanjutnya, jika ditemukan profit ratio yang lebih besar dari `max_pr`, maka perbarui nilai `max_pr` dengan profit ratio tersebut dan simpan Row IDnya ke `max_row_id`. Jika ditemukan profit ratio yang terbesar lebih dari satu, maka perbarui nilai `max_row_id` dengan Row ID terbesar.

```
#menghitung cost price
curr_cost_price = cost_price($18, $21);
#menghindari pembagian dengan 0
if(curr_cost_price != 0) {
    #mencari profit ratio terbesar
    if(NR == 2) {
        max_pr = profit_ratio($21, curr_cost_price);
        max_row_id = $1;
    }
    else {
        curr_pr = profit_ratio($21, curr_cost_price);
        if(max_pr < curr_pr) {
            max_pr = curr_pr;
            max_row_id = $1;
        }
        else if(max_pr == curr_pr && $1 > max_row_id) {
            max_row_id = $1;
        }
    }
}
```

Terakhir, dalam block END, hitung profit percentage menggunakan fungsi `profit_percentage()` dengan argumen `max_pr`. Setelah itu, cetak profit percentage terbesar dan Row IDnya.

```
printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %d%%.\n", 
max_row_id, profit_percentage(max_pr));
```

**Kendala**

* `cost_price` dapat bernilai 0 yang menyebabkan profit percentage tidak bisa dihitung karena pembagian dengan 0. Solusinya adalah memeriksa terlebih dahulu apakah `cost_price` = 0. Jika tidak, maka dapat lanjut ke perhitungan profit percentage.

### Soal 2b
Diminta mencari nama customer pada transaksi tahun 2017 di kota Albuquerque.

**Solusi:**

Pertama, pisahkan tanggal, bulan, dan tahun menggunakan fungsi split() dan hasilnya disimpan ke dalam array `date`. Selanjutnya, periksa apakah tahun (`date[3]`) adalah 17 dan apakah kotanya adalah "Albuquerque". Jika kedua syarat tersebut terpenuhi, tambahkan nilai dalam array `customers` di indeks `customer name` dengan satu. `customer name` adalah string nama customer.

```
#split tanggal dengan delimiter "-" dan menyimpan hasilnya dalam array "date"
split($3, date, "-");
#jika tahun dari tanggal adalah 2017 dan kotanya adalah "Albuquerque"
if(date[3] == 17 && $10 == "Albuquerque") {
    customers[$7] += 1;
}
```

Terakhir, cetak nama customer yang menjadi key dalam array `customers`.

```
print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:";
for(customer in customers) {
    print customer;
}
```

**Kendala**

* Memisahkan tahun dari tanggal dalam field `order date`. Solusinya adalah menggunakan fungsi `split()`

### Soal 2c
Diminta mencari segment customer dan jumlah transaksinya yang paling sedikit.

**Solusi:**

Pertama, inisialisasi variabel yang akan digunakan dalam block BEGIN.

```
flag_ts = 0;
min_ts = 0;
```

Selanjutnya, hitung jumlah transaksi dari setiap segment. Untuk setiap baris yang digunakan, tambahkan nilai dalam array `transactions` di indeks `segment` dengan satu. `segment` adalah string "Home Office", "Customer", atau "Corporate".

```
#menghitung jumlah transaksi segment 
transactions[$8] += 1;
```

Terakhir, cari jumlah transaksi yang paling sedikit dalam array `transactions`. Nilai awal yang digunakan adalah data yang dapat diakses saat iterasi pertama dan nilai awal tersebut disimpan dalam `min_ts` dan keynya disimpan di `segment`. `flag_ts` berfungsi sebagai penanda bahwa data awal tersebut sudah diambil. Untuk setiap data, jika terdapat jumlah transaksi yang lebih kecil dari nilai `min_ts`, maka perbarui `min_ts` dengan jumlah transaksi tersebut dan perbarui `segment` dengan nama segment yang memiliki jumlah transaksi tersebut. Setelah perulangan selesai, cetak string `segment` dan nilai `min_ts`.

```
#mencari jumlah transaksi segment yang paling sedikit
for(i in transactions) {
    if(flag_ts == 0) {
        min_ts = transactions[i];
        segment = i;
        flag_ts = 1;
    }
    else if(min_ts > transactions[i]) {
        min_ts = transactions[i];
        segment = i;
    }
}
printf("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n", segment, min_ts);
```

**Kendala**
* Tidak ada

### Soal 2d
Diminta mencari wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut.

**Solusi:**

Pertama, inisialisasi variabel yang akan digunakan dalam block BEGIN.

```
flag_p = 0;
min_p = 0;
```

Selanjutnya, hitung total profit dari setiap region. Untuk setiap baris yang digunakan, tambahkan nilai dalam array `profits` di indeks `region` dengan nilai `profit` yang berada di field ke-21. `region` adalah string "Central", "East", "South", atau "West".

```
#menghitung total profit region
profits[$13] += $21;
```

Terakhir, cari total profit yang paling sedikit dalam array `profits`. Nilai awal yang digunakan adalah data yang dapat diakses saat iterasi pertama dan nilai awal tersebut disimpan dalam `min_p` dan keynya disimpan di `region`. `flag_p` berfungsi sebagai penanda bahwa data awal tersebut sudah diambil. Untuk setiap data, jika terdapat total profit yang lebih kecil dari nilai `min_p`, maka perbarui `min_p` dengan total profit tersebut dan perbarui `region` dengan nama region yang memiliki total profit tersebut. Setelah perulangan selesai, cetak string `region` dan nilai `min_p`.

```
#mencari total keuntungan wilayah yang paling sedikit
for(i in profits) {
    if(flag_p == 0) {
        min_p = profits[i];
        region = i;
        flag_p = 1;
    }
    else if(min_p > profits[i]) {
        min_p = profits[i];
        region = i;
    }
}
printf("Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %f\n", region, min_p);
```

**Kendala**
* Tidak ada

### Soal 2e
Diminta mengeluarkan hasil dari soal 2a sampai soal 2d dalam satu file yang bernama “hasil.txt”.

**Solusi:**

Pada bagian akhir script diberi redirection.

```
> hasil.txt
```

**Kendala**
* Tidak ada

## Soal 3
Kuuhaku adalah orang yang sangat suka mengoleksi foto-foto digital, namun Kuuhaku juga merupakan seorang yang pemalas sehingga ia tidak ingin repot-repot mencari foto, selain itu ia juga seorang pemalu, sehingga ia tidak ingin ada orang yang melihat koleksinya tersebut, sayangnya ia memiliki teman bernama Steven yang memiliki rasa kepo yang luar biasa. Kuuhaku pun memiliki ide agar Steven tidak bisa melihat koleksinya, serta untuk mempermudah hidupnya.

### Soal 3a
Diminta untuk mengunduh 23 gambar dari "https://loremflickr.com/320/240/kitten" serta menyimpan log-nya ke file "Foto.log". Apabila mengunduh gambar yang sama, maka gambar tersebut dihapus tanpa harus mengganti dengan gambar yang baru. Kemudian menyimpan gambar-gambar tersebut dengan format nama “Koleksi_XX” dengan nomor yang berurutan tanpa ada nomor yang hilang.

**Solusi:**

Pertama, inisialisasi variabel `N` dan `sama`. Variabel `N` digunakan untuk membatasi jumlah file dan juga digunakan untuk memberi nama pada file gambar. Sedangkan variabel `sama` digunakan untuk menghitung dan menyimpan berapa jumlah file yang sama pada variabel tersebut.

```
N=23
sama=0
```

Selanjutnya, dilakukan perulangan sebanyak `N` kali dan melakukan proses pengunduhan dan pencatatan log di file Foto.log. Apabila `i` kurang dari 10, maka file diberi nama Koleksi_0i. Sedangkan apabila `i` lebih dari sama dengan 10, maka file diberi nama Koleksi_i.

```
for((i=1;i<=N;i=i+1))
do
	if ((i<10))
	then
		wget -O Koleksi_0$i.jpg -a Foto.log https://loremflickr.com/320/240/kitten
		...
	else
		wget -O Koleksi_$i.jpg -a Foto.log https://loremflickr.com/320/240/kitten
		...
	fi
done
```

Kemudian, dilakukan pengecekkan apakah gambar yang terakhir diunduh sama dengan salah satu dari gambar-gambar yang telah diundah sebelumnya. Pengecekkan dilakukan dengan cara membandingkan dua file gambar dan mengecek apakah command `cmp file.jpg file2.jpg` berjalan dengan semestinya (tidak ada error). Jika command tersebut tidak terjadi error maka kedua file gambar yang dibandingkan terbukti sama dan command `x=$?` akan menghasilkan nilai 0(nol).

Apabila `i` < 10

```
...
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
...
```

Apabila `i` >= 10 : 
```
...
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
```

### Soal 3b
Diminta untuk menjalankan script pada soal 3a secara otomatis sehari sekali pada jam 8 malam untuk tanggal-tanggal tertentu, yaitu dari tanggal 1 tujuh hari sekali dan dari tanggal 2 empat hari sekali. Kemudian, file gambar yang sudah diunduh beserta log-nya dipindah ke folder dengan nama tanggal unduh dengan format "DD-MM-YYYY".

**Solusi:**

Pertama, buat file bash yang berisi command untuk menjalankan file bash dari soal 3a. Kemudian buat folder atau directory bernama tanggal unduh. Lalu pindahkan semua file gambar dan file log ke dalam folder yang telah dibuat.

```
#!/bin/bash

bash ./soal3a.sh
now=$(date +"%d-%m-%Y")
mkdir "$now"
mv ./Koleksi_* "./$now/"
mv ./Foto.log "./$now/"
```

Lalu jalankan command di atas secara otomatis menggunakan crontab seperti yang tertulis di bawah ini

```
0 20 1-31/7,2-31/4 * * /bin/bash /home/dwinanda/SISOP/Modul1/soal3b.sh
```

### Soal 3c
Diminta untuk mengunduh gambar kelinci ("https://loremflickr.com/320/240/bunny") dan kucing ("https://loremflickr.com/320/240/kitten") seperti pada poin sebelumnya secara bergantian setiap hari dan memasukkannya ke dalam folder dengan nama "Kelinci_" atau "Kucing_" kemudian diikuti dengan tanggal unduh dengan format "DD-MM-YYYY"

**Solusi:**

Pertama, inisialisasi variabel `N` dan `sama`. Variabel `N` digunakan untuk membatasi jumlah file dan juga digunakan untuk memberi nama pada file gambar. Sedangkan variabel `sama` digunakan untuk menghitung dan menyimpan berapa jumlah file yang sama pada variabel tersebut.

```
N=23
sama=0
```

Kemudian, inisialiasi variabel `now` dan `yest` untuk menyimpan tanggal hari ini dan kemarin sesuai format nama folder yang diminta.

```
now=$(date +"%d-%m-%Y")
yest=$(date -d yesterday +"%d-%m-%Y")
```

Lalu, dilakukan pengecekkan apakah terdapat folder bernama `Kelinci_$yest`. Apabila ditemukan, maka `salah=$?` akan bernilai 0(nol) dan akan dilakukan pembuatan folder bernama `Kucing_$now`. Kemudian dilakukan proses pengunduhan dan pengecekkan gambar yang sama dengan cara seperti pada nomer 3a. Lalu, semua gambar yang telah diunduh beserta log foto dimasukkan ke folder yang telah dibuat.

```
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
```

Lalu, apabila `Kelinci_$yest` tidak ditemukan, maka `salah=$?` akan bernilai selain 0(nol) dan akan dilakukan proses pengunduhan gambar kelinci dengan cara yang sama seperti di atas, namun terdapat perbedaan di bagian nama folder dan link unduhnya.

```
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
```

### Soal 3d
Diminta untuk memindahkan seluruh folder ke zip yang diberi nama `Koleksi.zip` dan menguncinya dengan password berupa tanggal saat ini dengan format "MMDDYYYY".

**Solusi:**

Jalankan command `zip` dengan diikuti `-P` untuk memberi password dengan diikuti dengan `date +"%m%d%Y"` untuk mengatur password sesuai dengan format yang diminta. Kemudian diikuti dengan `-r` dan `-m` untuk mengompres semua file dan memindahkannya kedalam zip dengan nama `Koleksi.zip` dan masukkan semua folder yang memiliki awalan nama `Kucing` atau `Kelinci` 

```
#!/bin/bash

zip -P `date +"%m%d%Y"` -r -m  Koleksi.zip ./Kucing* ./Kelinci*
```

### Soal 3e
Diminta untuk zip semua koleksi gambar secara otomatis setiap hari senin hingga jumat, dari jam 7 pagi sampai 6 sore, lalu unzip semua koleksi gambar pada selain waktu tersebut dan tidak ada file zip sama sekali.

**Solusi:**

Lakukan zip pada semua folder gambar dengan awalan `Kucing` dan `Kelinci` dengan menggunakan command yang sama seperti pada poin soal sebelumnya dan jalankan secara otomatis dengan menggunakan crontab dengan mengaturnya agar berjalan setiap hari senin hingga jumat pukul 7 pagi.

```
0 7 * * 1-5 zip -P `date +"%m%d%Y"` -r -m Koleksi.zip ./Kucing* ./Kelinci*
```

Kemudian, unzip file `Koleksi.sip` dengan memasukkan password saat ini dan jalankan secara otomatis dengan menggunakan crontab dengan mengaturnya agar berjalan setiap hari senin hingga jumat pukul 6 sore(18) dan hapus file `Koleksi.zip`.

```
0 18 * * 1-5 unzip -P `date +"%m%d%Y"` Koleksi.zip && rm Koleksi.zip
```

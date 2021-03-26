# soal-shift-sisop-modul-1-C01-2021
## Anggota Kelompok C01
* Fais Rafii Akbar Hidiya 05111940000026 (mengerjakan soal nomor 1)
* Daniel Sugianto         05111940000075 (mengerjakan soal nomor 2)
* Dwinanda Bagoes Ansori  05111940000010 (mengerjakan soal nomor 3)

## Soal 1

## Soal 2
Pendiri dan manager dari TokoShiSop meminta agar dicarikan beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.
Agar file “Laporan-TokoShiSop.tsv” dapat diolah menggunakan awk, field separator yang digunakan adalah `\t`. Maka dari itu, digunakan command `awk -F '\t'`. Selanjutnya, untuk setiap subsoal (2a sampai 2d), baris yang digunakan adalah baris ke-2 sampai baris terakhir karena baris ke-1 hanya berisi header. Maka dari itu, digunakan statment if seperti berikut.

```
if(NR > 1) {
    ...
}
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

Ketiga, untuk setiap baris yang digunakan, hitung cost price. Jika cost price tersebut tidak bernilai nol, maka cari profit ratio terbesar. Untuk mencari profit ratio terbesar, profit ratio dari baris ke-2 digunakan sebagai nilai awal yang disimpan di variabel `max_pr` dan `max_row_id` diberi nilai Row ID baris ke-2. Selanjutnya, jika ditemukan profit ratio yang lebih besar dari `max_pr`, maka perbarui nilai `max_pr` dengan profit ratio tersebut dan simpan Row IDnya ke `max_row_id`. Jika ditemukan profit ratio yang terbesar lebih dari satu, maka perbarui nilai `max_row_id` dengan Row IDnya.

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
        else if(max_pr == curr_pr) {
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

### Soal 2b
Diminta mencari nama customer pada transaksi tahun 2017 di kota Albuquerque.

**Solusi:**

Pertama, pisahkan tanggal, bulan, dan tahun menggunakan fungsi split() dan hasilnya disimpan ke dalam array `date`. Selanjutnya, periksa apakah tahun (`date[3]`) adalah 17 dan apakah kotanya adalah "Albuquerque". Jika kedua syarat tersebut terpenuhi, tambahkan nilai dalam array `customers` di indeks `customer name` dengan satu. Indeks `customer name` adalah string nama customer.

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

### Soal 2c
Diminta mencari segment customer dan jumlah transaksinya yang paling sedikit.

**Solusi:**

Pertama, inisialisasi variabel yang akan digunakan dalam block BEGIN.

```
flag_ts = 0;
min_ts = 0;
```

Selanjutnya, hitung jumlah transaksi dari setiap segment. Untuk setiap baris yang digunakan, tambahkan nilai dalam array `transactions` di indeks `segment` dengan satu. Indeks `segment` adalah string "Home Office", "Customer", atau "Corporate".

```
#menghitung jumlah transaksi segment 
transactions[$8] += 1;
```

Terakhir, cari jumlah transaksi yang paling sedikit dalam array `transactions`. Nilai awal yang digunakan adalah data yang dapat diakses saat iterasi pertama dan `flag_ts` berfungsi sebagai penanda bahwa data awal tersebut sudah diambil. Untuk setiap data, jika terdapat jumlah transaksi yang lebih kecil dari nilai `min_ts`, maka perbarui `min_ts` dengan jumlah transaksi tersebut dan perbarui `segment` dengan nama segment yang memiliki jumlah transaksi tersebut. Setelah perulangan selesai, cetak string `segment` dan nilai `min_ts`.

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

### Soal 2d
Diminta mencari wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut.

**Solusi:**

Pertama, inisialisasi variabel yang akan digunakan dalam block BEGIN.

```
flag_p = 0;
min_p = 0;
```

Selanjutnya, hitung total profit dari setiap region. Untuk setiap baris yang digunakan, tambahkan nilai dalam array `profits` di indeks `region` dengan nilai `profit` yang berada di field ke-21. Indeks `region` adalah string "Central", "East", "South", atau "West".

```
#menghitung total profit region
profits[$13] += $21;
```

Terakhir, cari total profit yang paling sedikit dalam array `profits`. Nilai awal yang digunakan adalah data yang dapat diakses saat iterasi pertama dan `flag_p` berfungsi sebagai penanda bahwa data awal tersebut sudah diambil. Untuk setiap data, jika terdapat total profit yang lebih kecil dari nilai `min_p`, maka perbarui `min_p` dengan total profit tersebut dan perbarui `region` dengan nama region yang memiliki total profit tersebut. Setelah perulangan selesai, cetak string `region` dan nilai `min_p`.

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

### Soal 2e
Diminta mengeluarkan hasil dari soal 2a sampai soal 2d dalam satu file yang bernama “hasil.txt”.

**Solusi:**

Pada bagian akhir script diberi redirection.

```
> hasil.txt
```

## Soal 3
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

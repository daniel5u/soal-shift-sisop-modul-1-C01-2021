# soal-shift-sisop-modul-1-C01-2021
## Anggota Kelompok C01
* Fais Rafii Akbar Hidiya 05111940000026 (mengerjakan soal nomor 1)
* Daniel Sugianto         05111940000075 (mengerjakan soal nomor 2)
* Dwinanda Bagoes Ansori  05111940000010 (mengerjakan soal nomor 3)

## Soal 1
Ryujin sebagai IT Support Perusahaan Bukapedia diminta untuk membuat 2 laporan harian untuk aplikasi internal perusahaan yang bernama ticky, yaitu daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky.Langkah pertama yang harus dilakukan yaitu melihat syslog.log kemudian di read menggunakan $(cat syslog.log) kemudian dilakukan loop/iterasi

### Soal 1a
Diminta Mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya.


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


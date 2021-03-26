# soal-shift-sisop-modul-1-C01-2021
## Anggota Kelompok C01
* Fais Rafii Akbar Hidiya 05111940000026 (mengerjakan soal nomor 1)
* Daniel Sugianto         05111940000075 (mengerjakan soal nomor 2)
* Dwinanda Bagoes Ansori  05111940000010 (mengerjakan soal nomor 3)

## Soal 1

## Soal 2
Pendiri dan manager dari TokoShiSop meminta agar dicarikan beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.
Agar file “Laporan-TokoShiSop.tsv” dapat diolah menggunakan awk, field separator yang digunakan adalah `\t`. Maka dari itu, digunakan command `awk -F '\t'`. Selanjutnya, untuk setiap subsoal (2a sampai 2d), baris yang digunakan adalah baris ke-2 sampai baris terakhir karena baris ke-1 hanya berisi header, maka digunakan statment if seperti berikut.

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

Ketiga, untuk setiap baris yang digunakan, hitung cost price. Jika cost price tersebut tidak bernilai nol, maka cari profit ratio terbesar. Untuk mencari profit ratio terbesar, profit ratio dari baris ke-2 digunakan sebagai nilai awal yang disimpan di variabel `max_pr` dan `max_row_id` diberi nilai Row ID baris ke-2. Selanjutnya, jika ditemukan profit ratio yang lebih besar dari `max_pr`, maka perbarui nilai `max_pr` dengan profit ratio tersebut dan simpan Row IDnya ke `max_row_id`. Terakhir, jika ditemukan profit ratio yang terbesar lebih dari satu, maka perbarui nilai `max_row_id` dengan Row IDnya.

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
### Soal 2c
### Soal 2d
### Soal 2e
## Soal 3

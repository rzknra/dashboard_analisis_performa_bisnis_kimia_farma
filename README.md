# Dashboard Analisis Performa Bisnis Kimia Farma Tahun 2020-2023

## Latar Belakang
Industri farmasi terus berkembang pesat, sehingga perusahaan seperti Kimia Farma perlu memahami tren bisnisnya secara akurat. Untuk memastikan strategi yang tepat, maka pendapatan, laba, produk, dan transaksi harus dianalisis secara mendalam. Namun, tanpa alat yang efektif, memahami pola bisnis bisa menjadi tantangan.
Untuk menjawab tantangan tersebut, dikembangkan sebuah dashboard interaktif yang membantu Kimia Farma dalam menganalisis performa bisnisnya selama periode 2020-2023. Dashboard ini menggunakan Looker Studio dan BigQuery untuk mengolah data secara sistematis, menyajikan visualisasi yang informatif, serta mendukung pengambilan keputusan berbasis data.

## Rumusan Masalah
Agar dashboard ini benar-benar menjawab kebutuhan bisnis, dirumuskan beberapa pertanyaan utama.
- Berapa total pendapatan kotor, pendapatan bersih, dan laba bersih yang diperoleh kimia farma pada tahun 2020-2023?
- Berapa total transaksi, produk, dan cabang yang dipunyai kimia farma pada tahun 2020-2023? 
- Bagaimana kontribusi masing-masing jenis produk terhadap pendapatan bersih perusahaan?
- Bagaimana distribusi pendapatan dan laba bersih di berbagai cabang provinsi di Indonesia?
- Bagaimana performa transaksi di berbagai cabang provinsi di Indonesia?
- Apakah terdapat cabang yang memiliki rating cabang tinggi tetapi mempunyai rating transaksi rendah?

## Langkah-Langkah

Langkah-langkah yang dilakukan dibagi menjadi 2, yaitu:
- Langkah-langkah di Google BigQuery
- Langkah-langkah di Looker Studio

### 1. Langkah-langkah di Google BigQuery  
1. Membuat **skema** `Rakamin-KF-Analytics` dan **dataset** `kimia_farma`.  
2. Mengunggah **4 tabel** ke dataset `kimia_farma`, yaitu:  
   - `kf_transaction_final.csv`  
   - `kf_product.csv`  
   - `kf_kantor_cabang.csv`
   - `kf_inventory.csv`
3. Menghitung **missing value** pada ke empat tabel tersebut dengan mengggunakan query di bawah ini. Ditemukan **kesimpulan** bahwa ke empat tabel tidak mempunyai missing value.
```
-- Menghitung missing value tabel kf_final_transaction

SELECT

COUNT(*) AS total_rows,

  -- Kolom - kolom
  COUNTIF(transaction_id IS NULL) AS transaction_id,
  COUNTIF(date IS NULL) AS missing_date,
  COUNTIF(branch_id IS NULL) AS missing_branch_id,
  COUNTIF(customer_name IS NULL) AS missing_customer_name,
  COUNTIF(product_id IS NULL) AS missing_product_id,
  COUNTIF(price IS NULL) AS missing_price,
  COUNTIF(discount_percentage IS NULL) AS missing_discount_percentage,
  COUNTIF(rating IS NULL) AS missing_rating,

FROM `rakamin-kf-analytics-453103.kimia_farma.kf_final_transaction`
```

```
-- Menghitung missing value tabel kf_inventory

SELECT  

COUNT(*) AS total_rows,

  -- Kolom - kolom
  COUNTIF(Inventory_ID IS NULL) AS missing_Inventory_ID,
  COUNTIF(branch_id IS NULL) AS missing_branch_id,
  COUNTIF(product_id IS NULL) AS missing_product_id,
  COUNTIF(product_name IS NULL) AS missing_product_name,
  COUNTIF(opname_stock IS NULL) AS missing_opname_stock,

FROM `rakamin-kf-analytics-453103.kimia_farma.kf_inventory` 
```

```
-- Menghitung missing value tabel kf_kantor_cabang

SELECT 

  COUNT(*) AS total_rows,

  -- Kolom - kolom
  COUNTIF(branch_id IS NULL) AS missing_branch_id,
  COUNTIF(branch_category IS NULL) AS missing_branch_category,
  COUNTIF(branch_name IS NULL) AS missing_branch_name,
  COUNTIF(kota IS NULL) AS missing_kota,
  COUNTIF(provinsi IS NULL) AS missing_provinsi,
  COUNTIF(rating IS NULL) AS missing_rating,

FROM `rakamin-kf-analytics-453103.kimia_farma.kf_kantor_cabang` 
```

```
-- Menghitung missing value tabel kf_product

SELECT

  COUNT(*) AS total_rows,

  -- Kolom - kolom
  COUNTIF(product_id IS NULL) AS missing_product_id,
  COUNTIF(product_name IS NULL) AS missing_product_name,
  COUNTIF(product_category IS NULL) AS missing_product_category,
  COUNTIF(price IS NULL) AS misssing_price,

FROM `rakamin-kf-analytics-453103.kimia_farma.kf_product` 
```


4. Mengecek **data duplikat** pada ke empat tabel tersebut dengan menggunakan query berikut. Ditemukan **kesimpulan** bahwa ke empat tabel tidak mempunyai data duplikat.
```
-- Mengecek data duplikat tabel kf_final_transaction

SELECT 
    transaction_id, date, branch_id, customer_name, product_id, 
    price, discount_percentage, rating,
    COUNT(*) AS duplicate_count
FROM `rakamin-kf-analytics-453103.kimia_farma.kf_final_transaction`
GROUP BY 
    transaction_id, date, branch_id, customer_name, product_id, 
    price, discount_percentage, rating
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
```
```
-- Mengecek data duplikat tabel kf_inventory

SELECT 
    Inventory_ID, branch_id, product_id, product_name, opname_stock,
    COUNT(*) AS duplicate_count
FROM `rakamin-kf-analytics-453103.kimia_farma.kf_inventory`
GROUP BY 
    Inventory_ID, branch_id, product_id, product_name, opname_stock
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
```

```
-- Mengecek data duplikat tabel kf_kator_cabang

SELECT 
    branch_id, branch_category, branch_name, kota, provinsi, rating,
    COUNT(*) AS duplicate_count
FROM `rakamin-kf-analytics-453103.kimia_farma.kf_kantor_cabang`
GROUP BY 
    branch_id, branch_category, branch_name, kota, provinsi, rating
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
```

```
-- Mengecek data duplikat tabel kf_product

SELECT 
    product_id, product_name, product_category, price,
    COUNT(*) AS duplicate_count
FROM `rakamin-kf-analytics-453103.kimia_farma.kf_product`
GROUP BY 
    product_id, product_name, product_category, price
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

```

**Kesimpulan:** Berdasarkan kesimpulan langkah nomor 4 dan 5, maka **ke empat tabel tersebut telah bersih** sehingga bisa digunakan untuk proses selanjutnya, yaitu **penggabungan tabel**.

6. Menggabungkan tabel dengan menjalankan query dibawah ini sehingga tercipta tabel baru bernama `performa_kimia_farma_2`. Tabel ini terdiri dari **17 kolom** dan **672.458 baris**.
   
```
-- Menghitung nett sales, nett profit, dan metrik lainnya

SELECT
      ft.transaction_id,
      ft.date,
      kc.branch_id,
      kc.branch_name,
      kc.provinsi,
      kc.kota,
      kc.rating AS rating_cabang,
      ft.customer_name,
      ft.product_id,
      p.product_name,
      ft.price AS actual_price,
      ft.discount_percentage,

      -- Menentukan persentase_gross_laba berdasarkan harga obat
      CASE 
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
        WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
        WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
        ELSE 0.30
      END AS persentase_gross_laba,

      -- Menghitung nate_sales (harga setelah diskon)
      ft.price * (1 - ft.discount_percentage) AS nett_sales,

      -- Menghitung nett profit 
      (ft.price * (1 - ft.discount_percentage)) * 
      CASE 
          WHEN ft.price <= 50000 THEN 0.10
          WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
          WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
          WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
          ELSE 0.30
      END AS nett_profit,     

      ft.rating AS rating_transaksi, 

-- Melakukan join tabel 
FROM `rakamin-kf-analytics-453103.kimia_farma.kf_final_transaction` ft
INNER JOIN `rakamin-kf-analytics-453103.kimia_farma.kf_product` p
    ON ft.product_id = p.product_id
INNER JOIN `rakamin-kf-analytics-453103.kimia_farma.kf_kantor_cabang` kc
    ON ft.branch_id = kc.branch_id

```
7. Mengecek **missing value dan data duplikat** pada tabel **performa_kimia_farma_2** dengan menjalalankan query di bawah ini. Ditemukan **kesimpulan** bahwa tabel performa_kimia_farma_2 **tidak mempunyai missing value dan data duplikat**. Oleh karena itu, tabel ini selanjutnya bisa diolah di Looker Studio untuk dijadikan dashbooard.
```
-- Mengecek missing value tabel peforma_kimia_farma_2

SELECT 
  COUNT(*) AS total_rows,

  -- Kolom - kolom
  COUNTIF(transaction_id IS NULL) AS missing_transaction_id,
  COUNTIF(date IS NULL) AS missing_date,
  COUNTIF(branch_id IS NULL) AS missing_branch_id,
  COUNTIF(branch_name IS NULL) AS missing_branch_name,
  COUNTIF(provinsi IS NULL) AS missing_provinsi,
  COUNTIF(kota IS NULL) AS missing_kota,
  COUNTIF(rating_cabang IS NULL) AS missing_rating_cabang,
  COUNTIF(customer_name IS NULL) AS missing_customer_name,
  COUNTIF(product_id IS NULL) AS missing_product_id,
  COUNTIF(product_name IS NULL) AS missing_product_name,
  COUNTIF(actual_price IS NULL) AS missing_actual_price,
  COUNTIF(discount_percentage IS NULL) AS missing_discount_percentage,
  COUNTIF(persentase_gross_laba IS NULL) AS missing_persentase_gross_laba,
  COUNTIF(nett_sales IS NULL) AS missing_nett_sales,
  COUNTIF(nett_profit IS NULL) AS missing_nett_profit,
  COUNTIF(rating_transaksi IS NULL) AS missing_rating_transaksi,
  
FROM `rakamin-kf-analytics-453103.kimia_farma.performa_kimia_farma_2` 
```

```
-- Mengecek data duplikat tabel peforma_kimia_farma_2

SELECT 
    transaction_id, date, branch_id, branch_name, provinsi, kota, 
    rating_cabang, customer_name, product_id, product_name, 
    actual_price, discount_percentage, persentase_gross_laba, 
    nett_sales, nett_profit, rating_transaksi,
    COUNT(*) AS duplicate_count
FROM `rakamin-kf-analytics-453103.kimia_farma.performa_kimia_farma_2`
GROUP BY 
    transaction_id, date, branch_id, branch_name, provinsi, kota, 
    rating_cabang, customer_name, product_id, product_name, 
    actual_price, discount_percentage, persentase_gross_laba, 
    nett_sales, nett_profit, rating_transaksi
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

```

### 2. Langkah-langkah di Looker Studio  
1. Membuat **canvas baru** di Looker Studio.  
2. Menambahkan **tabel `performa_kimia_farma_2`** sebagai sumber data di Looker Studio lewat Google BigQuery.  
3. Membuat **judul utama dashboard**.  
4. Membuat **deskripsi dashboard** untuk menjelaskan tujuan dan isi dashboard.  
5. Membuat **filter interaktif** untuk memudahkan eksplorasi data berdasarkan **tahun, provinsi, cabang, dan produk**.  
6. Membuat **KPI Cards** untuk menampilkan:  
   - **Total Pendapatan Kotor**  
   - **Pendapatan Bersih**  
   - **Laba Bersih**  
   - **Jumlah Transaksi**  
   - **Jumlah Produk**  
   - **Jumlah Cabang**  
7. Membuat **Line Chart** untuk menampilkan **tren pendapatan bersih dari tahun 2020-2023**.  
8. Membuat **Pivot Table with Bar Chart** untuk menampilkan:  
     - **Top 10 pendapatan bersih cabang per provinsi**  
     - **Top 10 total transaksi cabang per provinsi**  
9. Membuat **Donut Chart** untuk menampilkan **proporsi produk terhadap pendapatan bersih**.  
10. Membuat **Geo Map** untuk menampilkan **total laba bersih per provinsi**.  
11. Membuat **Pivot Table** untuk menampilkan **Top 5 cabang dengan rating tertinggi tetapi memiliki rating transaksi terendah**.
12. Mengubah nama kolom dari **bahasa inggris ke bahasa indonesia**  
13. Menambahkan **judul untuk setiap kartu (card) dan chart** agar lebih jelas dan informatif.  
14. Menggunakan **kombinasi warna biru dan abu-abu** pada kartu dan chart untuk menciptakan **visualisasi yang menarik dan profesional**.

## Hasil
Dihasilkan dashboard analasis perrforma bisnis kimia farma tahun 2020-2023 berikut ini.
![Dashboard_Kimia_Farma (4)](https://github.com/user-attachments/assets/b8f5d33e-57a9-4752-9936-1cb44cc694dd)

## Temuan Utama dan/atau Rekomendasi 

### Tren Total Pendapatan Kotor, Pendapatan Bersih, Laba Beris
- **Temuan:**
   - Pendapatan Kotor dan Bersih

     - Pendapatan kotor: 347,2 miliar
      - Pendapatan bersih: 321,2 miliar
      - Selisih pendapatan kotor dan bersih relatif kecil, yang menunjukkan bahwa biaya operasional dan potongan lainnya cukup terkendali.

  - Laba Bersih

       - Laba bersih tercatat 91,2 miliar, yang berarti margin laba bersih sekitar 28,4% dari pendapatan bersih.
       - Ini adalah indikator profitabilitas yang cukup baik, namun perlu dievaluasi lebih lanjut apakah ada potensi peningkatan efisiensi biaya.

       
### Tren Banyak Transaksi, Produk, dan Cabang 
- **Temuan:**
  - Jumlah Transaksi, Produk, dan Cabang
      - 672,5 ribu transaksi menunjukkan volume penjualan yang besar.
      - Kimia Farma memiliki 150 jenis produk, yang bisa menjadi indikasi diversifikasi portofolio produk.
      - Terdapat 1.700 cabang, yang menunjukkan skala operasi yang luas di berbagai wilayah.


### Tren Pendapatan Bersih
- **Temuan:** Pendapatan bersih relatif stabil (sekitar 80 miliar) dari 2020-2023 dengan sedikit fluktuasi  
- **Rekomendasi:** Pelajari lebih dalam faktor-faktor yang mempengaruhi tren bisnis dan temukan strategi terbaik untuk meningkatkan pertumbuhan di tahun depan.

### Kontribusi Jenis Produk
- **Temuan:** Produk dengan kontribusi tertinggi adalah Psycholeptics Drugs (terutama hypnotic, sedative, dan anxiolytic drugs) dengan persentase 17,1% dan 16,5%..  
- **Rekomendasi:** Tingkatkan pemasaran dan distribusi produk dengan kontribusi besar serta evaluasi potensi peningkatan pada kategori dengan kontribusi lebih rendah.

### Distribusi Pendapatan dan Laba Bersih
- **Temuan:** Jawa Barat memiliki pendapatan dan laba bersih tertinggi dibandingkan provinsi lain.  
- **Rekomendasi:** Tingkatkan strategi bisnis di provinsi dengan kontribusi besar dan perluas pasar di wilayah yang berpotensi berkembang.

### Performa Transaksi Berdasarkan Cabang
- **Temuan:** Provinsi dengan transaksi terbanyak adalah Jawa Barat, Sumatera Utara, dan Jawa Tengah.  
- **Rekomendasi:** Tinjau kembali efisiensi operasional cabang di provinsi dengan transaksi tinggi agar keuntungan bisa lebih maksimal.

### Cabang dengan Rating Tinggi, tapi Transaksi Rendah
- **Temuan:** Beberapa cabang dengan rating 5 memiliki penilaian transaksi di bawah 4.  
- **Rekomendasi:** Identifikasi kendala transaksi di cabang tersebut, seperti proses transaksi yang kurang efisien, keterbatasan metode pembayaran, kendala dalam sistem layanan di kasir dan lainnya.

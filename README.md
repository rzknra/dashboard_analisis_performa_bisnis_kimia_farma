# Dashboard Analisis Performa Bisnis Kimia Farma Tahun 2020-2023

Dashboard ini dikembangkan untuk menganalisis performa bisnis Kimia Farma selama periode 2020-2023 dengan memanfaatkan data yang telah diolah dan diambil dari BigQuery. Dengan menggunakan visualisasi interaktif di Google Looker Studio,  dashboard ini memungkinkan pengguna untuk memahami berbagai aspek kinerja perusahaan secara lebih mendalam.

## Langkah-Langkah

### 1. Langkah-langkah di Google BigQuery  
1. Membuat **skema** `Rakamin-KF-Analytics` dan **dataset** `kimia_farma`.  
2. Mengunggah **4 tabel** ke dataset `kimia_farma`, yaitu:  
   - `kf_transaction_final.csv`  
   - `kf_product.csv`  
   - `kf_kantor_cabang.csv`
   - `kf_inventory.csv`
3. Menghitung missing value pada 4 tabel dengan mengggunakan query berikut.
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
**Kesimpulan**: Setelah dilakukan pegecekan missing value, ditemukan bahwa empat tabel tidak mempunyai missing value.

4. Mengecek data duplikat pada 4 tabel dengan menggunakan query berikut.
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
**Kesimpulan:** Setalah dilakukan pengecekan data duplikat, ternyata empat tabel tersebut tidak mempunyai data duplikat. 

Berdasarkan kesimpulan poin 4 dan 5, maka empat tabel tersebut telah bersih sehingga bisa digunakan untuk proses selanjutnya, yaitu penggabungan tabel.

6. Menjalankan query di bawah ini untuk membuat tabel baru (hasil penggabungan tabel) bernama `performa_kimia_farma_2`, Tabel ini terdiri dari **17 kolom** dan **672.458 baris**.
   
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

### 2. Langkah-langkah di Looker Studio  
4. Membuat **canvas baru** di Looker Studio.  
5. Menambahkan **tabel `performa_kimia_farma_2`** sebagai sumber data di Looker Studio lwae Google BigQuery.  
6. Membuat **judul utama dashboard**.  
7. Membuat **deskripsi dashboard** untuk menjelaskan tujuan dan isi dashboard.  
8. Membuat **filter interaktif** untuk memudahkan eksplorasi data berdasarkan **tahun, provinsi, cabang, dan produk**.  
9. Membuat **KPI Cards** untuk menampilkan:  
   - **Total Pendapatan Kotor**  
   - **Pendapatan Bersih**  
   - **Laba Bersih**  
   - **Jumlah Transaksi**  
   - **Jumlah Produk**  
   - **Jumlah Cabang**  
10. Membuat **Line Chart** untuk menampilkan **tren pendapatan bersih dari tahun 2020-2023**.  
11. Membuat **Pivot Table with Bar Chart** untuk menampilkan:  
     - **Top 10 pendapatan bersih cabang per provinsi**  
     - **Top 10 total transaksi cabang per provinsi**  
12. Membuat **Donut Chart** untuk menampilkan **proporsi produk terhadap pendapatan bersih**.  
13. Membuat **Geo Map** untuk menampilkan **total laba bersih per provinsi**.  
14. Membuat **Pivot Table** untuk menampilkan **Top 5 cabang dengan rating tertinggi tetapi memiliki rating transaksi terendah**.
15. Mengubah nama kolom dari **bahasa inggris ke bahasa indonesia**  
16. Menambahkan **judul untuk setiap kartu (card) dan chart** agar lebih jelas dan informatif.  
17. Menggunakan **kombinasi warna biru dan abu-abu** pada kartu dan chart untuk menciptakan **visualisasi yang menarik dan profesional**.

## Hasil
Dihasilkan dashboard berikut ini.
![Dashboard_Kimia_Farma (2)](https://github.com/user-attachments/assets/ac74433e-2d64-4051-a1bf-1583fb5ab32e)

## Interpretasi 

### 1. Analisis dan Temuan Utama

#### **Pendapatan Bersih Stabil**  
Pendapatan bersih Kimia Farma dari tahun 2020 hingga 2023 relatif stabil di kisaran 80 miliar rupiah per tahun. Ini menunjukkan bahwa perusahaan mampu mempertahankan performanya meskipun ada berbagai tantangan ekonomi.

#### **Provinsi dengan Transaksi dan Pendapatan Tertinggi**  
Jawa Barat, Sumatera Utara, Jawa Tengah, dan Jawa Timur mendominasi baik dalam jumlah transaksi maupun pendapatan bersih. Hal ini menunjukkan bahwa daerah-daerah ini memiliki potensi pasar yang besar untuk Kimia Farma.

### **Top 5 Cabang dengan Rating Tertinggi tetapi Rating Transaksi Rendah**
Beberapa cabang dengan rating pelanggan tinggi ternyata memiliki rating transaksi yang lebih rendah. Hal ini dapat disebabkan oleh faktor seperti proses transaksi yang kurang efisien, keterbatasan metode pembayaran, atau kendala dalam sistem layanan di kasir.

#### **Proporsi Produk terhadap Pendapatan Bersih**  
Kategori obat yang paling berkontribusi terhadap pendapatan bersih antara lain *psycholeptics drugs*, *anxiolytics*, *analgesics*, dan *antihistamines*, yang menunjukkan bahwa produk-produk ini memiliki permintaan tinggi di pasar.

#### **Geo Map Profit Bersih per Provinsi**  
Distribusi laba bersih menunjukkan bahwa beberapa provinsi memiliki profit yang jauh lebih tinggi dibandingkan yang lain. Ini bisa menjadi indikator untuk ekspansi bisnis atau optimalisasi operasional.


### 2. Kesimpulan  
- Kimia Farma berhasil menjaga pendapatan tetap stabil dari tahun ke tahun.  
- Jawa Barat dan Sumatera Utara merupakan daerah dengan performa bisnis terbaik.  
- Beberapa cabang dengan rating cabang tinggi masih mengalami rating transaksi yang rendah, menandakan potensi perbaikan pelayanan.  
- Kategori produk tertentu mendominasi pendapatan, menunjukkan peluang untuk optimalisasi produk dan strategi pemasaran.  


### 3. Rekomendasi  

#### **Optimalisasi Cabang dengan Rating Cabang Tinggi & Rating Transaksi Rendah**  
Perlu analisis lebih lanjut untuk memahami mengapa cabang dengan rating tinggi memiliki rating transaksi rendah. Kemungkinan penyebabnya adalah proses transaksi yang lambat, kesalahan input harga, keterbatasan metode pembayaran, atau sistem kasir yang kurang efisien. Meningkatkan efisiensi transaksi dan melatih staf dapat membantu memperbaiki rating tersebut

#### **Ekspansi di Wilayah dengan Potensi Tinggi**  
Mengalokasikan lebih banyak sumber daya ke provinsi dengan performa tinggi seperti Jawa Barat dan Sumatera Utara dapat meningkatkan pendapatan lebih lanjut.

#### **Strategi Produk yang Lebih Fokus**  
Karena kategori *psycholeptics drugs* dan *analgesics* menyumbang porsi terbesar dari pendapatan, Kimia Farma dapat mempertimbangkan untuk meningkatkan produksi dan pemasaran obat-obatan ini.

#### **Diversifikasi Produk untuk Provinsi dengan Profit Rendah**  
Provinsi dengan profit lebih rendah bisa menjadi target diversifikasi produk atau strategi promosi yang lebih agresif agar bisnis lebih merata di seluruh wilayah Indonesia.

-- Mengecek missing value tabel kf_final_transaction
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


-- Mengecek missing value tabel kf_inventory
SELECT  

COUNT(*) AS total_rows,

  -- Kolom - kolom
  COUNTIF(Inventory_ID IS NULL) AS missing_Inventory_ID,
  COUNTIF(branch_id IS NULL) AS missing_branch_id,
  COUNTIF(product_id IS NULL) AS missing_product_id,
  COUNTIF(product_name IS NULL) AS missing_product_name,
  COUNTIF(opname_stock IS NULL) AS missing_opname_stock,

FROM `rakamin-kf-analytics-453103.kimia_farma.kf_inventory`


-- Mengecek missing value tabel kf_kantor_cabang
SELECT 

  COUNT(*) AS total_rows,

  -- Kolom - kolom
  COUNTIF(branch_id IS NULL) AS missing_branch_id,
  COUNTIF(branch_category IS NULL) AS missing_branch_category,
  COUNTIF(branch_name IS NULL) AS missing_branch_name,
  COUNTIF(kota IS NULL) AS missing_kota,
  COUNTIF(provinsi IS NULL) AS missing_provinsi,
  COUNTIF(rating IS NULL) AS missing_rating,

FROM rakamin-kf-analytics-453103.kimia_farma.kf_kantor_cabang


-- Mengecek missing value tabel kf_product
SELECT 

  COUNT(*) AS total_rows,

  -- Kolom - kolom
  COUNTIF(product_id IS NULL) AS missing_product_id,
  COUNTIF(product_name IS NULL) AS missing_product_name,
  COUNTIF(product_category IS NULL) AS missing_product_category,
  COUNTIF(price IS NULL) AS misssing_price,

FROM `rakamin-kf-analytics-453103.kimia_farma.kf_product` 


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







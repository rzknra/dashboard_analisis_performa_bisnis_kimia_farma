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

-- Mengecek data duplikat tabel kf_inventory
SELECT 
    Inventory_ID, branch_id, product_id, product_name, opname_stock,
    COUNT(*) AS duplicate_count
FROM `rakamin-kf-analytics-453103.kimia_farma.kf_inventory`
GROUP BY 
    Inventory_ID, branch_id, product_id, product_name, opname_stock
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Mengecek data duplikat tabel kf_kantor_cabang
SELECT 
    branch_id, branch_category, branch_name, kota, provinsi, rating,
    COUNT(*) AS duplicate_count
FROM `rakamin-kf-analytics-453103.kimia_farma.kf_kantor_cabang`
GROUP BY 
    branch_id, branch_category, branch_name, kota, provinsi, rating
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Mengecek data duplikat tabel kf_product
SELECT 
    product_id, product_name, product_category, price,
    COUNT(*) AS duplicate_count
FROM `rakamin-kf-analytics-453103.kimia_farma.kf_product`
GROUP BY 
    product_id, product_name, product_category, price
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

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






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

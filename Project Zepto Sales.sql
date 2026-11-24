DROP DATABASE IF EXISTS zepto_sql_project;

CREATE DATABASE zepto_sql_project;
USE zepto_sql_project;
SELECT DATABASE();
SHOW TABLES;

CREATE TABLE zepto (
    sku_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INT,
    outOfStock BOOLEAN,
    quantity INT
);

SET SQL_SAFE_UPDATES = 0;

UPDATE zepto 
SET outOfStock = CASE 
    WHEN UPPER(outOfStock) = 'TRUE' THEN '1' 
    ELSE '0' 
END;

ALTER TABLE zepto
MODIFY category VARCHAR(120),
MODIFY name VARCHAR(150) NOT NULL,
MODIFY mrp NUMERIC(8,2),
MODIFY discountPercent NUMERIC(5,2),
MODIFY availableQuantity INTEGER,
MODIFY discountedSellingPrice NUMERIC(8,2),
MODIFY weightInGms INTEGER,
MODIFY outOfStock BOOLEAN,
MODIFY quantity INTEGER;

ALTER TABLE zepto 
ADD COLUMN sku_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- 2. DATA EXPLORATION

SELECT COUNT(*) AS total_rows FROM zepto;

SELECT * FROM zepto
LIMIT 10;

SELECT * FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR availableQuantity IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;
   
   SELECT DISTINCT category
FROM zepto
ORDER BY category;

SELECT outOfStock, COUNT(sku_id) AS product_count
FROM zepto
GROUP BY outOfStock;

SELECT name, COUNT(sku_id) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- 3. DATA CLEANING 

SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;
    
    SELECT mrp, discountedSellingPrice FROM zepto LIMIT 10;
    
    -- 4. BUSINESS DATA ANALYSIS
    
-- Q1. Find the top 10 best-value products based on the discount percentage.

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. What are the Products with High MRP (> ₹300) but Out of Stock?

SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;

-- Q3. Calculate Estimated Revenue for each category.

SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT DISTINCT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC;

-- Q7. Group the products into categories like Low, Medium, Bulk.

SELECT DISTINCT name, weightInGms,
       CASE 
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- Q8. What is the Total Inventory Weight Per Category?

SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight_gms,
       ROUND(SUM(weightInGms * availableQuantity) / 1000.0, 2) AS total_weight_kg
FROM zepto
GROUP BY category
ORDER BY total_weight_gms DESC;

-- Q9. Rank top 3 most expensive products within each category (Window Function).

WITH RankedProducts AS (
    SELECT category, 
           name, 
           discountedSellingPrice,
           DENSE_RANK() OVER(PARTITION BY category ORDER BY discountedSellingPrice DESC) AS price_rank
    FROM zepto
)
SELECT * FROM RankedProducts 
WHERE price_rank <= 3;

-- Q10. Estimated revenue lost due to out-of-stock items per category.

SELECT category,
       COUNT(sku_id) AS out_of_stock_skus,
       SUM(discountedSellingPrice * quantity) AS estimated_lost_revenue
FROM zepto
WHERE outOfStock = TRUE
GROUP BY category
ORDER BY estimated_lost_revenue DESC;

-- End Of Project--

# Zepto E-Commerce Inventory & Pricing Analysis (SQL)

## 📌 Project Overview
This project analyzes product catalog, pricing, discount strategies, and inventory availability for **Zepto**, a fast-growing Indian quick-commerce platform. Using **MySQL**, the dataset (`zepto_v2.csv`, containing 3,728 SKU records) was structured, cleaned, and queried to uncover revenue drivers, stockout bottlenecks, discount patterns, and storage requirements across product categories[cite: 10, 11].

---

## 🛠️ Tech Stack & Tools
* **Database:** MySQL (MySQL Workbench)
* **Concepts Applied:** DDL & DML, Data Cleaning, Aggregate Functions, `CASE` Statements, Common Table Expressions (CTEs), and Window Functions (`DENSE_RANK()`)

---

## 🗂️ Dataset & Database Schema
The dataset contains SKU-level product details across multiple quick-commerce categories.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `sku_id` | `INT (PK, AUTO_INCREMENT)` | Unique identifier for each SKU |
| `category` | `VARCHAR(120)` | Product category (e.g., Fruits & Vegetables, Snacks, Dairy) |
| `name` | `VARCHAR(150)` | Product name |
| `mrp` | `NUMERIC(8,2)` | Maximum Retail Price (in ₹) |
| `discountPercent` | `NUMERIC(5,2)` | Percentage discount offered on MRP |
| `availableQuantity` | `INTEGER` | Units currently available in stock |
| `discountedSellingPrice` | `NUMERIC(8,2)` | Final selling price after discount (in ₹) |
| `weightInGms` | `INTEGER` | Net weight of the product in grams |
| `outOfStock` | `BOOLEAN` | Stock status (`1` = Out of Stock, `0` = In Stock) |
| `quantity` | `INTEGER` | Standard pack/order quantity |

---

## 🧹 Data Exploration & Cleaning Workflow
Before running business analytics, the raw CSV data went through the following preprocessing steps:
1. **Schema & Data Type Standardization:** Converted text-based boolean flags (`'TRUE'` / `'FALSE'`) into native MySQL `BOOLEAN` values (`1` / `0`) and assigned an auto-incrementing `sku_id` primary key[cite: 11].
2. **Null & Duplicate Checks:** Verified completeness across all 9 attribute columns and identified multi-pack SKUs sharing identical product names[cite: 11].
3. **Invalid Record Removal:** Filtered out and removed anomalous records where `mrp = 0` or `discountedSellingPrice = 0`[cite: 11].
4. **Currency Normalization:** Converted raw pricing figures stored in **paise** into **Indian Rupees (₹)** (`mrp / 100.0` and `discountedSellingPrice / 100.0`)[cite: 11].

---

## 📊 Key Business Questions Answered
The SQL script (`Zepto_SQL_data_analysis.sql`) solves 10 core operational and pricing questions[cite: 11]:

1. **Top 10 Best-Value Products:** Identifies distinct SKUs offering the highest discount percentages[cite: 11].
2. **High-MRP Stockout Alerts:** Pinpoints premium products (`MRP > ₹300`) currently out of stock to highlight immediate revenue recovery opportunities[cite: 11].
3. **Category-Wise Estimated Revenue:** Calculates potential inventory revenue (`discountedSellingPrice * availableQuantity`) across categories[cite: 11].
4. **Premium Low-Discount Products:** Isolates high-ticket items (`MRP > ₹500`) with minimal discounting (`< 10%`), indicating strong organic demand or inelastic pricing[cite: 11].
5. **Top 5 Discounted Categories:** Ranks categories by average discount percentage to reveal promotional focus areas[cite: 11].
6. **Price-Per-Gram Value Analysis:** Evaluates cost efficiency (`discountedSellingPrice / weightInGms`) for items weighing `>= 100g`[cite: 11].
7. **Product Weight Segmentation:** Classifies SKUs into **Low (`< 1 kg`)**, **Medium (`1–5 kg`)**, and **Bulk (`>= 5 kg`)** tiers using `CASE` logic to assist dark-store picking and packing[cite: 11].
8. **Total Inventory Weight per Category:** Computes total stock weight in grams and kilograms (`weightInGms * availableQuantity`) to guide dark-store shelf and storage allocation[cite: 11].
9. **Top 3 Most Expensive Products per Category:** Uses `DENSE_RANK() OVER (PARTITION BY category ...)` to rank flagship high-priced items within every category.
10. **Estimated Lost Revenue from Stockouts:** Quantifies potential revenue tied up in out-of-stock SKUs per category.

---

## 🚀 How to Run This Project
1. Clone this repository or download `Zepto_SQL_data_analysis.sql` and `zepto_v2.csv`.
2. Open **MySQL Workbench** and create a new schema:
   ```sql
   CREATE DATABASE zepto_sql_project;
   USE zepto_sql_project;

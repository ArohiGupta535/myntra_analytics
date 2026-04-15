create database Myntra_database;
use Myntra_database;
select count(*) from dim_customer;
select count(*) from dim_product;
select count(*) from fact_returns;
select count(*) from fact_sales;
select * from fact_sales
where Discount_Band='Mid (21-35%)';

-- Total Gross Revenue
SELECT 
    SUM(Gross_Sales_Amount) AS total_gross_revenue
FROM fact_sales;

-- Total Net Revenue
SELECT 
    SUM(Net_Sales_Amount) AS total_net_revenue
FROM fact_sales;

-- Revenue Comparison
SELECT 
    SUM(Gross_Sales_Amount) AS gross_revenue,
    SUM(Net_Sales_Amount) AS net_revenue,
    SUM(Gross_Sales_Amount) - SUM(Net_Sales_Amount) AS revenue_loss
FROM fact_sales;


-- Revenue by Year
SELECT 
    Year,
    SUM(Gross_Sales_Amount) AS gross_revenue,
    SUM(Net_Sales_Amount) AS net_revenue
FROM fact_sales
GROUP BY Year
ORDER BY Year;

-- Revenue by Category
SELECT 
    p.Category,
    SUM(s.Gross_Sales_Amount) AS gross_revenue,
    SUM(s.Net_Sales_Amount) AS net_revenue
FROM fact_sales s
JOIN dim_product p 
    ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY net_revenue DESC;

-- Revenue Loss due to Returns
SELECT 
    SUM(Return_Amount) AS total_return_loss
FROM fact_returns;

-- YoY Sales Growth
SELECT 
    Year,
    SUM(Net_Sales_Amount) AS total_sales,
    LAG(SUM(Net_Sales_Amount)) OVER (ORDER BY Year) AS prev_year_sales,
    concat(ROUND(
        (SUM(Net_Sales_Amount) - LAG(SUM(Net_Sales_Amount)) OVER (ORDER BY Year)) 
        / LAG(SUM(Net_Sales_Amount)) OVER (ORDER BY Year) * 100, 2
    ),'%') AS yoy_growth_pct
FROM fact_sales
GROUP BY Year
ORDER BY Year;




-- Top 10 Products by Revenue
SELECT 
    Product_ID,
    SUM(Net_Sales_Amount) AS revenue
FROM fact_sales
GROUP BY Product_ID
ORDER BY revenue DESC
LIMIT 10;


-- Discount Impact
SELECT 
    Discount_Band,
    SUM(Net_Sales_Amount) AS total_sales,
    AVG(Selling_Price) AS avg_price
FROM fact_sales
GROUP BY Discount_Band
ORDER BY total_sales DESC;



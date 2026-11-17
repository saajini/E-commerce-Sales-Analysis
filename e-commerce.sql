create database e_commerce;
use e_commerce;
select * from customers;
select * from products;
select * from offers;
select * from orders;
select * from products P join orders O on P.Product_ID = O.Product_ID;
select sum(Total_Amount) as New_Total from orders;
select avg(Total_Amount) as Avg_Amt from orders;
select count(Quantity) from orders;
select * from orders where Discount = "10%";


SELECT 
    o.Order_ID,
    c.Customer_Name,
    p.Product_Name,
    f.Promo_Code,
    o.Quantity,
    o.Total_Amount
FROM orders o
JOIN customers c 
    ON o.Customer_ID = c.Customer_ID
JOIN products p 
    ON o.Product_ID = p.Product_ID
JOIN offers f 
    ON o.Promo_ID = f.Promo_ID
LIMIT 10;

SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Quantity) AS Units_Sold,
    SUM(Total_Amount) AS Total_Revenue
FROM orders;

SELECT
    p.Category,
    SUM(o.Total_Amount) AS Revenue
FROM orders o
JOIN products p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Revenue DESC;

SELECT
    p.Category,
    SUM(o.Quantity) AS Units_Sold
FROM orders o
JOIN products p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Units_Sold DESC;

SELECT
    p.Product_Name,
    p.Category,
    SUM(o.Total_Amount) AS Revenue
FROM orders o
JOIN products p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Category
ORDER BY Revenue DESC
LIMIT 10;

SELECT
    c.City,
    SUM(o.Total_Amount) AS Revenue
FROM orders o
JOIN customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
ORDER BY Revenue DESC;

SELECT
    c.Customer_Segment,
    SUM(o.Total_Amount) AS Revenue
FROM orders o
JOIN customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY Revenue DESC;

SELECT
    Payment_Method,
    SUM(Total_Amount) AS Revenue
FROM orders
GROUP BY Payment_Method
ORDER BY Revenue DESC;

SELECT
    f.Promo_Code,
    f.Discount_Percentage,
    SUM(o.Total_Amount) AS Revenue,
    SUM(o.Quantity) AS Units_Sold,
    COUNT(DISTINCT o.Order_ID) AS Orders
FROM orders o
JOIN offers f
    ON o.Promo_ID = f.Promo_ID
GROUP BY f.Promo_ID, f.Promo_Code, f.Discount_Percentage
ORDER BY Revenue DESC;

SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Total_Amount) AS Revenue
FROM orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month;

SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    SUM(o.Total_Amount) AS Revenue
FROM orders o
JOIN customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name, c.Customer_Segment
ORDER BY Revenue DESC
LIMIT 10;

SELECT
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Spending
FROM orders o
JOIN customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
HAVING SUM(o.Total_Amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(Total_Amount) AS customer_total
        FROM orders
        GROUP BY Customer_ID
    ) AS customer_spending
)
ORDER BY Total_Spending DESC;

WITH product_revenue AS (
    SELECT
        p.Product_ID,
        p.Product_Name,
        p.Category,
        SUM(o.Total_Amount) AS Revenue
    FROM orders o
    JOIN products p
        ON o.Product_ID = p.Product_ID
    GROUP BY
        p.Product_ID,
        p.Product_Name,
        p.Category
)
SELECT
    Product_ID,
    Product_Name,
    Category,
    Revenue,
    DENSE_RANK() OVER (
        ORDER BY Revenue DESC
    ) AS Revenue_Rank
FROM product_revenue
ORDER BY Revenue_Rank;




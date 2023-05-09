-- Finding Customers With Name Like Ben

SELECT*
FROM customer
WHERE customer_name LIKE "%ben%"
ORDER BY Customer_ID;

-- Finding names of customers that start with letter k
SELECT*
FROM customer
WHERE customer_name LIKE "k%"
ORDER BY Customer_ID;

-- Finding names of customers that start with letter C and end with letter A
SELECT*
FROM customer
WHERE customer_name LIKE "C_______________a"
ORDER BY Customer_ID;

-- Finding names of customers whose phone number ends with 9
SELECT*
FROM customer
WHERE customer_contact LIKE "%9"
ORDER BY Customer_ID;

-- Finding items all Consumer type with Region of Row 6 in Segment
SELECT*
FROM category
WHERE segment = "Consumer" AND Region = "Row 6"
ORDER BY Customer_ID;

-- Find all Employee's who work Morning Shift and were hired after 2015
SELECT*
FROM employee
WHERE shift = "Morning Shift" AND Date_of_hire > "01/01/2015"
ORDER BY Customer_ID;

-- Produce the payment methods
SELECT distinct(payment_id), (payment_name), (payment_type) 
FROM paymentmethod
ORDER BY payment_id;

-- Show the Total Sales
SELECT sum(sales) as "Total Sales"
FROM product;

-- Show the Total number of products sold
SELECT SUM(Quantity) as "Total Quantity Sold", SUM(Sales) as "Total Sales"
FROM product;

-- Top 14 most profitable products
SELECT Product_Name, Profit 
FROM product
WHERE Profit > 1000
ORDER BY Profit ASC
LIMIT 14 ;

--  Bottom 14 most profitable products
SELECT Product_Name, Profit 
FROM product
WHERE Profit <= 10
ORDER BY Profit DESC
LIMIT 14 ;

-- Find the Profit Percentage
SELECT Profit/Selling_Price*100 as "Profit Percentage", Product_Name
FROM product
ORDER BY Profit ASC;

-- Find the Top 14 Profit Percentage 
SELECT Profit/Selling_Price*100 as "Profit Percentage", Product_Name
FROM product
ORDER BY "Profit Percentage" DESC
LIMIT 14;

-- Join all tables
SELECT*
FROM product p
JOIN category ca
ON p.Customer_ID = ca.Customer_ID
JOIN customer cu 
ON p.Customer_ID = cu.Customer_ID
JOIN paymentmethod pm
ON p.Customer_ID = pm.Customer_ID
JOIN employee e 
ON p.Customer_ID = e.Customer_ID
JOIN warehouse w
ON p.Customer_ID = w.Warehouse_ID ;

-- Join all tables 2
SELECT p.Customer_ID, p.Product_Name, Cost_Price, Selling_Price, Profit, Quantity, p.Sales, 
ca.Category_Name, ca.Sub_Category, ca.Segment, ca.Region,
cu.customer_name, cu.customer_contact,
pm.payment_id, pm.payment_name, pm.payment_type,
e.Employee_ID, e.Employee_Name, e.Employee_Position, e.Date_of_hire, e.shift,
w.Warehouse_Name  
FROM product p
JOIN category ca
ON p.Customer_ID = ca.Customer_ID
JOIN customer cu 
ON p.Customer_ID = cu.Customer_ID
JOIN paymentmethod pm
ON p.Customer_ID = pm.Customer_ID
JOIN employee e 
ON p.Customer_ID = e.Customer_ID
JOIN warehouse w
ON p.Customer_ID = w.Warehouse_ID 
ORDER BY p.Customer_ID;

-- Total Sales of Alcohol and Non-Alcoholic Drinks
SELECT sum(sales)
FROM product p 
JOIN category c 
ON p.Customer_ID = c.Customer_ID
WHERE Sub_Category LIKE "%Alcohol%"
ORDER BY p.Customer_ID;

-- European Customers Payments
SELECT c.customer_name, c.customer_contact,
pm.payment_id, pm.payment_name, pm.payment_type
FROM customer c
JOIN paymentmethod pm 
ON c.Customer_ID = pm.Customer_ID
WHERE payment_id IN (1,3,4,7,13)
ORDER BY payment_id;









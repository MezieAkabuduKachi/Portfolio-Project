-- List of Customers(ID, Name, Customer_Contact) that paid with Matercard
-- From the list, only show Customers with Contact ening in 8
SELECT  c.Customer_ID, c.customer_name, c.customer_contact,
pm.payment_id, pm.payment_name, pm.payment_type
FROM customer c
JOIN paymentmethod pm
ON c.Customer_ID = pm.Customer_ID
WHERE payment_type = "Mastercard" AND customer_contact LIKE "%8"
ORDER BY c.Customer_ID;

-- Creating Views
CREATE VIEW  CustomerView as
(
SELECT  c.Customer_ID, c.customer_name, c.customer_contact,
pm.payment_id, pm.payment_name, pm.payment_type
FROM customer c
JOIN paymentmethod pm
ON c.Customer_ID = pm.Customer_ID
WHERE payment_type = "Mastercard" AND customer_contact LIKE "%8"
ORDER BY c.Customer_ID
);

-- Creating a stored procedure for Sales greater than 10,000
DELIMITER &&
CREATE procedure Sales1000()
BEGIN
SELECT Customer_ID, Product_Name, Sales, Quantity, Order_Date 
FROM product
WHERE Sales > 1000;
END &&
DELIMITER ;

CALL Sales1000();

-- Creating a stored procedure for Top(n)Sales 
DELIMITER //
CREATE procedure TopnSales (IN var INT)
BEGIN
SELECT*
FROM product
ORDER BY Sales DESC
LIMIT var ;
END //
DELIMITER ;

CALL TopnSales(5) ;

-- CREATE procedure to Update Sales
DELIMITER //
CREATE procedure UpdateSales (IN emp_name varchar(40), IN New_Sales float)
BEGIN
UPDATE product SET Sales = New_Sales
WHERE Product_Name = emp_name;
END //
DELIMITER ;

call credo_sales.UpdateSales('TOILET BRUSH', 4000);

-- Creating a trigger

DROP TABLE  if exists FuelType ;
CREATE TABLE FuelType (
  fuel_id INT PRIMARY KEY,
  fuel_name VARCHAR(50),
  price_per_litre FLOAT NOT NULL,
  Customer_ID INT NOT NULL
);

DELIMITER //
CREATE Trigger Triggerr
BEFORE insert on FuelType
FOR each row
IF new.price_per_litre < 18 THEN SET new.price_per_litre = 18;
END IF ; //
DELIMITER ;

INSERT INTO FuelType (fuel_id, fuel_name, price_per_litre, Customer_ID)
VALUES
  (1, 'Gasoline', 20.75, 1),
  (2, 'Diesel', 18.95, 2),
  (3, 'Electric', 14.5, 3),
  (4, 'Hybrid', 23.10, 4),
  (5, 'Ethanol', 17.80, 5),
  (6, 'Biodiesel', 19.25, 6),
  (7, 'Compressed Natural Gas (CNG)', 14.8, 7),
  (8, 'Liquefied Petroleum Gas (LPG)', 16.45, 8),
  (9, 'Hydrogen', 21.30, 9),
  (10, 'Propane', 24.90, 10),
  (11, 'Methanol', 22.75, 11),
  (12, 'Liquefied Natural Gas (LNG)', 15.60, 12),
  (13, 'Biofuel', 18.25, 13),
  (14, 'Synthetic Fuel', 23.50, 14),
  (15, 'Aviation Fuel', 25.20, 15),
  (16, 'Kerosene', 16.75, 16),
  (17, 'Methane', 20.40, 17),
  (18, 'Butane', 19.90, 18),
  (19, 'Jet Fuel', 21.50, 19),
  (20, 'Biomethane', 17.95, 20);

SELECT * FROM FuelType;

-- Create View 
CREATE VIEW FuelTypeView as
SELECT * FROM FuelType;

-- Creating a Function
CREATE FUNCTION EmployeeName_Shift (Employee_Name varchar(50), Shift varchar (50))
RETURNS varchar (100) DETERMINISTIC 
RETURN concat(Employee_Name, "-", Shift) ;

-- Taking a look at the function
SELECT Customer_ID, Employee_ID,  EmployeeName_Shift(Employee_Name, Shift) , Employee_Position, Date_of_hire
FROM employee
















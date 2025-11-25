-- FINAL FIX: Run this WHOLE block at once (do NOT run line by line)

DROP DATABASE IF EXISTS greenspot;          -- deletes old broken version
CREATE DATABASE greenspot;                  -- creates fresh database
USE greenspot;                              -- selects it

-- 1. Product table (must be first)
CREATE TABLE product (
    item_num INT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    vendor VARCHAR(100) NOT NULL,
    item_type VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL,
    unit VARCHAR(20) NOT NULL
);

-- 2. Customer table
CREATE TABLE customer (
    id_customer INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL
);

-- 3. Purchase table
CREATE TABLE purchase (
    purchase_num INT PRIMARY KEY AUTO_INCREMENT,
    item_num INT NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    purchase_date DATE NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (item_num) REFERENCES product(item_num)
);

-- 4. Sales table
CREATE TABLE sales (
    sales_num INT PRIMARY KEY AUTO_INCREMENT,
    date_sold DATE NOT NULL,
    id_customer INT NOT NULL,
    FOREIGN KEY (id_customer) REFERENCES customer(id_customer)
);

-- 5. Sales Details table
CREATE TABLE sales_details (
    sales_num INT NOT NULL,
    item_num INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (sales_num, item_num),
    FOREIGN KEY (sales_num) REFERENCES sales(sales_num),
    FOREIGN KEY (item_num) REFERENCES product(item_num)
);

-- 6. Stock table
CREATE TABLE stock (
    stock_id INT PRIMARY KEY AUTO_INCREMENT,
    item_num INT NOT NULL,
    quantity INT NOT NULL,
    stock_date DATE NOT NULL,
    FOREIGN KEY (item_num) REFERENCES product(item_num)
);

-- NOW INSERT ALL DATA (everything works now)
INSERT INTO product (item_num, description, vendor, item_type, location, unit) VALUES
(101,'Organic Apples','Fresh Farms','Fruit','Pehawar','kg'),
(102,'Whole Wheat Bread','Bakery Co','Bakery','shabqadar','loaf'),
(103,'Almond Milk','Nutty Dairy','Dairy Alternative','battagram','liter'),
(104,'Free Range Eggs','Happy Hens','Dairy','sadar','dozen'),
(105,'Organic Carrots','Fresh Farms','Vegetable','islamabad','kg');


INSERT INTO customer (customer_name) VALUES
('M: Saayid Shah'),('Hamid shah'),('Ahmad Shah'),('Muhammad Saad'),('Muneeb Khan');

INSERT INTO purchase (item_num,cost,purchase_date,quantity) VALUES
(101,2.50,'2025-11-15',20),(102,1.80,'2025-11-16',30),(103,3.20,'2025-11-17',15),
(101,2.50,'2025-11-01',25),(104,4.00,'2025-11-05',10);

INSERT INTO sales (date_sold,id_customer) VALUES
('2025-11-20',1),('2025-11-22',2),('2025-11-25',1),('2025-12-10',3),('2025-12-15',4);

INSERT INTO sales_details (sales_num,item_num,price,quantity) VALUES
(1,101,4.99,2),(1,102,3.49,1),(2,103,5.99,3),(3,101,4.99,5),(4,104,6.50,2),(5,105,2.99,4);

INSERT INTO stock (item_num,quantity,stock_date) VALUES
(101,50,'2025-01-10'),(102,40,'2025-01-10'),(103,30,'2025-01-10'),(104,20,'2025-01-10'),(105,60,'2025-01-10');


-- Test cases  

-- Query 1
SELECT p.description, SUM(pu.cost * pu.quantity) AS total_purchase_cost
FROM product p JOIN purchase pu ON p.item_num = pu.item_num
GROUP BY p.description;

-- Query 2
SELECT p.description, SUM(sd.price * sd.quantity) AS total_revenue
FROM product p JOIN sales_details sd ON p.item_num = sd.item_num
GROUP BY p.description;

-- Query 3
SELECT c.customer_name, COUNT(s.sales_num) AS total_orders,
       COALESCE(SUM(sd.price * sd.quantity),0) AS total_spent
FROM customer c
LEFT JOIN sales s ON c.id_customer = s.id_customer
LEFT JOIN sales_details sd ON s.sales_num = sd.sales_num
GROUP BY c.customer_name ORDER BY total_spent DESC;

-- Query 4
SELECT p.description, s.quantity AS current_stock
FROM product p JOIN stock s ON p.item_num = s.item_num;


INSERT INTO sales_details (sales_num,item_num,price,quantity) VALUES
(1,101,4.99,2),(1,102,3.49,1),(2,103,5.99,3),(3,101,4.99,5),(4,104,6.50,2),(5,105,2.99,4);

INSERT INTO stock (item_num,quantity,stock_date) VALUES
(101,50,'2025-01-10'),(102,40,'2025-01-10'),(103,30,'2025-01-10'),(104,20,'2025-01-10'),(105,60,'2025-01-10');

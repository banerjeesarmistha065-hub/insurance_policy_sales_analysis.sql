-- Insurance Policy Sales Analysis using SQL
-- Domain: Banking & Insurance


-- 1.Create Database
CREATE DATABASE IF NOT EXISTS insurance_analytics;
USE insurance_analytics;

-- 2.create Tables

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    age INT,
    region VARCHAR(50)
);

-- Policies table
CREATE TABLE policies (
    policy_id INT PRIMARY KEY,
    policy_type VARCHAR(50),
    premium_amount DECIMAL(10,2),
    policy_term INT
);

-- Policy Sales table
CREATE TABLE policy_sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    policy_id INT,
    sale_date DATE,
    premium_paid DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

-- 3️.Insert Sample Data

INSERT INTO customers (customer_id, customer_name, age, region) VALUES
(1, 'Amit Sharma', 35, 'North'),
(2, 'Priya Das', 29, 'South'),
(3, 'Rahul Mehta', 42, 'East'),
(4, 'Sneha Kapoor', 38, 'West'),
(5, 'Ravi Singh', 45, 'North');

INSERT INTO policies (policy_id, policy_type, premium_amount, policy_term) VALUES
(101, 'Life Insurance', 12000, 20),
(102, 'Health Insurance', 18000, 10),
(103, 'Motor Insurance', 9000, 5),
(104, 'Term Insurance', 15000, 25);

INSERT INTO policy_sales (sale_id, customer_id, policy_id, sale_date, premium_paid) VALUES
(1001, 1, 101, '2024-01-10', 12000),
(1002, 2, 102, '2024-02-15', 18000),
(1003, 3, 104, '2024-03-20', 15000),
(1004, 4, 101, '2024-04-05', 12000),
(1005, 5, 102, '2024-05-18', 18000),
(1006, 1, 103, '2024-06-22', 9000),
(1007, 3, 101, '2024-07-30', 12000);

-- 4️.Business Analysis Queries

-- Total premium collected by policy type
SELECT 
    p.policy_type,
    SUM(s.premium_paid) AS total_premium
FROM policy_sales s
JOIN policies p ON s.policy_id = p.policy_id
GROUP BY p.policy_type
ORDER BY total_premium DESC;

-- Top customers by premium contribution
SELECT 
    c.customer_name,
    SUM(s.premium_paid) AS total_paid
FROM policy_sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_paid DESC;

-- Region-wise premium collection
SELECT 
    c.region,
    SUM(s.premium_paid) AS region_premium
FROM policy_sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.region
ORDER BY region_premium DESC;

-- Customer segmentation based on premium paid (CASE)
SELECT 
    c.customer_name,
    SUM(s.premium_paid) AS total_paid,
    CASE
        WHEN SUM(s.premium_paid) >= 30000 THEN 'High Value'
        WHEN SUM(s.premium_paid) BETWEEN 15000 AND 29999 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM policy_sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name;

-- Identify most popular policy type (Window Function)
SELECT 
    policy_type,
    COUNT(*) AS total_sales,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS sales_rank
FROM policies p
JOIN policy_sales s ON p.policy_id = s.policy_id
GROUP BY policy_type;

-- Monthly premium trend
SELECT 
    MONTH(sale_date) AS sale_month,
    SUM(premium_paid) AS monthly_premium
FROM policy_sales
GROUP BY MONTH(sale_date)
ORDER BY sale_month;

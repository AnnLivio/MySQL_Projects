/*  
RESTAURANT ORDER ANALYSIS
Analyze order data to identify the most and least popular menu items and types of cuisine 

*/
-- // EXPLORE THE MENU TABLE
-- A table view 
SELECT * FROM menu_items

-- Count the items in the table
SELECT count(*) FROM menu_items

-- TASK 1: View the menu_items table and write a query to find the number of items on the menu
SELECT item_name, count(menu_item_id) as count
FROM  menu_items
GROUP BY item_name

-- TASK 2: What are the least and most expensive items on the menu?
SELECT item_name, price as price
FROM menu_items l, (SELECT MIN(price) as min_price, MAX(price) as max_price FROM menu_items) m
WHERE  l.price = m.min_price OR l.price = m.max_price;

-- TASK 3: 
-- A. How many Italian dishes are on the menu? 
SELECT category, count(menu_item_id) 
FROM menu_items 
WHERE category = 'Italian'

-- B. What are the least and most expensive Italian dishes on the menu?
SELECT item_name as least_expensive, price
FROM menu_items 
WHERE category = 'Italian'
ORDER BY price 

-- TASK 4: 
-- A. How many dishes are in each category?
SELECT category, COUNT(item_name)
FROM menu_items
GROUP BY category

-- B. What is the average dish price within each category?
SELECT category, AVG(price) as average_price
FROM menu_items
GROUP BY category

-- // EXPLORE THE ORDER TABLE
-- View the order_details table
SELECT * FROM order_details

-- TASK 1: What is the date range of the table?
SELECT MIN(order_date) as Start_date, MAX(order_date) as End_date
FROM order_details

-- TASK 2: 
-- A. How many orders were made within this date range? 
SELECT COUNT(DISTINCT(order_id)) FROM order_details

-- B: How many items were ordered within this date range?
SELECT COUNT(item_id) FROM order_details

-- TASK 3: Which orders had the most number of items?
SELECT order_id, COUNT(item_id) as Item_count
FROM order_details
GROUP BY order_id
ORDER BY Item_count DESC

-- TASK 4: How many orders had more than 12 items?
SELECT COUNT(*) FROM (SELECT order_id, COUNT(item_id) as Item_count
FROM order_details
GROUP BY order_id
HAVING Item_count > 12) T;


-- // ANALYZE CUSTOMER BEHAVIOR
-- TASK 1: Combine the menu_items and order_details tables into a single table
WITH all_data AS (
	SELECT * FROM order_details od
    LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
)
SELECT * FROM all_data

-- TASK 2: 
-- A. What were the least and most ordered items? 
SELECT mi.item_name, COUNT(od.item_id) AS item_count 
FROM order_details od, menu_items mi
WHERE od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY item_count

-- B. What categories were they in?
SELECT mi.item_name, mi.category, COUNT(od.item_id) AS item_count 
FROM order_details od, menu_items mi
WHERE od.item_id = mi.menu_item_id
GROUP BY mi.item_name, mi.category
ORDER BY item_count;

-- TASK 3: What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total
FROM (SELECT * FROM order_details od
		LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id) ad
GROUP BY order_id
ORDER BY total DESC 
LIMIT 5;

-- TASK 4: View the details of the highest spend order. Which specific items were purchased?
SELECT *
FROM (SELECT * FROM order_details od
		LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id) ad
WHERE order_id=440;

-- BONUS: View the details of the top 5 highest spend orders
SELECT category, COUNT(item_id)
FROM order_details o
LEFT JOIN menu_items m
ON o.item_id = m.menu_item_id

WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category;


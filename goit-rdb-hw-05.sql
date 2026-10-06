-- goit-rdb-hw-05
-- Домашнє завдання до Теми 5
-- Вкладені запити. Повторне використання коду
-- MySQL 8.x

USE goit_rdb_hw_03;

-- =========================================================
-- TASK 1
-- Вкладений запит у SELECT:
-- показати order_details + customer_id з orders
-- =========================================================

SELECT
    od.*,
    (
        SELECT o.customer_id
        FROM orders AS o
        WHERE o.id = od.order_id
    ) AS customer_id
FROM order_details AS od;


-- =========================================================
-- TASK 2
-- Вкладений запит у WHERE:
-- показати order_details лише для замовлень з shipper_id = 3
-- =========================================================

SELECT *
FROM order_details
WHERE order_id IN (
    SELECT id
    FROM orders
    WHERE shipper_id = 3
);


-- =========================================================
-- TASK 3
-- Вкладений запит у FROM:
-- quantity > 10, потім AVG(quantity) за order_id
-- =========================================================

SELECT
    temp.order_id,
    AVG(temp.quantity) AS average_quantity
FROM (
    SELECT
        order_id,
        quantity
    FROM order_details
    WHERE quantity > 10
) AS temp
GROUP BY temp.order_id;


-- =========================================================
-- TASK 4
-- Те саме через WITH / CTE temp
-- =========================================================

WITH temp AS (
    SELECT
        order_id,
        quantity
    FROM order_details
    WHERE quantity > 10
)
SELECT
    order_id,
    AVG(quantity) AS average_quantity
FROM temp
GROUP BY order_id;


-- =========================================================
-- TASK 5
-- Функція з двома FLOAT-параметрами, яка ділить перший на другий
-- Спрощена форма без DELIMITER, сумісна з Workbench
-- =========================================================

DROP FUNCTION IF EXISTS divide_float;

CREATE FUNCTION divide_float(
    value1 FLOAT,
    value2 FLOAT
)
RETURNS FLOAT
DETERMINISTIC
NO SQL
RETURN value1 / NULLIF(value2, 0);

-- Застосування функції до quantity; другий параметр = 2.0
SELECT
    id,
    order_id,
    product_id,
    quantity,
    divide_float(quantity, 2.0) AS divided_quantity
FROM order_details;

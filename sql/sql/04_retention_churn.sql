/*
04_retention_churn.sql
Purpose: Segment customers by activity, calculate churn, revenue lost to churn
*/
-- Customer Churn & Risk Segmentation
-- Define churn (e.g. no purchase in 90 days)
SELECT
    c.customer_id,
   MAX(o.order_date) AS last_purchase_date,
   DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_purchase
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING MAX(o.order_date) < CURDATE() - INTERVAL 90 DAY
    OR MAX(o.order_date) IS NULL;

-- Active vs At-Risk vs Churned users
SELECT
    customer_status,
    COUNT(*) AS customers
FROM (
    SELECT
        c.customer_id,
        CASE
            WHEN MAX(o.order_date) >= CURDATE() - INTERVAL 30 DAY THEN 'Active'
            WHEN MAX(o.order_date) >= CURDATE() - INTERVAL 90 DAY THEN 'At-Risk'
            ELSE 'Churned'
        END AS customer_status
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) t
GROUP BY customer_status;

-- Revenue lost to churn

with churned_customer as (
select c.customer_id
from customers c
left join orders o
on c.customer_id = o.customer_id
group by customer_id
having max(o.order_date) < curdate() - interval 90 day
or max(order_date) is null
)

select sum(p.amount) as revenue 
from payments p 
join orders o
on p.order_id = o.order_id
join churned_customer cc
on cc.customer_id = o.customer_id;

-- Top churned segments
WITH last_purchase AS (
    SELECT
        e.customer_id,
        MAX(o.order_date) AS last_order_date,
        e.device
    FROM events e
    LEFT JOIN orders o ON o.customer_id = e.customer_id
    GROUP BY e.customer_id, e.device
)
SELECT
    device,
    COUNT(*) AS churned_customers
FROM last_purchase
WHERE last_order_date < CURDATE() - INTERVAL 90 DAY
   OR last_order_date IS NULL
GROUP BY device
ORDER BY churned_customers DESC;

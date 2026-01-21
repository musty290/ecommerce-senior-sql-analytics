-- Customer Cohort Analysis
-- Cohort by signup month
with cohorts as  (
select date_format(signup_date, '%Y-%m') as cohort_month
from customers
)
select cohort_month,
count(distinct customer_id) as cusotmers
from cohorts
group by cohort_month
order by cohort_month;

-- Revenue per cohort
select sum(p.amount) as revenue, date_format(c.signup_date, '%Y-%m') as signup_month,
count(distinct c.customer_id) as customers
from customers c
join orders o 
on c.customer_id = o.customer_id
 join payments p
on p.order_id = o.order_id
group by signup_month;

-- Retention rate over time
WITH cohorts AS (
    SELECT
        customer_id,
        DATE_FORMAT(signup_date, '%Y-%m') AS cohort_month
    FROM customers
),
orders_with_month AS (
    SELECT
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month
    FROM orders o
),
cohort_activity AS (
    SELECT
        c.cohort_month,
        TIMESTAMPDIFF(
            MONTH,
            STR_TO_DATE(c.cohort_month, '%Y-%m'),
            STR_TO_DATE(o.order_month, '%Y-%m')
        ) AS month_number,
        c.customer_id
    FROM cohorts c
    JOIN orders_with_month o
        ON c.customer_id = o.customer_id
)
SELECT
    cohort_month,
    month_number,
    COUNT(DISTINCT customer_id) AS active_customers
FROM cohort_activity
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;

-- Lifetime value (LTV) per cohort
select count(distinct c.customer_id), 
date_format(signup_date, '%Y-%m') as cohort_month, 
sum(p.amount) as lifetime_value,
round(sum(p.amount)  / count(distinct c.customer_id), 2) as avg_ltv
from customers c 
join orders o
on c.customer_id = o.customer_id
join payments p
on p.order_id = o.order_id
group by cohort_month
order by cohort_month;

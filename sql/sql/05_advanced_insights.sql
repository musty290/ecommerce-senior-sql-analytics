/*
05_advanced_insights.sql
Purpose:
- Running revenue totals
- Moving average (7-day / 30-day)
- Rank customers by LTV
- Detect abnormal sales spikes
*/

05_advanced_insights.sql
 -- Running revenue totals
select sum(p.amount) as revenue,
sum(sum(p.amount)) over (order by o.order_date) as running_total
from payments p 
join orders o 
on p.order_id = o.order_id
group by order_date
order by order_date;


-- Moving average (7-day / 30-day)
SELECT
    o.order_date,
    SUM(p.amount) AS daily_revenue,
    ROUND(AVG(SUM(p.amount)) OVER (
        ORDER BY o.order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_7d,
    ROUND(AVG(SUM(p.amount)) OVER (
        ORDER BY o.order_date 
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_30d
FROM orders o
JOIN payments p
    ON p.order_id = o.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- Rank customers by LTV
SELECT
    c.customer_id,
    SUM(p.amount) AS lifetime_value,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank_ltv,
    DENSE_RANK() OVER (ORDER BY SUM(p.amount) DESC) AS dense_rank_ltv
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN payments p
    ON p.order_id = o.order_id
GROUP BY c.customer_id
ORDER BY rank_ltv;

-- Detect abnormal sales spikes
WITH daily_revenue AS (
    SELECT
        o.order_date,
        SUM(p.amount) AS revenue
    FROM orders o
    JOIN payments p
        ON p.order_id = o.order_id
    GROUP BY o.order_date
),
stats AS (
    SELECT
        AVG(revenue) AS avg_revenue,
        STDDEV_POP(revenue) AS std_dev
    FROM daily_revenue
)
SELECT
    dr.order_date,
    dr.revenue,
    CASE 
        WHEN dr.revenue > s.avg_revenue + 2 * s.std_dev THEN 'Spike'
        ELSE 'Normal'
    END AS spike_flag
FROM daily_revenue dr
CROSS JOIN stats s
ORDER BY dr.order_date;
*/

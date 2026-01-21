-- Revenue & Growth Analysis
-- Monthly revenue trend
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(p.amount) AS monthly_revenue
FROM orders o
JOIN payments p
    ON p.order_id = o.order_id
GROUP BY month
ORDER BY month;

-- MoM growth rate
SELECT
    month,
    monthly_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
        / LAG(monthly_revenue) OVER (ORDER BY month) * 100, 2
    ) AS mom_growth_pct
FROM (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(p.amount) AS monthly_revenue
    FROM orders o
    JOIN payments p
        ON p.order_id = o.order_id
    GROUP BY month
) t
ORDER BY month;

-- Revenue by category & region
SELECT
    pr.category,
    c.region,
    SUM(p.amount) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products pr ON oi.product_id = pr.product_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY pr.category, c.region
ORDER BY total_revenue DESC;

-- Top 20% customers contributing % of revenue (Pareto)
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(p.amount) AS lifetime_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN payments p ON o.order_id = p.order_id
    GROUP BY c.customer_id
),
ranked AS (
    SELECT
        customer_id,
        lifetime_value,
        CUME_DIST() OVER (ORDER BY lifetime_value DESC) AS cum_dist
    FROM customer_revenue
)
SELECT
    COUNT(*) AS top_customers_count,
    ROUND(SUM(lifetime_value) / (SELECT SUM(lifetime_value) FROM customer_revenue) * 100, 2) AS revenue_pct
FROM ranked
WHERE cum_dist <= 0.2;

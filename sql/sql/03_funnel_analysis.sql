/*
03_funnel_analysis.sql
Purpose: Analyze funnel steps (visit → add to cart → checkout → purchase)
*/
with funnel as (
select customer_id,
max(event_type = 'visit') as visit,
max(event_type = 'add_to_cart') as add_to_cart,
max(event_type= 'checkout') as check_out,
max(event_type = 'purchase') as purchase
from events
group by customer_id
)
select 
count(*) as visitor,
sum(add_to_cart) as add_to_cart,
sum(check_out) as check_out,
sum(purchase) as purchase
from funnel
where visit = 1;

-- Conversion rate per step
with funnel as (
select customer_id,
max(event_type = 'visit') as visit,
max(event_type = 'add_to_cart') as add_to_cart,
max(event_type= 'checkout') as check_out,
max(event_type = 'purchase') as purchase
from events
group by customer_id
)
select 
count(*) as visitor,
sum(add_to_cart) as add_to_cart,
round(sum(add_to_cart)/count(*) * 100, 2) as visit_to_cart_rate,
sum(check_out) as check_out,
round(sum(check_out) / sum(add_to_cart) * 100 , 2) as cart_to_checkout_rate,
sum(purchase) as purchase,
round(sum(purchase)/sum(check_out)* 100,2) as checkout_to_purchase_rate
from funnel
where visit = 1;
-- Drop-off percentage
with funnel as (
select customer_id,
max(event_type = 'visit') as visit,
max(event_type = 'add_to_cart') as add_to_cart,
max(event_type= 'checkout') as check_out,
max(event_type = 'purchase') as purchase
from events
group by customer_id
)
select 
round(100-(sum(add_to_cart)/count(*) * 100), 2) as visit_dropoff,
round(100 - (sum(check_out) / sum(add_to_cart) * 100), 2) as  cart_dropoff,
round(100- (sum(purchase)/sum(check_out)* 100), 2) as checkout_dropoff
from funnel
where visit = 1;
-- Funnel by device or region
WITH funnel AS (
    SELECT
        customer_id,
        device,
        MAX(event_type = 'visit') AS visit,
        MAX(event_type = 'add_to_cart') AS add_to_cart,
        MAX(event_type = 'checkout') AS checkout,
        MAX(event_type = 'purchase') AS purchase
    FROM events
    GROUP BY customer_id, device
)
SELECT
    device,
    COUNT(*) AS visitors,
    ROUND(SUM(purchase) / COUNT(*) * 100, 2) AS overall_conversion_rate
FROM funnel
WHERE visit = 1
GROUP BY device;


WITH funnel AS (
    SELECT
        e.customer_id,
        c.country,
        MAX(e.event_type = 'visit') AS visit,
        MAX(e.event_type = 'add_to_cart') AS add_to_cart,
        MAX(e.event_type = 'checkout') AS checkout,
        MAX(e.event_type = 'purchase') AS purchase
    FROM events e
    JOIN customers c ON c.customer_id = e.customer_id
    GROUP BY e.customer_id, c.country
)
SELECT
    country,
    COUNT(*) AS visitors,
    ROUND(SUM(purchase) / COUNT(*) * 100, 2) AS conversion_rate
FROM funnel
WHERE visit = 1
GROUP BY country;

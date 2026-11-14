-- =====================================================
-- Maven Fuzzy Factory: SQL Business Analysis
-- =====================================================

-- Q1. Total number of unique orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders_mav;

-- Q2. Total revenue generated
SELECT ROUND(SUM(price_usd), 2) AS total_revenue
FROM orders_mav;

-- Q3. Top 5 products by revenue
SELECT p.product_name,
       COUNT(*) AS units_sold,
       ROUND(SUM(oi.price_usd), 2) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- Q4. Product performance (the data has no category column,
--     so we compare product types: revenue, profit and margin)
SELECT p.product_name,
       COUNT(*) AS units_sold,
       ROUND(SUM(oi.price_usd), 2) AS revenue,
       ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS gross_profit,
       ROUND(100.0 * SUM(oi.price_usd - oi.cogs_usd) / SUM(oi.price_usd), 1) AS margin_pct
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY gross_profit DESC;

-- Q5. Marketing sources by number of sessions
SELECT marketing_channel,
       COUNT(*) AS sessions,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_sessions
FROM website_sessions
GROUP BY marketing_channel
ORDER BY sessions DESC;

-- Q6. Device type by website traffic
SELECT device_type,
       COUNT(*) AS sessions,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_sessions
FROM website_sessions
GROUP BY device_type
ORDER BY sessions DESC;

-- Q7. Session-to-order conversion rate
SELECT COUNT(DISTINCT s.website_session_id) AS sessions,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(100.0 * COUNT(DISTINCT o.order_id)
             / COUNT(DISTINCT s.website_session_id), 2) AS conversion_rate_pct
FROM website_sessions s
LEFT JOIN orders_mav o ON o.website_session_id = s.website_session_id;

-- Q8. Total number and value of refunds
SELECT COUNT(*) AS refund_count,
       ROUND(SUM(refund_amount_usd), 2) AS refund_value
FROM order_item_refunds;

-- Q9. Revenue by month (highest and lowest)
SELECT TO_CHAR(DATE_TRUNC('month', created_at), 'YYYY-MM') AS month,
       ROUND(SUM(price_usd), 2) AS revenue
FROM orders_mav
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY revenue DESC;

-- Q9b. Revenue by month, complete months only
SELECT TO_CHAR(DATE_TRUNC('month', created_at), 'YYYY-MM') AS month,
       COUNT(*) AS orders,
       ROUND(SUM(price_usd), 2) AS revenue
FROM orders_mav
WHERE created_at >= '2012-04-01' AND created_at < '2015-03-01'
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY revenue DESC;

WITH monthly AS (
  SELECT TO_CHAR(DATE_TRUNC('month', created_at), 'YYYY-MM') AS month,
         COUNT(*) AS orders,
         ROUND(SUM(price_usd), 2) AS revenue
  FROM orders_mav
  WHERE created_at >= '2012-04-01' AND created_at < '2015-03-01'
  GROUP BY DATE_TRUNC('month', created_at)
)
(SELECT 'highest' AS label, * FROM monthly ORDER BY revenue DESC LIMIT 1)
UNION ALL
(SELECT 'lowest', * FROM monthly ORDER BY revenue ASC LIMIT 1);

-- Q10. Average order value
SELECT ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders_mav;

-- Q11. Conversion rate by device
SELECT s.device_type,
       COUNT(*) AS sessions,
       COUNT(o.order_id) AS orders,
       ROUND(100.0 * COUNT(o.order_id) / COUNT(*), 2) AS conversion_rate_pct
FROM website_sessions s
LEFT JOIN orders_mav o ON o.website_session_id = s.website_session_id
GROUP BY s.device_type
ORDER BY conversion_rate_pct DESC;

-- Q12. Conversion rate by marketing channel
SELECT s.marketing_channel,
       COUNT(*) AS sessions,
       COUNT(o.order_id) AS orders,
       ROUND(100.0 * COUNT(o.order_id) / COUNT(*), 2) AS conversion_rate_pct
FROM website_sessions s
LEFT JOIN orders_mav o ON o.website_session_id = s.website_session_id
GROUP BY s.marketing_channel
ORDER BY conversion_rate_pct DESC;

-- Q13. Refund rate by product
SELECT p.product_name,
       COUNT(oi.order_item_id) AS items_sold,
       COUNT(r.order_item_refund_id) AS items_refunded,
       ROUND(100.0 * COUNT(r.order_item_refund_id) / COUNT(oi.order_item_id), 2) AS refund_rate_pct,
       ROUND(COALESCE(SUM(r.refund_amount_usd), 0), 2) AS refund_value
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN order_item_refunds r ON r.order_item_id = oi.order_item_id
GROUP BY p.product_name
ORDER BY refund_rate_pct DESC;

-- Q14. New vs repeat sessions
SELECT s.is_repeat_session,
       COUNT(*) AS sessions,
       COUNT(o.order_id) AS orders,
       ROUND(100.0 * COUNT(o.order_id) / COUNT(*), 2) AS conversion_rate_pct
FROM website_sessions s
LEFT JOIN orders_mav o ON o.website_session_id = s.website_session_id
GROUP BY s.is_repeat_session;


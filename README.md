## Data Model

| Table | Primary Key | Foreign Keys |
|---|---|---|
| website_sessions | website_session_id | none |
| website_pageviews | website_pageview_id | website_session_id -> website_sessions |
| orders_mav | order_id | website_session_id -> website_sessions; primary_product_id -> products |
| order_items | order_item_id | order_id -> orders_mav; product_id -> products |
| order_item_refunds | order_item_refund_id | order_item_id -> order_items; order_id -> orders_mav |
| products | product_id | none |

Relationships: one session has many pageviews; one session has at most one order; one order has many order items; one order item has at most one refund.

**Data limitation:** website_pageviews.csv contains exactly 1,048,576 rows (the Excel row limit), so it is likely truncated. It is not used for the 10 SQL questions.
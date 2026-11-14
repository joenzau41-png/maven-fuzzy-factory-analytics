DROP TABLE IF EXISTS order_item_refunds, order_items, orders_mav,
    website_pageviews, website_sessions, products CASCADE;

CREATE TABLE products (
		product_id INT PRIMARY KEY,
		created_at TIMESTAMP,
		product_name VARCHAR(100)
);
CREATE TABLE website_sessions (
    website_session_id  INT PRIMARY KEY,
    created_at          TIMESTAMP,
    user_id             INT,
    is_repeat_session   INT,
    utm_source          VARCHAR(50),
    utm_campaign        VARCHAR(50),
    utm_content         VARCHAR(50),
    device_type         VARCHAR(20),
    http_referer        VARCHAR(100),
    marketing_channel   VARCHAR(50)
);
CREATE TABLE website_pageviews (
    website_pageview_id  INT PRIMARY KEY,
    created_at           TIMESTAMP,
    website_session_id   INT REFERENCES website_sessions(website_session_id),
    pageview_url         VARCHAR(100)
);
CREATE TABLE orders_mav (
    order_id            INT PRIMARY KEY,
    created_at          TIMESTAMP,
    website_session_id  INT REFERENCES website_sessions(website_session_id),
    user_id             INT,
    primary_product_id  INT REFERENCES products(product_id),
    items_purchased     INT,
    price_usd           NUMERIC(10,2),
    cogs_usd            NUMERIC(10,2)
);
CREATE TABLE order_items (
    order_item_id    INT PRIMARY KEY,
    created_at       TIMESTAMP,
    order_id         INT REFERENCES orders_mav(order_id),
    product_id       INT REFERENCES products(product_id),
    is_primary_item  INT,
    price_usd        NUMERIC(10,2),
    cogs_usd         NUMERIC(10,2)
);
CREATE TABLE order_item_refunds (
    order_item_refund_id  INT PRIMARY KEY,
    created_at            TIMESTAMP,
    order_item_id         INT REFERENCES order_items(order_item_id),
    order_id              INT REFERENCES orders_mav(order_id),
    refund_amount_usd     NUMERIC(10,2)
);

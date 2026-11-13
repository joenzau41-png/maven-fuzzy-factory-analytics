# Maven Fuzzy Factory: E-commerce Sales Performance and Customer Behaviour Analysis

AnalystLab Africa Experience Lab | Week 2 | Track 1: Data Analytics

## Business Problem
Maven Fuzzy Factory is an e-commerce company that wants to understand how its website performs, which marketing channels drive sales, which products perform best, and how refunds affect revenue. This project analyses the company's data to find performance gaps and recommend improvements.

## Objectives
- Clean and prepare six datasets and map the relationships between them
- Answer 10 business questions with SQL
- Build an interactive Power BI dashboard
- Deliver 5 to 7 business insights with recommendations

## Tools
Python (pandas), PostgreSQL, Power BI, Git and GitHub

## Datasets
| File | Description |
|---|---|
| website_sessions.csv | Website visits, with source, device and campaign |
| website_pageviews.csv | Pages viewed in each session |
| orders_mav.csv | Customer orders |
| order_items.csv | Products within each order |
| order_item_refunds.csv | Refunded items |
| products.csv | Product details |

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

**Data limitation:** website_pageviews.csv contains 1,048,575 data rows (the Excel row limit of 1,048,576 including the header), so it is likely truncated. It is not used for the 10 SQL questions.

## Data Preparation
- Checked all six tables for missing values, duplicates, data types and broken keys (notebooks/01_data_quality_check.ipynb).
- No duplicate rows or duplicate IDs in any table.
- Only website_sessions had missing values. The UTM columns (83,328 rows) are blank for visits that did not come from a paid ad, and http_referer is blank for 39,917 visits.
- Converted all created_at columns from text to datetime.
- Created marketing_channel: the UTM source if present; otherwise organic_search if a referer exists (43,411 sessions), otherwise direct (39,917 sessions). No rows were deleted.
- Cleaned files are in data/processed/ (notebooks/02_data_cleaning.ipynb).
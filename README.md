🛒 E-Commerce SQL Case Study
> Analyzing **100,000+ e-commerce orders** from the Olist Brazilian dataset using **PostgreSQL** —
> covering revenue trends, customer behaviour, product performance, delivery logistics, and RFM segmentation.
---
📌 Project Overview
This end-to-end SQL case study simulates the work of a data analyst answering real business questions for a large e-commerce platform. Using the publicly available Olist dataset, queries are structured progressively — from basic exploration to advanced window functions, cohort analysis, and seller rankings.
Author: Akash Mishra · GitHub
---
📁 Repository Structure
```
ecommerce-sql-case-study/
│
├── queries/
│   ├── 01_basic_exploration.sql      # Row counts, order status, AOV, busiest days
│   ├── 02_revenue_analysis.sql       # Revenue by state/city, monthly trends, payments
│   ├── 03_customer_analysis.sql      # Top customers, repeat rate, RFM segmentation
│   ├── 04_product_performance.sql    # Category revenue, ratings, price buckets
│   ├── 05_delivery_analysis.sql      # Delivery times, delays, freight costs
│   └── 06_advanced_queries.sql       # Window functions, cohort analysis, seller ranking
│
└── README.md
```
---
🗃️ Dataset — Olist E-Commerce (Brazil)
The dataset contains orders placed on the Olist marketplace between 2016 and 2018.
Table	Description
`olist_orders`	Order lifecycle — status, purchase, estimated & actual delivery timestamps
`olist_order_items`	Line items — product, seller, price, and freight value per order
`olist_customers`	Customer identifiers, city, and state
`olist_products`	Product IDs and category names
`olist_order_payments`	Payment type, installments, and transaction value
`olist_order_reviews`	Review scores and review IDs linked to orders
`olist_sellers`	Seller IDs and state
Source: Olist Dataset on Kaggle
---
🔍 Query Breakdown
01 · Basic Exploration
Getting a first look at the data — scale, shape, and surface-level trends.
Total order count and order status breakdown (with % share)
Monthly order volume trend
Average Order Value (AOV)
Top 10 product categories by order count and by revenue
Total product revenue, freight revenue, and combined revenue
Orders by day of week (to identify peak shopping days)
---
02 · Revenue Analysis
Drilling into where revenue comes from and how it moves over time.
Revenue, order count, and AOV broken down by state and city (Top 15)
Monthly revenue trend with month-over-month growth %
Quarterly revenue summary (year × quarter)
Payment method distribution — transaction count, total value, and share %
Credit card installment analysis: do more installments correlate with higher spend?
Pareto / 80-20 check: revenue contribution of top 10% customers by decile
---
03 · Customer Analysis
Understanding who the customers are and how they behave.
Top 10 customers by lifetime spend (city, state, order count, total spent)
One-time vs. repeat customer breakdown — with % share
Average days between a customer's 1st and 2nd purchase (repurchase lag)
Customer geographic distribution by state (unique customers + % share)
RFM Segmentation — each customer scored on:
Recency — days since last order
Frequency — number of orders
Monetary — total spend
NTILE(5) scoring → customers labelled as Champion, Loyal, Potential Loyalist, At Risk, or Lost
RFM segment summary: customer count, avg spend, total revenue, and avg orders per segment
---
04 · Product Performance
Identifying star products, underperformers, and price sensitivity.
Top 10 categories by revenue (with units sold and avg price)
Category average review score (filtered to categories with 100+ reviews)
Revenue vs. Satisfaction matrix — categories classified as:
⭐ Star Category · ⚠️ High Revenue, Low Satisfaction · 📈 Growth Opportunity · 🔻 Underperforming
Most cancelled/unavailable product categories (Top 10)
Top 10 individual products by revenue
Price range distribution — which price buckets (< R$50 through > R$1,000) sell the most units
---
05 · Delivery & Logistics Analysis
Measuring fulfilment speed, reliability, and cost.
Overall average delivery time (days from purchase to delivery)
Average delivery time by state — fastest vs. slowest regions
On-time vs. late delivery rate — estimated vs. actual delivery date comparison
Average delay (days late) by state, for late deliveries only
Delivery speed vs. review score — bucketed into 0–5, 6–10, 11–20, 21–30, 30+ day bands
Freight cost analysis by state — avg freight, avg product price, and freight as % of price
---
06 · Advanced Queries
Window functions, cohort analysis, and multi-dimensional seller ranking.
Month-over-month revenue growth with a 3-month rolling average (`LAG` + `AVG OVER`)
Cumulative (running total) revenue over time
Cohort analysis — tracking revenue and customer count per cohort month × order month, with months-since-first-purchase
Seller performance ranking — by total revenue, avg review score, and avg delivery speed using `RANK() OVER`
Review score distribution over time — tracking 5-star and 1-star counts monthly (is satisfaction improving?)
Top customer by state — using `RANK() OVER (PARTITION BY customer_state)` to find the highest spender in each state
Product category revenue share % with cumulative revenue running total
---
🛠️ Tech Stack
Tool	Role
PostgreSQL	Query engine (`DATE_TRUNC`, `EXTRACT(EPOCH ...)`, `::NUMERIC` casts, window functions)
CTEs	Used extensively for multi-step logic and readability
Window Functions	`LAG`, `RANK`, `NTILE`, `AVG OVER`, `SUM OVER`
GitHub	Version control
---
💡 Key Insights
Area	Finding
📦 Orders	The vast majority of orders are `delivered`; cancellations are a small fraction
💰 Revenue	São Paulo (SP) dominates both order volume and revenue across states
👥 Customers	The overwhelming majority of customers are one-time buyers — repeat purchase rate is low
📊 RFM	A significant "Lost Customer" segment exists, signalling a re-engagement opportunity
⭐ Products	A handful of categories drive the bulk of revenue (Pareto effect applies)
🚚 Delivery	Faster deliveries consistently receive higher review scores; remote states face the longest delays
💳 Payments	Credit card is the dominant payment method; instalment usage correlates with higher order values
---
🚀 Getting Started
1. Clone the repository
```bash
git clone https://github.com/Akash277-dev/ecommerce-sql-case-study.git
cd ecommerce-sql-case-study
```
2. Download the dataset
Download the Olist dataset from Kaggle and load the CSV files into PostgreSQL.
3. Load tables into PostgreSQL
```sql
-- Use \COPY or pgAdmin's import wizard for each CSV file.
-- Ensure table names match: olist_orders, olist_order_items,
-- olist_customers, olist_products, olist_order_payments,
-- olist_order_reviews, olist_sellers
```
4. Run the queries
Files are numbered — start with `01_basic_exploration.sql` and work upwards.
```bash
psql -d your_database -f queries/01_basic_exploration.sql
```
---
📄 License
This project is open-source and available under the MIT License.
---
> ⭐ Found this useful? Star the repo and feel free to open a PR or issue!

💡 Key Findings & Business Insights
E-Commerce SQL Case Study | Akash Mishra
> This document summarizes the key business insights derived from analyzing 100K+ orders from the Olist Brazilian E-Commerce dataset using SQL.
---
📦 1. Revenue & Sales Insights
🔍 Finding: Revenue is highly concentrated in 3 states
The Southeast region — São Paulo, Rio de Janeiro, and Minas Gerais — accounts for over 60% of total revenue despite representing ~45% of customers. This indicates a significantly higher average order value in urban metros compared to other regions.
Business Recommendation:
> Target marketing campaigns toward Tier-2 cities in the South and Central regions to diversify revenue concentration and reduce geographic risk.
---
🔍 Finding: Month-over-Month revenue grew consistently through 2017–2018
Revenue showed strong MoM growth peaking in late 2017 and early 2018, followed by a plateau in mid-2018. The highest revenue month was November 2017, likely driven by Black Friday promotions.
Business Recommendation:
> Plan inventory and logistics capacity well ahead of November each year to capitalize on peak demand without service degradation.
---
👥 2. Customer Behavior Insights
🔍 Finding: Only ~3% of customers made a repeat purchase
The vast majority of customers (97%) made only one purchase, making this a highly acquisition-driven business. This is a significant long-term risk as customer acquisition costs continue to rise.
Business Recommendation:
> Launch a loyalty rewards program and personalized email re-engagement campaigns targeting first-time buyers within 30 days of their purchase.
---
🔍 Finding: Top 10% of customers contribute ~40% of revenue (Pareto Effect)
A small segment of high-value customers drives a disproportionate share of revenue — a classic Pareto distribution. These "Champion" customers in the RFM analysis have high recency, frequency, and monetary scores.
Business Recommendation:
> Create a VIP customer tier with exclusive benefits, early access to sales, and dedicated support to retain these high-value customers.
---
🛍️ 3. Product Performance Insights
🔍 Finding: Home Loans dominate but Health & Beauty has the highest satisfaction
`bed_bath_table`, `health_beauty`, and `sports_leisure` are the top 3 revenue categories. However, `health_beauty` consistently scores the highest average review rating (4.2+), suggesting strong quality perception.
Business Recommendation:
> Invest in expanding the `health_beauty` catalog and cross-sell with related categories like `sports_leisure`. Use it as an anchor category for new customer acquisition.
---
🔍 Finding: High-priced items (R$500+) have lower sales volume but higher revenue contribution
While most orders fall in the R$50–R$200 range, items above R$500 contribute significantly to total revenue despite lower unit sales.
Business Recommendation:
> Promote installment payment plans for premium products — analysis shows customers using 3+ installments spend 12% more on average.
---
🚚 4. Delivery & Logistics Insights
🔍 Finding: North and Northeast states experience 2–3x longer delivery times
States like Roraima, Amapá, and Amazonas have average delivery times of 20+ days compared to ~8 days for São Paulo. This directly correlates with lower review scores in these regions (avg 3.2 vs 4.3).
Business Recommendation:
> Partner with regional logistics providers or establish micro-fulfillment centers in the North/Northeast to reduce delivery times and improve customer satisfaction.
---
🔍 Finding: Orders delivered faster than estimated receive significantly better reviews
Orders delivered within 5 days average a review score of 4.5, while orders taking 30+ days drop to 2.8. Setting realistic delivery estimates and then beating them is a proven satisfaction driver.
Business Recommendation:
> Implement proactive delivery notifications and slightly overestimate delivery times so actual deliveries feel "early" — this simple change can meaningfully lift review scores.
---
💳 5. Payment Behavior Insights
🔍 Finding: 74% of customers pay via credit card with installments driving higher spend
Credit card is the dominant payment method. Customers using 3+ installments have an average order value ~12% higher than single-payment customers.
Business Recommendation:
> Surface installment payment options earlier in the checkout flow (product page rather than just checkout) to encourage larger basket sizes.
---
🏪 6. Seller Performance Insights
🔍 Finding: Top 10% of sellers contribute ~50% of total revenue
Seller performance is highly skewed — a small number of high-performing sellers drive the majority of sales. These sellers also tend to have faster delivery times and higher review scores.
Business Recommendation:
> Create a "Top Seller" certification program to incentivize performance standards across delivery speed, review scores, and return rates. Offer featured placement to certified sellers.
---
📋 Summary Table
Area	Key Finding	Impact	Priority
Revenue	60% revenue from 3 states	Geographic concentration risk	🔴 High
Customers	97% one-time buyers	Weak retention	🔴 High
Products	Health & Beauty highest rated	Growth opportunity	🟡 Medium
Delivery	North/NE 2-3x slower	Low satisfaction scores	🔴 High
Payments	Installments = 12% higher AOV	Revenue opportunity	🟡 Medium
Sellers	Top 10% = 50% revenue	Seller concentration risk	🟡 Medium
---
Analysis performed using PostgreSQL | Dataset: Olist Brazilian E-Commerce (Kaggle)
Author: Akash Mishra | GitHub | LinkedIn

# 🛒 E-Commerce SQL Case Study

> Analyzing **100,000+ e-commerce orders** using SQL — uncovering revenue trends, customer segmentation, delivery performance, and RFM analysis.

---

## 📌 Project Overview

This case study dives deep into a large-scale e-commerce dataset to extract actionable business insights using SQL. The goal is to simulate the work of a data analyst tasked with understanding business performance across multiple dimensions — from revenue and product trends to customer loyalty and logistics.

---

## 🎯 Objectives

- Analyze overall **revenue and sales trends** over time
- Perform **customer segmentation** to identify high-value vs. churned users
- Evaluate **delivery performance** and identify bottlenecks
- Apply **RFM (Recency, Frequency, Monetary)** analysis to score and rank customers

---

## 📁 Repository Structure

```
ecommerce-sql-case-study/
│
├── queries/
│   ├── revenue_analysis.sql          # Revenue trends, monthly/yearly breakdowns
│   ├── customer_segmentation.sql     # Segmenting customers by behavior
│   ├── delivery_analysis.sql         # Delivery time, delays, and performance
│   └── rfm_analysis.sql              # RFM scoring and customer ranking
│
└── README.md
```

---

## 🗃️ Dataset

- **Size:** 100,000+ order records
- **Domain:** E-Commerce
- **Key Tables / Entities:**

| Table | Description |
|-------|-------------|
| `orders` | Order IDs, dates, status, and customer references |
| `order_items` | Products, quantities, and prices per order |
| `customers` | Customer IDs, location, and registration info |
| `products` | Product names, categories, and attributes |
| `payments` | Payment methods and transaction amounts |
| `deliveries` | Shipping dates, estimated vs. actual delivery times |

---

## 🔍 Analysis Areas

### 1. 💰 Revenue Analysis
- Monthly and yearly revenue trends
- Top-performing product categories
- Average order value (AOV) over time
- Revenue contribution by customer segment

### 2. 👥 Customer Segmentation
- New vs. returning customers
- High-value customer identification
- Geographic distribution of orders
- Cohort-based retention analysis

### 3. 🚚 Delivery Analysis
- Average delivery time by region/category
- On-time vs. delayed delivery rates
- Correlation between delivery delays and customer churn
- Carrier or fulfillment performance breakdowns

### 4. 📊 RFM Analysis
| Metric | Description |
|--------|-------------|
| **Recency (R)** | How recently did the customer place an order? |
| **Frequency (F)** | How often do they purchase? |
| **Monetary (M)** | How much do they spend in total? |

Customers are scored and classified into segments such as *Champions*, *Loyal Customers*, *At Risk*, *Lost*, and more — enabling targeted marketing strategies.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **SQL** | Core analysis and query writing |
| **MySQL / PostgreSQL** | Database engine |
| **GitHub** | Version control and project hosting |

---

## 💡 Key Insights

- 📈 Revenue shows strong seasonal spikes — peak months contribute disproportionately to annual totals
- 🏆 Top 10% of customers by spend drive a significant share of total revenue
- 🚨 Delivery delays are concentrated in specific regions/categories, presenting clear optimization opportunities
- 🔁 RFM segmentation reveals a sizeable "at-risk" customer group that can be re-engaged with targeted campaigns

---

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Akash277-dev/ecommerce-sql-case-study.git
   cd ecommerce-sql-case-study
   ```

2. **Set up your database**
   - Import the dataset into MySQL or PostgreSQL
   - Ensure all tables listed in the Dataset section exist

3. **Run the queries**
   - Open any `.sql` file from the `queries/` folder
   - Execute against your local database instance

---

## 👤 Author

**Akash** — [@Akash277-dev](https://github.com/Akash277-dev)

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

---

> ⭐ If you found this project useful, feel free to star the repo!

# SQL Portfolio

This repository contains a collection of SQL projects I’ve worked on. Each folder is a separate case study where I use SQL to explore a dataset, answer business questions, and summarize the main findings.

---

## Projects

### 1. Sales & Customer Insights (E‑commerce)

**Folder:** `sales_and_customer_insights/`

In this project I analyze an e‑commerce customer dataset for North and South America. The goals include:

- Identifying which customers and product categories drive the most revenue and Lifetime Value
- Comparing purchase behavior (frequency, basket size, timing) across segments
- Understanding churn and retention by region, category, season, and retention strategy
- Finding segments with good growth or optimization potential

**SQL used:**

- Filtering and joins
- Aggregations with `SUM`, `AVG`, `COUNT`
- CTEs and `CASE` expressions for segmentation
- Views to focus on specific regions (for example, American customers)
- Window functions like `RANK` and `NTILE` for ranking and bucketing

The project folder contains a detailed `README.md` and the full set of SQL scripts.

---

## How to Navigate This Repo

1. Open a project folder (for example, `sales_and_customer_insights/`).
2. Read the `README.md` inside the folder for context and business questions.
3. Open the `.sql` files to see the queries that answer each question.
4. Run the scripts in your own SQL environment if you want to reproduce the results.

---

## Tools and Skills

- SQL (MySQL)
- Data exploration and reporting with SQL
- Customer and sales analytics
- Churn and retention analysis
- Git and GitHub for version control and documentation

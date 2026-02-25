# SaaS Churn Analysis

This is an end-to-end churn analysis project based on a SaaS subscription dataset.

The goal of this project was to explore churn behavior, identify risk segments, and present business insights in a clear and structured way using SQL, R, and Tableau.

---

## Tableau Dashboard

<p align="center">
  <img src="dashboard/dashboard_preview.png" width="900">
</p>

Dashboard file:  
[Download Tableau file (.twbx)](dashboard/saas_churn_dashboard.twbx)

---

## Business Questions

- What is the overall churn rate?
- Does churn differ across subscription plans?
- How does churn evolve over time?
- Are short-tenure customers more likely to churn?

---

## Key Findings

- Overall churn rate: **11.1%**
- The **Pro plan** has the highest churn rate (11.9%)
- Churn increased toward the end of 2024
- Customers with shorter tenure show higher churn probability

---

## Repository Structure

- **data/** – original dataset (Kaggle)
- **notebooks/** – exploratory analysis in R
- **sql/** – schema cleaning and business SQL queries
- **dashboard/** – Tableau dashboard and preview image
- **presentation/** – short executive summary slides

---

## SQL Work

In SQL, I:

- cleaned and standardized data types
- converted boolean flags to numeric format
- validated subscription lifecycle fields
- calculated churn rate and key aggregations

Files:
- `sql/00_schema_cleaning.sql`
- `sql/01_business_analysis.sql`

---

## Exploratory Analysis (R)

In R, I:

- created a `tenure_days` variable
- built tenure buckets (0–3, 3–6, 6–12, 12+ months)
- calculated churn rate by tenure group
- analyzed subscription duration distribution

File:
- `notebooks/01_data_exploration.R`

---

## Tools Used

- MySQL
- R (tidyverse)
- Tableau
- GitHub

---

This project is part of my data analytics portfolio and focuses on applying business-oriented thinking to churn analysis.

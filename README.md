# SaaS Subscription Churn & Revenue Analysis

## Project Overview

This project analyzes subscription-level churn and revenue dynamics 
for a SaaS company using R and MySQL.

The objective is to identify key churn drivers, evaluate revenue exposure, 
and propose retention-focused business recommendations.

---

## Business Questions

- What is the overall churn rate?
- How much recurring revenue is exposed to churn?
- Which subscription tiers drive the highest financial risk?
- Is churn concentrated in specific lifecycle stages?
- How does billing frequency impact retention?

---

## Tools & Technologies

- **R (tidyverse, lubridate)** - data exploration & lifecycle analysis  
- **MySQL** - business metric replication & schema normalization  
- **GitHub** – project structure & reproducibility  

---

## Key Metrics

- **Overall churn rate:** ~9.7%  
- **Total MRR:** ~$11.3M  
- **MRR lost to churn:** ~$1.18M  
- **Revenue exposure:** ~10% of total recurring revenue  

---

## Key Insights

1. **Enterprise subscriptions drive disproportionate revenue loss**  
   Although churn rates are similar across plans, higher MRR in Enterprise 
   accounts results in greater financial exposure.

2. **Churn is heavily concentrated within the first 12 months**  
   Subscriptions surviving beyond one year demonstrate significantly 
   stronger retention stability.

3. **Annual billing does not significantly reduce churn**  
   Churn differences between monthly and annual billing are marginal.

4. **Trial churn has limited direct revenue impact**  
   Financial risk is primarily concentrated within paid subscriptions.

---

## Strategic Implications

- Focus retention initiatives on early lifecycle stages (0–12 months)
- Prioritize high-value Enterprise accounts for proactive retention
- Improve onboarding and early value realization
- Monitor revenue exposure by plan tier, not just churn rate

---

## Repository Structure

- **data/** – Source dataset (Kaggle)
- **notebooks/** – R-based exploratory analysis
- **sql/** – Schema cleaning & business-level SQL queries
- **dashboard/** – Tableau visualization
- **presentation/** – Executive summary slides

---

## SQL Highlights

The SQL portion demonstrates:

- Data type normalization & schema cleaning  
- Aggregation with COUNT, SUM, AVG  
- Conditional logic with CASE WHEN  
- Lifecycle calculation using DATEDIFF & COALESCE  
- Revenue exposure analysis  
- Multi-table JOIN example  

---

## Outcome

This project simulates a real-world SaaS churn analysis workflow, 
combining data cleaning, metric development, segmentation, 
and lifecycle-based retention analysis.

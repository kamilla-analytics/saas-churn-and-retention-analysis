# ==========================================================
# SaaS Customer Retention & Churn Analysis
# Author: Kamilla
# Project: Subscription-Level Business Analysis
# ==========================================================

# -------------------------
# 1. Load Packages
# -------------------------

# Install once if needed:
# install.packages("tidyverse")
# install.packages("lubridate")

library(tidyverse)
library(lubridate)

# -------------------------
# 2. Load Data
# -------------------------

accounts <- read_csv("ravenstack_accounts.csv")
subscriptions <- read_csv("ravenstack_subscriptions.csv")
churn <- read_csv("ravenstack_churn_events.csv")
usage <- read_csv("ravenstack_feature_usage.csv")
support <- read_csv("ravenstack_support_tickets.csv")

# -------------------------
# 3. Initial Data Exploration
# -------------------------

glimpse(subscriptions)

# -------------------------
# 4. Core Business Metrics
# -------------------------

# 4.1 Overall Churn Rate

churn_summary <- subscriptions %>%
  summarise(
    total_subscriptions = n(),
    churned = sum(churn_flag == TRUE),
    churn_rate = mean(churn_flag == TRUE)
  )

churn_summary

# Interpretation:
# 9.72% of subscriptions have churned.
# This represents the proportion of customers lost relative to the total subscription base.


# 4.2 Total Monthly Recurring Revenue (MRR)

mrr_summary <- subscriptions %>%
  summarise(
    total_mrr = sum(mrr_amount, na.rm = TRUE)
  )

mrr_summary

# Interpretation:
# Total MRR across all subscriptions is 11,338,747.
# This reflects the overall recurring revenue base of the SaaS business.


# 4.3 Revenue Lost Due to Churn

lost_mrr_summary <- subscriptions %>%
  filter(churn_flag == TRUE) %>%
  summarise(
    lost_mrr = sum(mrr_amount, na.rm = TRUE)
  )

lost_mrr_summary

# Interpretation:
# $1,179,139 in recurring revenue is associated with churned subscriptions.
# This highlights the financial impact of customer attrition.


# 4.4 Revenue Exposure Ratio

revenue_exposure <- subscriptions %>%
  summarise(
    total_mrr = sum(mrr_amount, na.rm = TRUE),
    lost_mrr = sum(mrr_amount[churn_flag == TRUE], na.rm = TRUE)
  ) %>%
  mutate(
    revenue_exposure_pct = lost_mrr / total_mrr
  )

revenue_exposure

# Interpretation:
# Approximately 10% of total recurring revenue is linked to churned subscriptions.
# Even small improvements in retention could significantly impact revenue stability.


# -------------------------
# 5. Churn Segmentation
# -------------------------

# 4.1 Churn by Plan

churn_by_plan <- subscriptions %>%
  group_by(plan_tier) %>%
  summarise(
    total_subs = n(),
    churned = sum(churn_flag == TRUE),
    churn_rate = mean(churn_flag == TRUE),
    avg_mrr = mean(mrr_amount, na.rm = TRUE),
    lost_mrr = sum(mrr_amount[churn_flag == TRUE], na.rm = TRUE)
  ) %>%
  arrange(desc(churn_rate))

churn_by_plan

# Interpretation:
# Although churn rates are relatively similar across plan tiers (~9–10%),
# Enterprise subscriptions generate significantly higher average MRR.
# As a result, Enterprise churn contributes disproportionately 
# to total revenue loss.
# This suggests that retention efforts targeting high-value Enterprise 
# customers could have a substantial financial impact.


# 5.2. Revenue Loss Contribution by Plan Tier

# Total lost MRR across all churned subscriptions
total_lost_mrr <- subscriptions %>%
  filter(churn_flag == TRUE) %>%
  summarise(total_lost = sum(mrr_amount, na.rm = TRUE)) %>%
  pull(total_lost)

# Lost MRR and contribution by plan
lost_mrr_by_plan <- subscriptions %>%
  filter(churn_flag == TRUE) %>%
  group_by(plan_tier) %>%
  summarise(
    lost_mrr = sum(mrr_amount, na.rm = TRUE),
    churned_subs = n()
  ) %>%
  mutate(
    revenue_loss_share_pct = lost_mrr / total_lost_mrr
  ) %>%
  arrange(desc(lost_mrr))

lost_mrr_by_plan

# Interpretation:
# Enterprise subscriptions account for the largest share of total revenue loss.
# While churn rates are similar across plans, the financial exposure is 
# significantly higher for Enterprise customers due to their high MRR.
# This indicates that retention strategies targeting Enterprise clients
# could yield the greatest financial impact.


# 5.3 Churn by Billing

churn_by_billing <- subscriptions %>%
  group_by(billing_frequency) %>%
  summarise(
    total_subs = n(),
    churn_rate = mean(churn_flag == TRUE),
    avg_mrr = mean(mrr_amount, na.rm = TRUE)
  )

churn_by_billing

# Interpretation:
# The churn difference between annual and monthly billing 
# is relatively small (~0.6 percentage points).
# While not dramatically different, this finding challenges 
# the assumption that annual billing ensures stronger retention.


# 5.4 Trial vs Non-Trial

trial_churn <- subscriptions %>%
  group_by(is_trial) %>%
  summarise(
    total = n(),
    churn_rate = mean(churn_flag == TRUE),
    avg_mrr = mean(mrr_amount, na.rm = TRUE)
  )

trial_churn

# Interpretation:
# While trial churn is marginally higher, it does not pose 
# a direct revenue risk since trial users contribute $0 MRR.
# Revenue exposure is concentrated within paid subscriptions.


# -------------------------
# 6. Tenure Analysis
# -------------------------

# 6.1 Tenure Calculation

subscriptions <- subscriptions %>%
  mutate(
    effective_end_date = if_else(
      is.na(end_date),
      Sys.Date(),
      end_date
    ),
    tenure_days = as.numeric(effective_end_date - start_date)
  )

# Summary statistics for tenure
summary(subscriptions$tenure_days)

# Interpretation:
# Tenure analysis reveals a wide subscription lifespan range 
# (0 to 1141 days), with a median of 522 days, indicating 
# a generally established customer base.
# The existence of very short tenures suggests that 
# churn may be concentrated in early lifecycle stages.
# This supports further investigation into onboarding 
# effectiveness and early value realization.


# 6.2 Tenure Buckets

subscriptions <- subscriptions %>%
  mutate(
    tenure_bucket = case_when(
      tenure_days <= 90 ~ "0-3 months",
      tenure_days <= 180 ~ "3-6 months",
      tenure_days <= 365 ~ "6-12 months",
      tenure_days > 365 ~ "12+ months"
    )
  )

# Interpretation:
# Tenure buckets define distinct lifecycle stages 
# within the customer journey.
# By grouping subscriptions into early, mid, and long-term stages,
# we can assess whether churn is driven by onboarding challenges,
# value realization gaps, or renewal-related factors.


# 6.3 Churn by Tenure

churn_by_tenure <- subscriptions %>%
  group_by(tenure_bucket) %>%
  summarise(
    total_subs = n(),
    churned = sum(churn_flag == TRUE),
    churn_rate = mean(churn_flag == TRUE),
    avg_mrr = mean(mrr_amount, na.rm = TRUE)
  ) %>%
  arrange(desc(churn_rate))

churn_by_tenure

# Interpretation:
# Churn is overwhelmingly concentrated in subscriptions 
# with tenure below 12 months, where churn rates reach 100%.
# In contrast, subscriptions that exceed 12 months 
# exhibit an extremely low churn rate (~0.46%).
# This suggests a strong lifecycle threshold effect:
# once customers remain subscribed beyond the first year,
# they become significantly more stable and less likely to churn.
# These findings highlight the critical importance 
# of early-stage retention and onboarding effectiveness.
# Improving retention within the first 12 months 
# could dramatically reduce overall churn.


# ==========================================================
# FINAL BUSINESS INSIGHTS
# ==========================================================

# 1. Overall churn rate stands at 9.72%.
# 2. Approximately 10% of total MRR is exposed to churn.
# 3. Enterprise subscriptions contribute disproportionately 
#    to revenue loss due to higher average MRR.
# 4. Churn is heavily concentrated in subscriptions 
#    under 12 months tenure.
# 5. Customers surviving beyond 12 months 
#    demonstrate strong retention stability.
#
# Strategic Implication:
# Retention initiatives should prioritize early lifecycle stages
# and high-value Enterprise accounts.

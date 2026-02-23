-- ==========================================================
-- SaaS Churn & Revenue Analysis (Business-Level SQL)
-- Author: Kamilla
-- Database: MySQL
-- ==========================================================

USE saas_churn;

-- ----------------------------------------------------------
-- 1. Overall Churn Rate
-- ----------------------------------------------------------
-- Calculate total subscriptions and churn percentage

SELECT 
    COUNT(*) AS total_subscriptions,
    SUM(churn_flag) AS churned_subscriptions,
    ROUND(AVG(churn_flag), 4) AS churn_rate
FROM ravenstack_subscriptions;


-- ----------------------------------------------------------
-- 2. Total Monthly Recurring Revenue (MRR)
-- ----------------------------------------------------------
-- Calculate total recurring revenue

SELECT 
    ROUND(SUM(mrr_amount), 2) AS total_mrr
FROM ravenstack_subscriptions;


-- ----------------------------------------------------------
-- 3. Revenue Lost Due to Churn
-- ----------------------------------------------------------
-- Calculate MRR associated with churned subscriptions

SELECT 
    ROUND(SUM(mrr_amount), 2) AS lost_mrr
FROM ravenstack_subscriptions
WHERE churn_flag = 1;


-- ----------------------------------------------------------
-- 4. Churn by Plan Tier
-- ----------------------------------------------------------
-- Analyze churn behavior across pricing tiers

SELECT 
    plan_tier,
    COUNT(*) AS total_subscriptions,
    SUM(churn_flag) AS churned,
    ROUND(AVG(churn_flag), 4) AS churn_rate,
    ROUND(AVG(mrr_amount), 2) AS avg_mrr
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY churn_rate DESC;


-- ----------------------------------------------------------
-- 5. Revenue Exposure by Plan Tier
-- ----------------------------------------------------------
-- Identify financial risk concentration by plan

SELECT 
    plan_tier,
    ROUND(SUM(mrr_amount), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN churn_flag = 1 THEN mrr_amount ELSE 0 END), 2) AS lost_mrr,
    ROUND(
        SUM(CASE WHEN churn_flag = 1 THEN mrr_amount ELSE 0 END)
        / SUM(mrr_amount),
        4
    ) AS revenue_exposure_ratio
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY revenue_exposure_ratio DESC;


-- ----------------------------------------------------------
-- 6. Churn by Billing Frequency
-- ----------------------------------------------------------
-- Compare monthly vs annual churn

SELECT 
    billing_frequency,
    COUNT(*) AS total_subscriptions,
    ROUND(AVG(churn_flag), 4) AS churn_rate,
    ROUND(AVG(mrr_amount), 2) AS avg_mrr
FROM ravenstack_subscriptions
GROUP BY billing_frequency;


-- ----------------------------------------------------------
-- 7. Tenure Calculation
-- ----------------------------------------------------------
-- Compute subscription lifecycle duration

SELECT 
    subscription_id,
    DATEDIFF(
        COALESCE(end_date, CURRENT_DATE),
        start_date
    ) AS tenure_days
FROM ravenstack_subscriptions;


-- ----------------------------------------------------------
-- 8. Churn by Tenure Bucket
-- ----------------------------------------------------------
-- Identify lifecycle stages with highest churn

SELECT 
    CASE
        WHEN DATEDIFF(COALESCE(end_date, CURRENT_DATE), start_date) <= 90 THEN '0-3 months'
        WHEN DATEDIFF(COALESCE(end_date, CURRENT_DATE), start_date) <= 180 THEN '3-6 months'
        WHEN DATEDIFF(COALESCE(end_date, CURRENT_DATE), start_date) <= 365 THEN '6-12 months'
        ELSE '12+ months'
    END AS tenure_bucket,
    COUNT(*) AS total_subscriptions,
    ROUND(AVG(churn_flag), 4) AS churn_rate
FROM ravenstack_subscriptions
GROUP BY tenure_bucket
ORDER BY churn_rate DESC;
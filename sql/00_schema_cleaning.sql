-- ==========================================================
-- Schema Cleaning & Data Type Normalization
-- Project: SaaS Churn Analysis
-- ==========================================================

USE saas_churn;

-- --------------------------------------------
-- 1. Clean Boolean Fields (text → numeric)
-- --------------------------------------------

UPDATE ravenstack_subscriptions 
SET is_trial = 1 WHERE is_trial = 'True';

UPDATE ravenstack_subscriptions 
SET is_trial = 0 WHERE is_trial = 'False';

UPDATE ravenstack_subscriptions 
SET upgrade_flag = 1 WHERE upgrade_flag = 'True';

UPDATE ravenstack_subscriptions 
SET upgrade_flag = 0 WHERE upgrade_flag = 'False';

UPDATE ravenstack_subscriptions 
SET downgrade_flag = 1 WHERE downgrade_flag = 'True';

UPDATE ravenstack_subscriptions 
SET downgrade_flag = 0 WHERE downgrade_flag = 'False';

UPDATE ravenstack_subscriptions 
SET churn_flag = 1 WHERE churn_flag = 'True';

UPDATE ravenstack_subscriptions 
SET churn_flag = 0 WHERE churn_flag = 'False';

-- --------------------------------------------
-- 2. Clean Date Fields (empty → NULL)
-- --------------------------------------------

SELECT DISTINCT is_trial FROM ravenstack_subscriptions;

UPDATE ravenstack_subscriptions
SET end_date = NULL
WHERE end_date = '';

UPDATE ravenstack_subscriptions
SET start_date = NULL
WHERE start_date = '';

-- --------------------------------------------
-- 3. Modify Schema Types
-- --------------------------------------------

ALTER TABLE ravenstack_subscriptions
MODIFY start_date DATETIME,
MODIFY end_date DATETIME,
MODIFY mrr_amount DOUBLE,
MODIFY arr_amount DOUBLE,
MODIFY is_trial INT,
MODIFY upgrade_flag INT,
MODIFY downgrade_flag INT,
MODIFY churn_flag INT;
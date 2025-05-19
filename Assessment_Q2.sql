with transactions as (
SELECT 
        EXTRACT(MONTH FROM transaction_date) AS transaction_date,
        cust.id,
        COUNT(*) AS total_transactions,
        COUNT(DISTINCT cust.id) AS unique_cust
    FROM adashi_staging.users_customuser AS cust
    JOIN adashi_staging.savings_savingsaccount AS save
        ON cust.id = save.owner_id
    GROUP BY EXTRACT(MONTH FROM transaction_date),cust.id),
freq as 
(select * ,
case WHEN total_transactions <= 3 THEN 'Low Frequency'
WHEN total_transactions BETWEEN 4 AND 9 THEN 'Medium Frequency'
ELSE 'High Frequency' end frequency_category
from transactions )

select frequency_category, 
sum(unique_cust) customer_count,
    sum(total_transactions)/COUNT(unique_cust) AS avg_transactions_per_month
FROM freq
GROUP BY frequency_category;

-- Step 1: Get total transactions per customer per month
WITH transactions AS (
    SELECT 
        EXTRACT(MONTH FROM save.transaction_date) AS transaction_month,
        cust.id AS customer_id,
        COUNT(*) AS total_transactions,
        COUNT(DISTINCT cust.id) AS unique_cust
    FROM adashi_staging.users_customuser AS cust
    JOIN adashi_staging.savings_savingsaccount AS save
        ON cust.id = save.owner_id
    GROUP BY 
        EXTRACT(MONTH FROM save.transaction_date), 
        cust.id
),

-- Step 2: Categorize customers based on transaction frequency
freq AS (
    SELECT *,
        CASE 
            WHEN total_transactions <= 3 THEN 'Low Frequency'
            WHEN total_transactions BETWEEN 4 AND 9 THEN 'Medium Frequency'
            ELSE 'High Frequency'
        END AS frequency_category
    FROM transactions
)

-- Step 3: Aggregate results by frequency category
SELECT 
    frequency_category, 
    SUM(unique_cust) AS customer_count,
    SUM(total_transactions) * 1.0 / COUNT(unique_cust) AS avg_transactions_per_month
FROM freq
GROUP BY frequency_category;

-- Identify customers who have active plans but no confirmed savings inflow
WITH working_base AS (
    SELECT 
        save.owner_id,
        plan.id AS plan_id,
        plan.name AS plan_name,
        plan.is_regular_savings,
        plan.is_a_fund,
        save.confirmed_amount,
        save.transaction_date
    FROM adashi_staging.savings_savingsaccount AS save
    JOIN adashi_staging.plans_plan AS plan
        ON save.owner_id = plan.owner_id
    WHERE save.confirmed_amount = 0
)

-- From the filtered base, get last transaction date and inactive duration
SELECT 
    plan_id,
    owner_id,
    MAX(DATE(transaction_date)) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(DATE(transaction_date))) AS inactive_days
FROM working_base
WHERE transaction_date BETWEEN CURRENT_DATE - INTERVAL '1' YEAR AND CURRENT_DATE
GROUP BY plan_id, owner_id;

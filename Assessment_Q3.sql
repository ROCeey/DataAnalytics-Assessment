select * 
FROM adashi_staging.savings_savingsaccount AS save
    JOIN adashi_staging.plans_plan AS plan
        ON save.owner_id = plan.owner_id
where confirmed_amount = 0;

-- Get customers who have plans but no confirmed savings inflow
with working_base as (
SELECT 
    save.owner_id AS owner_id,
    plan.id AS plan_id,
    plan.name AS plan_name,
    plan.is_regular_savings,
    plan.is_a_fund,
    save.confirmed_amount,
    save.transaction_date
FROM adashi_staging.savings_savingsaccount AS save
JOIN adashi_staging.plans_plan AS plan
    ON save.owner_id = plan.owner_id
WHERE save.confirmed_amount = 0)

select plan_id, owner_id, max(date(transaction_date)) last_transaction_date, datediff(current_date, max(date(transaction_date)))
from working_base
group by plan_id, owner_id

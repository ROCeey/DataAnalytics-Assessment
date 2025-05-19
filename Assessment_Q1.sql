SELECT 
    cust.id,
    CONCAT(cust.first_name, ' ', cust.last_name) AS name,
    COUNT(DISTINCT CASE WHEN plan.is_regular_savings = 1 THEN plan.id END) AS savings_count, #Count the number of unique savings plans (where is_regular_savings = 1)
    COUNT(DISTINCT CASE WHEN plan.is_a_fund = 1 THEN plan.id END) AS investment_count, # Count the number of unique investment plans (where is_a_fund = 1)
    ROUND(SUM(save.confirmed_amount) / 100.0, 2) AS total_funded_naira #Sum the confirmed amount (inflow) from all funded plans and convert from kobo to naira
FROM adashi_staging.users_customuser AS cust
JOIN adashi_staging.savings_savingsaccount AS save
    ON cust.id = save.owner_id
JOIN adashi_staging.plans_plan AS plan
    ON save.plan_id = plan.id
WHERE 
    save.confirmed_amount > 0 # Filter to only include savings/investment accounts that have actually been funded
GROUP BY cust.id, cust.first_name, cust.last_name
# Ensure the user has at least one savings plan AND one investment plan
HAVING 
    COUNT(DISTINCT CASE WHEN plan.is_regular_savings = 1 THEN plan.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN plan.is_a_fund = 1 THEN plan.id END) >= 1;


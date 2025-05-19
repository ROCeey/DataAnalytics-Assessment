# Cowrywise Data Analytics Assessment

## Overview
This repository contains solutions to a SQL-based technical assessment designed to evaluate data extraction, transformation, and aggregation skills.

---

## 🔍 Question Breakdown

### Q1: High-Value Customers with Multiple Products
- Identified customers with both a savings and an investment plan.
- Filtered based on confirmed deposits and used joins to aggregate product counts.
- Use Conditional Aggregation to count saving and investment
- Filtered for only fundec account ie. confirmed_amount > 0

### Q2: Transaction Frequency Analysis
- Calculated average monthly transaction per user.
- Categorized them into High, Medium, and Low frequency tiers.


---

## 💡 Challenges & Resolutions

- Some assumptions were made about date fields (`created_at`, `date_joined`) as actual schema was not provided.
- Handled currency in kobo by converting to naira (dividing by 100).

---

## 📌 Notes

- All queries are modular and use CTEs for readability.
- Comments added to explain complex logic.
- The output matches expected formats as per the problem statements.

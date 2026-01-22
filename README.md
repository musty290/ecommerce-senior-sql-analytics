# Ecommerce Senior SQL Analytics

## Overview
This project simulates the work of a **Senior Data Analyst** analyzing an
e-commerce business using SQL.

It focuses on revenue growth, customer behavior, churn risk, and advanced
analytical insights used for decision-making.

---

## Business Questions Answered
- How is revenue growing month over month?
- Which customer cohorts generate the most lifetime value?
- Where do users drop off in the conversion funnel?
- How much revenue is lost due to churn?
- Who are the highest-value customers?
- Are there abnormal sales spikes that require investigation?

---

## Dataset Structure
Tables used in this project:
- `customers`
- `orders`
- `payments`
- `products`
- `order_items`
- `events`

---

## Analysis Breakdown

### 1️⃣ Revenue & Growth Analysis
- Monthly revenue trends
- Month-over-month growth rate
- Pareto analysis (Top 20% customers)

### 2️⃣ Customer Cohort Analysis
- Signup month cohorts
- Retention behavior
- Lifetime Value (LTV) per cohort

### 3️⃣ Funnel Conversion Analysis
- Visit → Add to Cart → Checkout → Purchase
- Conversion rates & drop-off analysis

### 4️⃣ Churn & Risk Segmentation
- Active vs At-Risk vs Churned users
- Revenue lost to churn

### 5️⃣ Advanced Analytics (Senior-Level)
- Running revenue totals
- Moving averages (7-day / 30-day)
- Customer LTV ranking
- Abnormal sales spike detection

---
## Tools
- SQL (MySQL/PostgreSQL)
- Designed for BI tools like Tableau or Power BI

- 
## Why This Project Matters
This project demonstrates:
- Strong SQL fundamentals
- Business-first analytical thinking
- Senior-level problem framing
- Clean, recruiter-friendly organization

## Assumptions & Definitions
- Churned customer: no purchase in the last 90 days
- At-risk customer: last purchase between 60–90 days
- Active customer: purchase within the last 60 days
- Revenue: sum of successful payment amounts
- Cohorts: grouped by customer signup month

## Key Insights
- A small percentage of customers contribute the majority of revenue
- Certain cohorts show faster revenue decay over time
- Funnel drop-offs are highest between checkout and purchase
- Churned users represent a significant revenue loss opportunity

## Business Decisions Enabled
- Prioritize retention campaigns for at-risk customers
- Invest in high-performing acquisition cohorts
- Optimize checkout experience to reduce funnel drop-off
- Focus loyalty programs on high-LTV customers

## Outcome
This analysis helps:
- Identify revenue drivers
- Reduce churn
- Optimize conversion funnels
- Focus on high-value customers

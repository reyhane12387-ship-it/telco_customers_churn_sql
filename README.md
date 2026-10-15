# Telco Customer Churn Analysis (SQL Server / T-SQL)

## Project Overview
An exploratory analysis of customer churn in a telecom company, written in **T-SQL (SQL Server)**.
The project looks at how monthly price level relates to churn and how much monthly revenue is lost to churned customers.

- **Dataset:** IBM Telco Customer Churn (Kaggle), 7,043 customers, 21 columns
- **Tools:** SQL Server 2022, SSMS
- **Author:** Reyhaneh Sadeghian Zamani

## Business Questions
1. Does the monthly price level affect churn?
2. How much monthly revenue is lost to churned customers?

## SQL Skills Demonstrated
| Skill | Where it is used |
|---|---|
| `SELECT`, `WHERE` | Filtering churned customers |
| Aggregates (`COUNT`, `SUM`) | Customer counts, lost revenue |
| `GROUP BY` | Grouping customers by price segment |
| `CASE WHEN` | Price segments and churn flags |

## Data Preparation
- Imported the CSV into SQL Server with the Import Wizard.
- The wizard converted Yes/No columns (e.g. `Churn`, `Partner`, `TechSupport`) to `bit` (1/0), so churn is filtered with `churn = 1`.

## Analysis

### 1. Churn by monthly charge level
Customers were split into three price segments: Low (under 35), Medium (35 to 75) and High (over 75).

```sql
SELECT CASE WHEN MonthlyCharges < 35 THEN 'Low'
            WHEN MonthlyCharges <= 75 THEN 'Medium'
            ELSE 'High' END AS charge_group,
       COUNT(*) AS customers,
       SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned
FROM [WA_Fn-UseC_-Telco-Customer-Churn]
GROUP BY CASE WHEN MonthlyCharges < 35 THEN 'Low'
              WHEN MonthlyCharges <= 75 THEN 'Medium'
              ELSE 'High' END;
```

| Charge group | Customers | Churned | Churn rate |
|---|---|---|---|
| Low (< 35) | 1,731 | 188 | 10.9% |
| Medium (35-75) | 2,192 | 600 | 27.4% |
| High (> 75) | 3,120 | 1,081 | 34.7% |

**Finding:** Churn rises as the monthly charge rises. The high-charge group churns about 3x more than the low-charge group, so the company is losing its most valuable customers fastest.

### 2. Monthly revenue lost to churn
```sql
SELECT SUM(MonthlyCharges) AS lost_monthly_revenue
FROM [WA_Fn-UseC_-Telco-Customer-Churn]
WHERE churn = 1;
```

**Finding:** Churned customers represent about **139,131** in lost monthly revenue.

## Business Recommendation
Protect high-value customers: offer loyalty perks or a price review to customers paying more than 75 per month, since this group has the highest churn.

## Limitations
- This is a descriptive analysis; it shows associations, not causes.
- Some Yes/No columns were imported as `bit`, so the "No internet service" category is not preserved in those columns.

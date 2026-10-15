--select  count(*) from [WA_Fn-UseC_-Telco-Customer-Churn] where churn='1'
--select round( avg(MonthlyCharges),2) from [WA_Fn-UseC_-Telco-Customer-Churn]
--select count(*) from [WA_Fn-UseC_-Telco-Customer-Churn] where Contract='month-to-month'
--select top(10) tenure, customerid,monthlycharges from [WA_Fn-UseC_-Telco-Customer-Churn] order by MonthlyCharges desc
--select count(*)as customers , gender from [WA_Fn-UseC_-Telco-Customer-Churn] group by  gender
--select paymentmethod, count(*)as everyone, sum(case when churn=1 then  1 else 0 end)as churned from [WA_Fn-UseC_-Telco-Customer-Churn] group by PaymentMethod
/*select count(*) as custs,
 case when monthlycharges< 35 then 'low ' when monthlycharges<= 75 then 'medium' else 'high' end ,
sum( case when churn= 1 then 1 else 0 end)
from [WA_Fn-UseC_-Telco-Customer-Churn] 
group by  case when monthlycharges< 35 then 'low ' when monthlycharges<= 75 then 'medium' else 'high' end */
 /*select avg(monthlycharges)as avgmonthly, internetservice from [WA_Fn-UseC_-Telco-Customer-Churn]
 group by  InternetService
 order by avgmonthly desc */
-- select  sum(monthlycharges)as lost from [WA_Fn-UseC_-Telco-Customer-Churn] where churn=1
/*select c.contract, count(t.customerid), c.discountpct
from [WA_Fn-UseC_-Telco-Customer-Churn] as t
join contract_info as c on c.contract=t.contract
group by c.contract, c.discountpct */
/*with contractdetail as (
select  count(*)as cust, contract, sum(case when churn=1 then 1 else 0 end)as churned
from [WA_Fn-UseC_-Telco-Customer-Churn] 
group by Contract)
select* from contractdetail where churned> 300 */
/*with by_payment as (
select sum( case when churn=1 then 1 else 0 end)as churned, count(*)as custs, PaymentMethod
from [WA_Fn-UseC_-Telco-Customer-Churn] group by PaymentMethod) ,
company_churned_rate as (
select 100.0* sum(case when churn=1 then 1 else 0 end )/ count(*)  as companyrate
from [WA_Fn-UseC_-Telco-Customer-Churn])
select b.paymentmethod,b.custs,r. companyrate,b.churned
from by_payment as b cross join company_churned_rate as r */
/*WITH new_by_contract AS (
SELECT Contract,COUNT(*) AS new_customers,SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS new_churned
 FROM [WA_Fn-UseC_-Telco-Customer-Churn]
WHERE tenure < 12 GROUP BY Contract),
new_overall AS (SELECT 100.0 * SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) / COUNT(*) AS all_new_rate_pct
FROM [WA_Fn-UseC_-Telco-Customer-Churn] WHERE tenure < 12)
SELECT n.Contract,
n.new_customers,n.new_churned,ROUND(100.0 * n.new_churned / n.new_customers, 1) AS new_churn_rate_pct,
 ROUND(o.all_new_rate_pct, 1) AS all_new_rate_pct,
 CASE WHEN 100.0 * n.new_churned / n.new_customers > o.all_new_rate_pct THEN 'Above' ELSE 'Below' END AS status
FROM new_by_contract n CROSS JOIN new_overall o ORDER BY new_churn_rate_pct DESC;/*SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned
FROM [WA_Fn-UseC_-Telco-Customer-Churn] GROUP BY PaymentMethod),
company AS (SELECT 100.0 * SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) / COUNT(*) AS company_rate
FROM [WA_Fn-UseC_-Telco-Customer-Churn]),
final AS (SELECT b.PaymentMethod,b.custs, ROUND(100.0 * b.churned / b.custs, 1) AS churn_rate_pct,
ROUND(c.company_rate, 1) AS company_rate_pct FROM by_payment b CROSS JOIN company c)
SELECT PaymentMethod,custs,churn_rate_pct,company_rate_pct,churn_rate_pct - company_rate_pct AS diff_pct,
CASE WHEN churn_rate_pct > company_rate_pct THEN 'Worse' ELSE 'Better' END AS status
FROM final ORDER BY diff_pct DESC;
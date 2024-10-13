--find top 10 highest reveue generating products 
select 
product_id, sum(sell_price) as sale from df_orders
group by product_id order by sale desc limit 10 ;




--find top 5 highest selling products in each region
with cte as (
select region,product_id,sum(sell_price) as sale
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sale desc) as rn
from cte) A
where rn<=5



--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as (
select Extract(year from order_date) as order_year, Extract(month from order_date) as order_month,
sum(sell_price) as sale
from df_orders
group by Extract(year from order_date), Extract(month from order_date)	
--order by year(order_date),month(order_date)
	)
select order_month
, sum(case when order_year=2022 then sale else 0 end) as sale_2022
, sum(case when order_year=2023 then sale else 0 end) as sale_2023
from cte 
group by order_month
order by order_month




--for each category which month had highest sales 
with cte as (
select category,TO_CHAR(order_date,'yyyy-MM') as order_year_month
, sum(sell_price) as sale 
from df_orders
group by category,TO_CHAR(order_date,'yyyy-MM')
--order by category,format(order_date,'yyyy-MM')
)
select * from (
select *,
row_number() over(partition by category order by sale desc) as rn
from cte
) a
where rn=1





--which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,Extract(year from order_date) as order_year,
sum(sell_price) as sale
from df_orders
group by sub_category,Extract(year from order_date)
--order by year(order_date),month(order_date)
	)
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sale else 0 end) as sales_2022
, sum(case when order_year=2023 then sale else 0 end) as sales_2023
from cte 
group by sub_category
)
select  *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) desc limit 1























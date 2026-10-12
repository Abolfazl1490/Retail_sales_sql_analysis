CREATE DATABASE retail_sales_portfolio;

USE retail_sales_portfolio;


create table retail_sales_portfolio.retail_sales(
order_id int primary key,
order_date date not null,
customer_id varchar(10) not null,
customer_segment varchar(30) not null,
city varchar(50) not null,
product_category varchar(40) not null,
product_name varchar(80) not null,
quantity int not null,
unit_price decimal(10,2) not null,
discount_pct decimal(4,2) not null,
sales decimal(12,2) not null,
profit decimal(12,2) not null,
payment_method varchar(30) not null
);

select count(*) as total_rows
from retail_sales;
select*
from retail_sales 
limit 10; 

select
sum(order_date is null) as missing_dates,
sum(customer_id is null or customer_id = '') as missing_customers,
sum(city is null or city='') as missing_cities,
sum(product_name is null or product_name = '') as missing_products
from retail_sales;

select *
from retail_sales
where quantity<= 0
or unit_price < 0
or sales < 0
or discount_pct not between 0 and 1; 

select
min(order_date) as first_order,
max(order_date) as last_order
from retail_sales;

select distinct city 
from retail_sales
order by city;

select distinct product_category 
from retail_sales;

select *
from retail_sales
order by sales desc
limit 10;

select 
count(*) as total_orders_rows,
round(sum(sales),2) as total_sales,
round(sum(profit),2)as total_profit,
count(distinct customer_id)as unique_customers,
round(avg(sales),2) as avg_sales_per_row,
round(sum(profit)/ nullif(sum(sales),0) *100,2) as profit_margin_pct
from retail_sales;





select
product_category,
sum(quantity) as unit_sold,
round(sum(sales), 2) as total_sales,
round(sum(profit), 2) as total_profit
from retail_sales
group by product_category
order by total_sales desc;

select
city,
count(*) as order_count,
round(sum(sales), 2) as total_sales,
round(sum(profit), 2) as total_profit
from retail_sales
group by city
order by total_sales desc;

select
customer_segment,
count(*) as order_rows,
count(distinct customer_id) as customers,
round(sum(sales), 2) as total_sales,
round(avg(sales), 2) as avg_rows_sales
from retail_sales
group by customer_segment
order by total_sales desc;

select
product_name,
sum(quantity) as unique_sold,
round(sum(sales), 2) as total_sales,
round(sum(profit), 2) as total_profit
from retail_sales
group by product_name
order by total_sales desc
limit 10;

select
discount_pct,
count(*) as order_rows,
round(avg(sales), 2) as avrage_sales,
round(avg(profit), 2) as avrage_profit,
round(sum(sales), 2) as  total_sales
from retail_sales
group by discount_pct
order by discount_pct;


select
date_format(order_date, '%Y-%m') as sales_month,
round(sum(sales), 2) as monthly_sales,
round(sum(profit), 2) as monthly_profit
from retail_sales
group by date_format(order_date, '%Y-%m')
order by sales_month;

WITH product_profit AS (
    SELECT
        product_category,
        product_name,
        SUM(profit) AS total_profit
    FROM retail_sales
    GROUP BY product_category, product_name
)
SELECT
    product_category,
    product_name,
    ROUND(total_profit, 2) AS total_profit,
    DENSE_RANK() OVER (
        PARTITION BY product_category
        ORDER BY total_profit DESC
    ) AS profit_rank
FROM product_profit
ORDER BY product_category, profit_rank;


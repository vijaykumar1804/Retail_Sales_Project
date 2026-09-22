Create database Retail_sales;
use Retail_sales;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

set sql_safe_updates = 1;
-- data cleaning...
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- data Analysis and key problems...
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
select * from retail_sales 
where date(sale_date) ='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantiy sold is more than 3 in
-- the month of Nov-2022..
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 3
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as net_sales,
           count(quantity)as total_orders from retail_sales 
           group by category;
           
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category,round(avg(age),2) from retail_sales group by category having category ='beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,count(transactions_id) from retail_sales group by category,gender order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT year, month
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        ROW_NUMBER() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rn
    FROM retail_sales
    GROUP BY 1,2
) x
WHERE rn = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales..
select customer_id,sum(total_sale)net_sales from retail_sales group by customer_id order by net_sales desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) from retail_sales group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)..
select shift,count(transactions_id) from 
(select *,case 
when extract( hour from sale_time)<12 then 'Morning'
when extract( hour from sale_time) between 12 and 17 then 'Afternoon'
else'Evening' end as shift 
from retail_sales)a 
group by shift order by shift;

-- End of Project....

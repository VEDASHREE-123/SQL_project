drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weighrInGms INTEGER,
outofStock BOOLEAN,
quantitu INTEGER
);

--data exploration

--count of rows
select count(*) from zepto;

--sample data
select * from zepto
limit 10;

--null values
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
discountedsellingprice is null
or
availablequantity is null
or
outofstock is null
or
quantitu is null;

--diffrent product categories
select distinct category
from zepto
order by category;

--products in stock vs out of stock
select outofstock, count(sku_id)
from zepto
group by outofstock;

---product names persent multiple times
select name, count(sku_id) as "number of skus"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

---data cleaning

----product with proce=0
select * from zepto
where mrp=0 or discountedsellingprice=0;

delete from zepto 
where mrp=0;

---convert paise to rupees
update zepto
set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;

select mrp,discountedsellingprice from zepto

---data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name, mrp,discountpercent
from zepto
order by discountpercent desc
limit 10;

--Q2.What are the Products with High MRP but Out of Stock
select distinct name,mrp
from zepto
where outofstock=TRUE and mrp>300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category,
sum(discountedsellingprice*availablequantity) as total_revenue
from zepto
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name, mrp, discountpercent
from zepto
where mrp>500 and discountpercent<10
order by mrp desc,discountpercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,
round(avg(discountpercent),2)as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,weighringms,discountedsellingprice,
round(discountedsellingprice/weighringms,2)as price_per_gram
from zepto
where weighringms>=100
order by price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name,weighringms,
case when weighringms < 1000 then'Low'
     when weighringms < 5000 then'Medium'
	 else'Bulk'
	 end as weight_category
from zepto;

--Q8.What is the Total Inventory Weight Per Category 
select category,
sum(weighringms*availablequantity)as total_weight
from zepto
group by category
order by total_weight;


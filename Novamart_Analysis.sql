Use novamartdb;
--- Task 1: Total Revenue
select sum(TotalAmount) as TotalRevenue from sales;
--- Task 2: 
select count(SaleID) AS Processedtrxs from sales;
--- Task 3:
select AVG(TotalAmount) as Average_order_value from sales;
--- Task 4:
select count(CustomerID) as unique_customers from customers;
--- Task 1:
select count(ProductID) as Products from products;
--- Task 5:
select c.FirstName, c.LastName, sum(s.TotalAmount) as Total_Revenue
From customers c
join sales s
on c.CustomerID = s.CustomerID
group by c.CustomerID, c.FirstName, c.LastName
Order by Total_Revenue desc 
Limit 10;
--- Task 6:
select p.ProductName, sum(s.TotalAmount) as TotalRevenue
from products p 
join sales s 
on p.ProductID = s.ProductID 
group by p.ProductID, p.ProductName
order by TotalRevenue Desc
limit 10;
--- Task 7:
select sr.FullName, sum(s.TotalAmount) as TotalRevenue
from salesreps sr 
join sales s 
on sr.SalesRepID = s.SalesRepID 
group by sr.SalesrepID, sr.FullName 
order by TotalRevenue desc;
--- Task 8:
use novamartdb;
select c.FirstName, c.LastName, sum(s.TotalAmount) as TotalRevenue
from customers c 
join sales s 
on c.CustomerID = s.CustomerID
where sum(s.TotalAmount) > 2000000.00
group by c.CustomerID, c.FirstName, c.LastName
order by TotalRevenue;

use novamartdb;

select c.FirstName, c.LastName, sum(s.TotalAmount) as TotalRevenue
from customers c 
join sales s 
on c.CustomerID = s.CustomerID
group by c.CustomerID, c.FirstName, c.LastName
having sum(s.TotalAmount) > 2000000.00
order by TotalRevenue desc;

Use novamartdb;
CREATE TABLE Suppliers (
    SupplierID VARCHAR(10) PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactPerson VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    SupplierType VARCHAR(30),
    PartnershipYear INT,
    Status VARCHAR(20)
);
CREATE TABLE Products (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(150),
    ProductType VARCHAR(50),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    CostPrice DECIMAL(12,2),
    SellingPrice DECIMAL(12,2),
    ProfitMargin DECIMAL(6,2),
    Stock INT,
    ReorderLevel INT,
    WarrantyMonths INT,
    LaunchYear INT,
    Status VARCHAR(20),
    SupplierID VARCHAR(10),

    FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Segment VARCHAR(20),
    PreferredPaymentMethod VARCHAR(30),
    RegistrationDate DATE,
    Status VARCHAR(20)
);

CREATE TABLE SalesReps (
    SalesRepID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    FullName VARCHAR(100),
    Branch VARCHAR(50),
    State VARCHAR(50),
    HireDate DATE,
    JobTitle VARCHAR(50),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    TargetSales DECIMAL(12,2),
    CommissionRate DECIMAL(5,2),
    Status VARCHAR(20)
); 
select count(*) as suppliers from suppliers;
select count(*) as products from products;
select count(*) as customers from customers;
select count(*) as salesreps from salesreps;
select * from suppliers limit 5;
select* from customers limit 10;
select* from salesreps limit 4;

create table Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    SaleDate DATE NOT NULL,
    CustomerID VARCHAR(10) NOT NULL,
    ProductID VARCHAR(10) NOT NULL,
    SalesRepID VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(12,2) NOT NULL,
    Discount DECIMAL(5,2) DEFAULT 0.00,
    TotalAmount DECIMAL(12,2) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),
    FOREIGN KEY (SalesRepID)
        REFERENCES SalesReps(SalesRepID)
); 
describe sales;
show create table sales;

DELIMITER $$

CREATE PROCEDURE GenerateSales(IN NumRows INT)
BEGIN

    DECLARE i INT DEFAULT 1;

    DECLARE vCustomerID VARCHAR(10);
    DECLARE vProductID VARCHAR(10);
    DECLARE vSalesRepID VARCHAR(10);

    DECLARE vUnitPrice DECIMAL(12,2);

    DECLARE vQuantity INT;

    DECLARE vDiscount DECIMAL(5,2);

    DECLARE vTotal DECIMAL(12,2);

    DECLARE vSaleDate DATE;

    DECLARE vPaymentMethod VARCHAR(30);

    WHILE i <= NumRows DO

        SELECT CustomerID
        INTO vCustomerID
        FROM Customers
        ORDER BY RAND()
        LIMIT 1;

        SELECT ProductID, SellingPrice
        INTO vProductID, vUnitPrice
        FROM Products
        ORDER BY RAND()
        LIMIT 1;

        SELECT SalesRepID
        INTO vSalesRepID
        FROM SalesReps
        ORDER BY RAND()
        LIMIT 1;

        SET vQuantity = FLOOR(1 + RAND() * 5);

        SET vDiscount = ROUND(RAND() * 15,2);

        SET vSaleDate = DATE_ADD(
            '2025-01-01',
            INTERVAL FLOOR(RAND()*365) DAY
        );

        SET vPaymentMethod =
            ELT(
                FLOOR(1 + RAND()*4),
                'Cash',
                'Card',
                'Bank Transfer',
                'Mobile Money'
            );

        SET vTotal =
            (vUnitPrice * vQuantity) -
            ((vUnitPrice * vQuantity) * (vDiscount/100));

        INSERT INTO Sales
        (
            SaleDate,
            CustomerID,
            ProductID,
            SalesRepID,
            Quantity,
            UnitPrice,
            Discount,
            TotalAmount,
            PaymentMethod
        )
        VALUES
        (
            vSaleDate,
            vCustomerID,
            vProductID,
            vSalesRepID,
            vQuantity,
            vUnitPrice,
            vDiscount,
            vTotal,
            vPaymentMethod
        );

        SET i = i + 1;

    END WHILE;

END$$

DELIMITER ;

CALL GenerateSales(100);

select count(*) from sales;
select* from sales limit 10;
call generatesales (10000);
select count(*) from sales;
truncate table sales;
select count(*) from sales;
call generatesales (10000);
select count(*) from sales;
select* from sales limit 200;

select min(saleID), max(saleID) From sales;
select* from sales limit 5;
use novamartdb;
select count(*) from sales;
select count(*) from suppliers;

use novamartdb;
select* from sales limit 5;
select sr.FullName, s.TotalAmount, Sum(TotalAmount) As TotalRevenue
From Salesreps sr
join Sales s 
On sr.SalesRepID = s.SalesRepID
Group By sr.FullName, TotalRevenu
Order By s.TotalAmount Desc 
Limit 1;
use novamartdb; 
select sr.FullName, s.TotalAmount, Sum(TotalAmount) As TotalRevenue
From Salesreps sr
join Sales s 
On sr.SalesRepID = s.SalesRepID
Group By sr.FullName, s.TotalAmount
Order By TotalRevenue Desc 
Limit 1;

select sr.FullName, sum(s.TotalAmount) as TotalRevenue
from Salesreps sr
join sales s
on sr.SalesRepID = s.SalesRepID
group by sr.SalesrepID, sr.FullName
order by TotalRevenue desc
limit 1;





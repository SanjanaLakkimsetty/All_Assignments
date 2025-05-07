CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    JobTitle VARCHAR(100)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, JobTitle) VALUES
(101, 'Sanjana', 'L', 1, 'Software Developer'),
(102, 'Ujwala', 'N', 1, 'QA Engineer'),
(103, 'Prasanna', 'Jetti', 2, 'HR Manager'),
(104, 'Indira', 'Sai', 3, 'Marketing Executive'),
(105, 'Surya', 'L', 2, 'Recruiter');

GO
CREATE PROCEDURE GetEmployeesByDeptID 
    @dept_id INT
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DepartmentID, JobTitle
    FROM Employees
    WHERE DepartmentID = @dept_id;
END
GO

EXEC GetEmployeesByDeptID @dept_id = 1;
EXEC GetEmployeesByDeptID @dept_id = 2;
EXEC GetEmployeesByDeptID @dept_id = 3;



--2
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,  
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE ErrorLogs (
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    ErrorMessage VARCHAR(1000),
    ErrorTimestamp DATETIME
);

GO
CREATE PROCEDURE InsertProduct
    @ProductID INT,
    @ProductName VARCHAR(100),
    @Price DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Products (ProductID, ProductName, Price)
        VALUES (@ProductID, @ProductName, @Price);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(1000), 
                @ErrorTimestamp DATETIME;

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @ErrorTimestamp = GETDATE();
        INSERT INTO ErrorLogs (ErrorMessage, ErrorTimestamp)
        VALUES (@ErrorMessage, @ErrorTimestamp);
    END CATCH
END;
GO
EXEC InsertProduct @ProductID = 1, @ProductName = 'Laptop', @Price = 1000.00;
EXEC InsertProduct @ProductID = 1, @ProductName = 'Tablet', @Price = 300.00;

SELECT * FROM ErrorLogs;


--3
CREATE TABLE Employees1 (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees1 (EmployeeID, FirstName, LastName, Position, Salary)
VALUES 
(1, 'Sanjana', 'L', 'Software Engineer', 50000.00),
(2, 'Joshi', 'Thota', 'Data Scientist', 55000.00),
(3, 'Prasanna', 'J', 'Product Manager', 60000.00),
(4, 'Bobby', 'P', 'HR Manager', 45000.00);

GO
CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10, 2)
AS
BEGIN
    UPDATE Employees1
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmployeeID;
END;
GO


EXEC UpdateEmployeeSalary @EmployeeID = 1, @NewSalary = 55000.00;
EXEC UpdateEmployeeSalary @EmployeeID = 2, @NewSalary = 60000.00;
EXEC UpdateEmployeeSalary @EmployeeID = 3, @NewSalary = 65000.00;

SELECT EmployeeID, FirstName, LastName, Position, Salary
FROM Employees1
WHERE EmployeeID IN (1, 2, 3);

--4
CREATE TABLE Products1 (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

INSERT INTO Products1 (ProductID, ProductName, Category, Price)
VALUES
(1, 'Laptop', 'Electronics', 1200.00),
(2, 'Smartphone', 'Electronics', 800.00),
(3, 'Desk Chair', 'Furniture', 150.00),
(4, 'Coffee Table', 'Furniture', 100.00),
(5, 'Washing Machine', 'Appliances', 500.00);

GO
CREATE PROCEDURE GetProductsByCategory
    @CategoryName VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Products1 WHERE Category = @CategoryName)
    BEGIN
        SELECT ProductID, ProductName, Category, Price
        FROM Products1
        WHERE Category = @CategoryName;
    END
    ELSE
    BEGIN
        PRINT 'Category not found';
    END
END;
GO

EXEC GetProductsByCategory @CategoryName = 'Electronics';
EXEC GetProductsByCategory @CategoryName = 'Toys';


--5
CREATE TABLE Sales2 (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    SaleAmount DECIMAL(10, 2),
    SaleDate DATETIME
);

INSERT INTO Sales2(SaleID, CustomerID, SaleAmount, SaleDate)
VALUES
(1, 101, 250.00, '2025-05-01'),
(2, 101, 450.00, '2025-05-02'),
(3, 102, 300.00, '2025-05-03'),
(4, 103, 150.00, '2025-05-04'),
(5, 101, 200.00, '2025-05-05');

GO
CREATE PROCEDURE CalculateTotalSales
    @CustomerID INT,         
    @TotalSales DECIMAL(10, 2) OUTPUT
AS
BEGIN
    SELECT @TotalSales = SUM(SaleAmount)
    FROM Sales2
    WHERE CustomerID = @CustomerID;

    IF @TotalSales IS NULL
    BEGIN
        SET @TotalSales = 0;
    END
END;
GO

DECLARE @SalesForCustomer101 DECIMAL(10, 2);
DECLARE @SalesForCustomer102 DECIMAL(10, 2);
DECLARE @SalesForCustomer103 DECIMAL(10, 2);

EXEC CalculateTotalSales @CustomerID = 101, @TotalSales = @SalesForCustomer101 OUTPUT;
PRINT 'Total Sales for Customer 101: ' + CAST(@SalesForCustomer101 AS VARCHAR);

EXEC CalculateTotalSales @CustomerID = 102, @TotalSales = @SalesForCustomer102 OUTPUT;
PRINT 'Total Sales for Customer 102: ' + CAST(@SalesForCustomer102 AS VARCHAR);

EXEC CalculateTotalSales @CustomerID = 103, @TotalSales = @SalesForCustomer103 OUTPUT;
PRINT 'Total Sales for Customer 103: ' + CAST(@SalesForCustomer103 AS VARCHAR);


--29th 1

CREATE TABLE Customers1 (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

CREATE TABLE Orderr (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderTotal DECIMAL(10, 2),
    OrderStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Customers1(CustomerID, FirstName, LastName, Email, PhoneNumber)
VALUES
(1, 'Sanjana', 'L', 'sanjana@gmail.com', '1234567890'),
(2, 'Ujwala', 'N', 'ujwala@gmail.com', '0987654321');

INSERT INTO Orderr (OrderID, CustomerID, OrderDate, OrderTotal, OrderStatus)
VALUES
(1, 1, '2025-05-01', 100.00, 'Pending'),
(2, 1, '2025-05-02', 150.00, 'Shipped'),
(3, 2, '2025-05-01', 200.00, 'Delivered');

GO
CREATE PROCEDURE GetCustomerOrderes
    @CustomerID INT
AS
BEGIN
    SELECT OrderID, OrderDate, OrderTotal, OrderStatus
    FROM Orderr
    WHERE CustomerID = @CustomerID;
END;
GO
GetCustomerOrderes 1

GO
CREATE PROCEDURE UpdateOrderStatus
    @OrderID INT,
    @NewStatus VARCHAR(20)
AS
BEGIN
    UPDATE Orderr
    SET OrderStatus = @NewStatus
    WHERE OrderID = @OrderID;

    SELECT 'Order status updated successfully' AS ConfirmationMessage;
END;
GO

EXEC UpdateOrderStatus @OrderID = 1, @NewStatus = 'Shipped';

GO
CREATE PROCEDURE UpdateOrderStatus1
    @OrderID INT,
    @NewStatus VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        SELECT 'Error: OrderID does not exist' AS ErrorMessage;
    END
    ELSE
    BEGIN
        UPDATE Orders
        SET OrderStatus = @NewStatus
        WHERE OrderID = @OrderID;
        
        SELECT 'Order status updated successfully' AS ConfirmationMessage;
    END
END;
GO

EXEC GetCustomerOrders @CustomerID = 1;


SELECT * FROM Orders WHERE OrderID = 1;

EXEC UpdateOrderStatus1 @OrderID = 9999, @NewStatus = 'Delivered';


--2
CREATE TABLE Products2 (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    StockQuantity INT,
    Price DECIMAL(10, 2)
);

CREATE TABLE RestockLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    RestockDate DATETIME,
    QuantityAdded INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products2 (ProductID, ProductName, Category, StockQuantity, Price) VALUES
(1, 'Wireless Mouse', 'Electronics', 20, 499.00),
(2, 'Notebook', 'Stationery', 5, 50.00),
(3, 'Pen Drive 64GB', 'Electronics', 100, 799.00),
(4, 'Water Bottle', 'Home', 8, 150.00),
(5, 'Laptop Stand', 'Electronics', 2, 999.00);

GO
CREATE PROCEDURE GetLowStockProducts
    @Threshold INT
AS
BEGIN
    SELECT ProductID, ProductName, Category, StockQuantity, Price
    FROM Products2
    WHERE StockQuantity < @Threshold;
END;
GO

CREATE PROCEDURE RestockProduct
    @ProductID INT,
    @QuantityToAdd INT
AS
BEGIN
    UPDATE Products2
    SET StockQuantity = StockQuantity + @QuantityToAdd
    WHERE ProductID = @ProductID;

    SELECT StockQuantity
    FROM Products2
    WHERE ProductID = @ProductID;
END;



GO
CREATE PROCEDURE RestockProduct1
    @ProductID INT,
    @QuantityToAdd INT
AS
BEGIN
    UPDATE Products2
    SET StockQuantity = StockQuantity + @QuantityToAdd
    WHERE ProductID = @ProductID;

    INSERT INTO RestockLog (ProductID, RestockDate, QuantityAdded)
    VALUES (@ProductID, GETDATE(), @QuantityToAdd);

    SELECT StockQuantity
    FROM Products2
    WHERE ProductID = @ProductID;
END;


EXEC RestockProduct1 @ProductID = 2, @QuantityToAdd = 50;
SELECT * FROM Products2;

SELECT * FROM RestockLog;


--01 - 1
CREATE TABLE Sales1 (
    Region VARCHAR(50),
    Product VARCHAR(50),
    Year INT,
    SalesAmount DECIMAL(10, 2)
);

INSERT INTO Sales1 (Region, Product, Year, SalesAmount) VALUES
('North', 'Laptop', 2022, 150000.00),
('North', 'Laptop', 2023, 180000.00),
('South', 'Laptop', 2022, 130000.00),
('South', 'Laptop', 2023, 160000.00),
('North', 'Tablet', 2022, 50000.00),
('North', 'Tablet', 2023, 70000.00),
('South', 'Tablet', 2022, 40000.00),
('South', 'Tablet', 2023, 60000.00),
('North', 'Mobile', 2022, 90000.00),
('North', 'Mobile', 2023, 95000.00),
('South', 'Mobile', 2022, 85000.00),
('South', 'Mobile', 2023, 90000.00);

SELECT Product, [2022] AS Sales_2022, [2023] AS Sales_2023
FROM (
    SELECT Product, Year, SalesAmount
    FROM Sales1
) AS SourceTable
PIVOT (
    SUM(SalesAmount)
    FOR Year IN ([2022], [2023])
) AS PivotTable;


WITH PivotedData AS (
    SELECT Product, [2022] AS Sales_2022, [2023] AS Sales_2023
    FROM (
        SELECT Product, Year, SalesAmount
        FROM Sales1
    ) AS SourceTable
    PIVOT (
        SUM(SalesAmount)
        FOR Year IN ([2022], [2023])
    ) AS PivotTable
)
SELECT Product,
       CASE Year
           WHEN 'Sales_2022' THEN 2022
           WHEN 'Sales_2023' THEN 2023
       END AS Year,
       SalesAmount
FROM PivotedData
UNPIVOT (
    SalesAmount FOR Year IN (Sales_2022, Sales_2023)
) AS UnpivotedResult;


--2
CREATE TABLE Employees3 (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees3 (EmployeeID, Name, Department, Salary) VALUES
(101, 'Sanjana','Software Developer',55000),
(102, 'Ujwala','QA Engineer', 60000),
(103, 'Prasanna','HR Manager',45000),
(104, 'Indira', 'Marketing Executive',25000),
(105, 'Surya','Recruiter', 70000);

SELECT *
INTO HighSalaryEmployees1
FROM Employees3
WHERE Salary > 60000;

EXEC sp_help HighSalaryEmployees1;

SELECT * FROM HighSalaryEmployees1;

--3
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    CASE
        WHEN Salary < 40000 THEN 'Low'
        WHEN Salary BETWEEN 40000 AND 60000 THEN 'Medium'
        WHEN Salary > 60000 THEN 'High'
    END AS SalaryRange
FROM Employees3;

--4
CREATE TABLE Orders2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    ShippedDate DATE
);

INSERT INTO Orders2 (OrderID, CustomerName, OrderDate, ShippedDate) VALUES
(1, 'Sanjana', '2023-01-10', '2023-01-15'),
(3, 'Prasanna', '2023-01-15', '2023-01-20'),
(5, 'Surya', '2023-01-20', '2023-01-25');

INSERT INTO Orders2 (OrderID, CustomerName, OrderDate) VALUES
(2, 'Ujju', '2023-01-12'),
(4, 'Indu', '2023-01-23');

select * from Orders2;

SELECT 
    OrderID,
    CustomerName,
    OrderDate,
    COALESCE(CONVERT(VARCHAR, ShippedDate, 23), 'Not Shipped') AS ShippedDateStatus,
    CASE 
        WHEN ShippedDate IS NOT NULL THEN 'Delivered'
        ELSE 'Pending'
    END AS DeliveryStatus
FROM Orders2;

--5
CREATE TABLE Scores (
    StudentID INT,
    Subject VARCHAR(100),
    MarksObtained INT,
    MaximumMarks INT
);

INSERT INTO Scores (StudentID, Subject, MarksObtained, MaximumMarks) VALUES
(1, 'Math', 80, 100),
(2, 'Science', 45, 50),
(3, 'History', 70, 0),  
(4, 'English', 60, 75),
(5, 'Geography', 0, 100);

SELECT 
    StudentID,
    Subject,
    MarksObtained,
    MaximumMarks,
    CASE 
        WHEN MaximumMarks = 0 THEN 'Invalid Max Marks'
        ELSE CAST(MarksObtained * 100.0 / NULLIF(MaximumMarks, 0) AS VARCHAR(20)) + '%'
    END AS Percentage
FROM Scores;

--6
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    StaffName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Age INT,
    CONSTRAINT FK_Department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    CONSTRAINT CHK_Age CHECK (Age > 18)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

INSERT INTO Staff (StaffID, StaffName, DepartmentID, Age) VALUES
(1, 'Sanjana', 1, 30),
(2, 'Ujju', 2, 25),
(3, 'Indu', 3, 35);

INSERT INTO Staff (StaffID, StaffName, DepartmentID, Age) VALUES
(4, NULL, 1, 22);

INSERT INTO Staff (StaffID, StaffName, DepartmentID, Age) VALUES
(5, 'Rama', 99, 28);

INSERT INTO Staff (StaffID, StaffName, DepartmentID, Age) VALUES
(6, 'ira', 1, 17);

SELECT * FROM Departments;
SELECT * FROM Staff;


--7
CREATE TABLE TemporaryData (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT
);

INSERT INTO TemporaryData (ID, Name, Age) VALUES
(1, 'Sanjana', 20),
(2, 'Ujwala', 25),
(3, 'Indu', 35);


TRUNCATE TABLE TemporaryData;

SELECT * FROM TemporaryData;

DROP TABLE TemporaryData;

--8
CREATE TABLE Products3 (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2),
    StockQuantity SMALLINT,
    LaunchDate DATE
);

INSERT INTO Products3 (ProductID, ProductName, Price, StockQuantity, LaunchDate)
VALUES
(1, 'Laptop', 799.99, 50, '2023-01-10'),
(2, 'Smartphone', 599.99, 100, '2023-02-15'),
(3, 'Tablet', 399.99, 150, '2023-03-20');

-- Trying to insert invalid data in Price column (text instead of decimal)
INSERT INTO Products3 (ProductID, ProductName, Price, StockQuantity, LaunchDate)
VALUES
(4, 'Monitor', 'Not Available', 75, '2023-04-25');

-- Trying to insert invalid data in LaunchDate column (text instead of date)
INSERT INTO Products3 (ProductID, ProductName, Price, StockQuantity, LaunchDate)
VALUES
(5, 'Headphones', 199.99, 200, 'Not a Date');


select * from Products3

--02-1
CREATE TABLE Employees4 (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    Bonus DECIMAL(10, 2)
);

INSERT INTO Employees4 (EmpID, Name, DepartmentID, Salary, Bonus) VALUES
(1, 'Sanjana', 10, 70000, 5000),
(2, 'Ujwala', 10, 50000, 3000),
(3, 'Yash', 20, 60000, 4000),
(4, 'Prasanna', 20, 80000, 6000),
(5, 'Indira', 30, 55000, 2000),
(6, 'Surya', 30, 75000, 7000);

CREATE TABLE DepartmentSalaryAverage1 (
    DepartmentID INT PRIMARY KEY,
    AvgSalary DECIMAL(10,2)
);

INSERT INTO DepartmentSalaryAverage1
SELECT DepartmentID, AVG(Salary)
FROM Employees4
GROUP BY DepartmentID;

CREATE TRIGGER trg_UpdateDeptAvg1
ON Employees4
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AffectedDepartments TABLE (DepartmentID INT);

    INSERT INTO @AffectedDepartments (DepartmentID)
    SELECT DISTINCT DepartmentID FROM INSERTED
    UNION
    SELECT DISTINCT DepartmentID FROM DELETED;

    DELETE FROM DepartmentSalaryAverage1
    WHERE DepartmentID IN (SELECT DepartmentID FROM @AffectedDepartments);

    INSERT INTO DepartmentSalaryAverage1 (DepartmentID, AvgSalary)
    SELECT DepartmentID, AVG(Salary)
    FROM Employees4
    WHERE DepartmentID IN (SELECT DepartmentID FROM @AffectedDepartments)
    GROUP BY DepartmentID;
END;

CREATE VIEW HighEarnersView1 AS
SELECT E.EmpID, E.Name, E.DepartmentID, E.Salary, E.Bonus
FROM Employees4 E
JOIN DepartmentSalaryAverage1 D
ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > D.AvgSalary;


SELECT * FROM HighEarnersView1;

INSERT INTO Employees4 (EmpID, Name, DepartmentID, Salary, Bonus)
VALUES (7, 'LowSalary', 10, 20000, 1000);

SELECT * FROM DepartmentSalaryAverage1;
SELECT * FROM HighEarnersView1;

UPDATE Employees4 SET Salary = 90000 WHERE EmpID = 2;

SELECT * FROM DepartmentSalaryAverage1;
SELECT * FROM HighEarnersView1;

DELETE FROM Employees4 WHERE EmpID = 4;

SELECT * FROM DepartmentSalaryAverage1;
SELECT * FROM HighEarnersView1;


--2

CREATE TABLE Customers2 (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Orderstable (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers2(CustomerID)
);


INSERT INTO Customers2 (CustomerID, Name) VALUES
(1, 'Sanjana'),
(2, 'Ujwala'),
(3, 'Yash');


INSERT INTO Orderstable (OrderID, CustomerID, OrderDate, OrderAmount) VALUES
(101, 1, '2024-12-01', 500.00),
(102, 1, '2025-01-15', 750.00),
(103, 2, '2025-02-10', 600.00),
(104, 3, '2025-01-05', 900.00),
(105, 3, '2025-03-20', 1000.00);

SELECT 
    C.CustomerID,
    C.Name,
    O.OrderDate,
    O.OrderAmount
FROM 
    Customers2 C
JOIN 
    Orderstable O ON C.CustomerID = O.CustomerID
WHERE 
    O.OrderDate = (
        SELECT MAX(O2.OrderDate)
        FROM Orderstable O2
        WHERE O2.CustomerID = C.CustomerID
    );

CREATE INDEX idx_OrderDate ON Orderstable(OrderDate);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    SaleAmount DECIMAL(10, 2),
    SaleYear INT
);

INSERT INTO Sales VALUES
(1, 'Laptop', 50000.00, 2022),
(2, 'Mobile', 32000.00, 2022),
(3, 'Tablet', 15000.00, 2022),
(4, 'Laptop', 60000.00, 2023),
(5, 'Mobile', 38000.00, 2023);

CREATE PROCEDURE GetTotalSalesByYear (@Year INT)
AS
BEGIN
    SELECT ProductName, SUM(SaleAmount) AS TotalSales
    FROM Sales
    WHERE SaleYear = @Year
    GROUP BY ProductName;
END;


EXEC GetTotalSalesByYear @Year = 2022;

ALTER TABLE Sales ADD Region VARCHAR(50);

UPDATE Sales SET Region = 'North' WHERE SaleID IN (1, 2);
UPDATE Sales SET Region = 'South' WHERE SaleID IN (3, 4);

CREATE PROCEDURE GetTotalSalesByYearAndRegion (@Year INT)
AS
BEGIN
    SELECT Region, ProductName, SUM(SaleAmount) AS TotalSales
    FROM Sales
    WHERE SaleYear = @Year
    GROUP BY Region, ProductName;
END;

EXEC GetTotalSalesByYearAndRegion @Year = 2022;

CREATE PROCEDURE CalculateBonus (@BaseSalary DECIMAL(10, 2), @PerformanceRating INT)
AS
BEGIN
    DECLARE @BonusPercentage DECIMAL(5, 2);

    IF @BaseSalary < 50000
        SET @BonusPercentage = 0.05;
    ELSE IF @BaseSalary BETWEEN 50000 AND 80000
        SET @BonusPercentage = 0.10;
    ELSE
        SET @BonusPercentage = 0.15;
    SET @BonusPercentage = @BonusPercentage * (@PerformanceRating / 5.0);
    
    SELECT @BaseSalary * @BonusPercentage AS FinalBonus;
END;

EXEC CalculateBonus @BaseSalary = 60000, @PerformanceRating = 4;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2),
    VendorID INT
);

INSERT INTO Products VALUES
(1, 'Smartphone', 29999.99, 1540),
(2, 'Laptop', 74999.50, 1550),
(3, 'Tablet', 19999.99, 1540),
(4, 'Headphones', 4500.00, 1540);

UPDATE Products
SET Price = Price * 1.1 
WHERE VendorID = 1540;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    ContactNumber VARCHAR(15)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Customers VALUES
(1, 'Ravi Kumar', '9876543210'),
(2, 'Neha Singh', '9998887777'),
(3, 'Suresh Reddy', '9445671234');

DELETE FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

CREATE TABLE Sales (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    SaleAmount DECIMAL(10, 2)
);

CREATE TABLE TopProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    SaleAmount DECIMAL(10, 2)
);


INSERT INTO Sales VALUES
(1, 'Smartphone', 15000.00),
(2, 'Laptop', 25000.00),
(3, 'Tablet', 12000.00),
(4, 'Headphones', 5000.00);

INSERT INTO TopProducts (ProductID, ProductName, SaleAmount)
SELECT ProductID, ProductName, SaleAmount
FROM Sales
WHERE SaleAmount > 10000;


SELECT * FROM TopProducts;
-- Question 1: Achieving 1NF
-- Use a recursive CTE (Common Table Expression) to split comma-separated values
WITH RECURSIVE SplitProducts AS (
  
  -- First step: get the first product from each row
  SELECT 
    OrderID,
    CustomerName,
    
    -- Get the first product (before the first comma)
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    
    -- Get the rest of the string (everything after the first product and comma)
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS Remaining
  FROM ProductDetail

  UNION ALL

  -- Recursive step: keep splitting the remaining string
  SELECT
    OrderID,
    CustomerName,
    
    -- Get the next product from the Remaining string
    TRIM(SUBSTRING_INDEX(Remaining, ',', 1)) AS Product,
    
    -- Update Remaining to remove the product we just extracted
    SUBSTRING(Remaining, LENGTH(SUBSTRING_INDEX(Remaining, ',', 1)) + 2)
  FROM SplitProducts
  
  -- Continue recursion only if there's more text to split
  WHERE Remaining <> ''
)

-- Final result: display each product in its own row
SELECT OrderID, CustomerName, Product
FROM SplitProducts
ORDER BY OrderID;


-- Question 2
-- To fix this, we split the table into two:

--First table
-- Step 1: Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName)
VALUES 
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Step 2: Create OrderItems table
-- Second table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderItems (OrderID, Product, Quantity)
VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

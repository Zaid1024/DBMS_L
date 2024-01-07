
Creation:-

CREATE TABLE Customer (
    CustNo INT PRIMARY KEY,
    cname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    Orders_no INT PRIMARY KEY,
    odate DATE,
    cust_no INT,
    Orders_amt INT,
    FOREIGN KEY (cust_no) REFERENCES Customer(CustNo)
);


CREATE TABLE Item (
    item_no INT PRIMARY KEY,
    unit_price INT
);
	
CREATE TABLE Orders_Item (
    Orders_no INT,
    item_no INT,
    qty INT,
    PRIMARY KEY (Orders_no, item_no),
    FOREIGN KEY (Orders_no) REFERENCES Orders(Orders_no),
    FOREIGN KEY (item_no) REFERENCES Item(item_no)
);


CREATE TABLE Shipment (
    Orders_no INT,
    warehouse_no INT,
    ship_date DATE,
    PRIMARY KEY (Orders_no),
    FOREIGN KEY (Orders_no) REFERENCES Orders(Orders_no)
);

CREATE TABLE Warehouse (
    warehouse_no INT PRIMARY KEY,
    city VARCHAR(50)
);

------------------------------------------------------------------------------------------------------>>>>>>>>>>>>>>>>>>

Insertion:-

-- Inserting data into Customer Table
INSERT INTO Customer (CustNo, cname, city) VALUES
(1, 'Amit Kumar', 'Bangalore'),
(2, 'Priya Sharma', 'Mysuru'),
(3, 'Rajesh Singh', 'Hubli'),
(4, 'Sneha Patel', 'Belagavi'),
(5, 'Karthik Reddy', 'Mangalore'),
(6, 'Ananya Gupta', 'Gulbarga'),
(7, 'Vijay Singh', 'Shimoga'),
(8, 'Neha Kapoor', 'Davanagere'),
(9, 'Rahul Verma', 'Bellary'),
(10, 'Pooja Desai', 'Bidar');

-- Inserting data into Orders Table
INSERT INTO Orders(Orders_no, odate, cust_no, Orders_amt) VALUES
(101, '2023-01-15', 1, 5000),
(102, '2023-02-20', 2, 7000),
(103, '2023-03-10', 3, 8000),
(104, '2023-04-05', 4, 6000),
(105, '2023-05-12', 5, 9000),
(106, '2023-06-18', 6, 7500),
(107, '2023-07-02', 7, 8200),
(108, '2023-08-22', 8, 5500),
(109, '2023-09-15', 9, 6800),
(110, '2023-10-08', 10, 7200);

-- Inserting data into Item Table
 -- Inserting data into Orders_Item Table
INSERT INTO Orders_Item (Orders_no, item_no, qty) VALUES
(101, 1, 2),
(101, 2, 3),
(102, 1, 1),
(103, 3, 2),
(104, 4, 4),
(105, 5, 3),
(106, 2, 2),
(107, 1, 3),
(108, 5, 1),
(109, 4, 2);

-- Inserting data into Shipment Table
INSERT INTO Shipment (Orders_no, warehouse_no, ship_date) VALUES
(101, 1, '2023-01-20'),
(102, 2, '2023-02-25'),
(103, 1, '2023-03-15'),
(104, 3, '2023-04-10'),
(105, 2, '2023-05-18'),
(106, 1, '2023-06-25'),
(107, 3, '2023-07-10'),
(108, 1, '2023-08-28'),
(109, 2, '2023-09-20'),
(110, 3, '2023-10-15');

-- Inserting data into Warehouse Table
INSERT INTO Warehouse (warehouse_no, city) VALUES
(1, 'Bangalore'),
(2, 'Mysuru'),
(3, 'Hubli');

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- List the Orders# and Ship_date for all Orderss shipped from Warehouse# "0001".

select Orders_no,ship_date from Shipment where warehouse_no=1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- List the Warehouse information from which the Customer named "Kumar" was supplied his Orderss. Produce a listing of Orders#, Warehouse#

select Orders_no,warehouse_no from Warehouse natural join Shipment where Orders_no in (select Orders_no from Orders where cust_no in (Select cust_no from Customer where cname like "%Amit Kumar%"));

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Produce a listing: Cname, #ofOrderss, Avg_Orders_Amt, where the middle column is the total number of Orderss by the customer and the last column is the average Orders amount for that customer. (Use aggregate functions) 

select cname, COUNT(*) as no_of_Orderss, AVG(Orders_amt) as avg_Orders_amt
from Customer c, Orders o
where c.CustNo=o.cust_no 
group by cname;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete all Orderss for customer named "Kumar".

delete from Orders where cust_no = (select cust_no from Customer where cname like "%Amit Kumar%");

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Find the item with the maximum unit price.

select max(unit_price) from Item;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- A tigger that updates Orders_amount based on quantity and unit price of Orders_item
DELIMITER $$

CREATE TRIGGER UpdateOrdersAmt
AFTER INSERT ON Orders_Item
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET Orders_amt = (NEW.qty * (SELECT DISTINCT unit_price FROM Items WHERE item_no = NEW.item_no))
    WHERE Orders.Orders_no = NEW.Orders_no;
END;

$$

DELIMITER ;

INSERT INTO Orders VALUES
(006, "2020-12-23", 0004, 1200);

INSERT INTO OrdersItems VALUES 
(006, 0001, 5); -- This will automatically update the Orderss Table also

select * from Orders;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create a view to display OrdersID and shipment date of all Orderss shipped from a warehouse 2.

create view ShipmentDatesFromWarehouse2 as
select Orders_no, ship_date
from Shipment
where warehouse_no=2;

select * from ShipmentDatesFromWarehouse2;

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

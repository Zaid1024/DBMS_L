
Creation:-

CREATE TABLE Employee (
    SSN VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(10, 2),
    SuperSSN VARCHAR(20),
    DNo INT
);

CREATE TABLE Department(
    DNo INT PRIMARY KEY,
    DName VARCHAR(50),
    MgrSSN VARCHAR(20),
    MgrStartDate DATE,
    FOREIGN KEY (MgrSSN) REFERENCES Employee(SSN)
);

CREATE TABLE DLocation(
    DNo INT,
    DLoc VARCHAR(100),
    PRIMARY KEY (DNo, DLoc),
    FOREIGN KEY (DNo) REFERENCES Department(DNo)
);

CREATE TABLE Project (
    PNo INT PRIMARY KEY,
    PName VARCHAR(50),
    PLocation VARCHAR(100),
    DNo INT,
    FOREIGN KEY (DNo) REFERENCES Department(DNo)
);

CREATE TABLE Works_on(
    SSN VARCHAR(20),
    PNo INT,
    Hours DECIMAL(5, 2),
    PRIMARY KEY (SSN, PNo),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN),
    FOREIGN KEY (PNo) REFERENCES Project(PNo)
);



------------------------------------------------------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>

Insertion:-

-- Employees
INSERT INTO Employee (SSN, Name, Address, Sex, Salary, SuperSSN, DNo) VALUES
('333-44-5555', 'Raj Kumar', '789 Pine St, Hubli, Karnataka, India', 'M', 75000.00, 333-44-5555, 2),
('111-22-3333', 'Amit Patel', '123 Main St, Bangalore, Karnataka, India', 'M', 60000.00, '333-44-5555', 1),
('222-33-4444', 'Priya Sharma', '456 Oak St, Mysuru, Karnataka, India', 'F', 55000.00, '333-44-5555', 1),
('444-55-6666', 'Ananya Gupta', '101 Cedar St, Mangalore, Karnataka, India', 'F', 50000.00, '333-44-5555', 1),
('555-66-7777', 'Vikram Singh', '202 Maple St, Belgaum, Karnataka, India', 'M', 65000.00, '333-44-5555', 2),
('666-77-8888', 'Neha Verma', '303 Elm St, Gulbarga, Karnataka, India', 'F', 60000.00, '333-44-5555', 2),
('777-88-9999', 'Rahul Kapoor', '404 Birch St, Hassan, Karnataka, India', 'M', 70000.00, '333-44-5555', 3),
('888-99-0000', 'Aisha Khan', '505 Walnut St, Udupi, Karnataka, India', 'F', 80000.00, '333-44-5555', 3),
('999-00-1111', 'Sanjay Joshi', '606 Pineapple St, Bidar, Karnataka, India', 'M', 72000.00, '333-44-5555', 3),
('123-45-6789', 'Kavita Reddy', '707 Mango St, Raichur, Karnataka, India', 'F', 68000.00, '333-44-5555', 1);

-- Departments
INSERT INTO Department (DNo, DName, MgrSSN, MgrStartDate) VALUES
(1, 'HR Department', '333-44-5555', '2022-01-01'),
(2, 'IT Department', '555-66-7777', '2022-02-01'),
(3, 'Finance Department', '777-88-9999', '2022-03-01');

-- Department Locations (Karnataka locations)
INSERT INTO DLocation(DNo, DLoc) VALUES
(1, 'Bangalore, Karnataka, India'),
(2, 'Belgaum, Karnataka, India'),
(3, 'Hassan, Karnataka, India');

-- Projects
INSERT INTO Project (PNo, PName, PLocation, DNo) VALUES
(101, 'Employee Database System', 'Bangalore, Karnataka, India', 1),
(102, 'IT Infrastructure Upgrade', 'Belgaum, Karnataka, India', 2),
(103, 'Financial Reporting System', 'Hassan, Karnataka, India', 3);

-- Works On
INSERT INTO Works_on(SSN, PNo, Hours) VALUES
('111-22-3333', 101, 40),
('222-33-4444', 102, 35),
('333-44-5555', 103, 30),
('444-55-6666', 101, 25),
('555-66-7777', 102, 20),
('666-77-8888', 103, 15),
('777-88-9999', 101, 40),
('888-99-0000', 102, 35),
('999-00-1111', 103, 30),
('123-45-6789', 101, 25);


ALTER TABLE Employee
ADD CONSTRAINT FK_Department_Employee
FOREIGN KEY (DNo) REFERENCES Department(DNo);

---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, either as a worker or as a manager of the department that controls the project.

select PNo,PName,name 
from Project p, Employee e 
where p.DNo=e.DNo and e.name like "%Krishna";

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise
SELECT w.ssn, e.name, e.salary AS old_salary, e.salary * 1.1 AS new_salary
FROM Works_on w
JOIN Employee e ON w.ssn = e.ssn
WHERE w.PNo = (
    SELECT PNo
    FROM Project
    WHERE PName = "IOT"
);



----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, and the average salary in this department

select sum(salary) as sal_sum, max(salary) as sal_max,min(salary) as sal_min,avg(salary) as sal_avg from Employee e join Department d on e.DNo=d.DNo where d.DName="Accounts";

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve the name of each employee who works on all the projects controlled by department number 1 (use NOT EXISTS operator).

select Employee.ssn,name,DNo from Employee where not exists
    (select PNo from Project p where p.DNo=1 and PNo not in
    	(select PNo from Works_on w where w.ssn=Employee.ssn));

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For each department that has more than one employees, retrieve the department number and the number of its employees who are making more than Rs. 6,00,000.

select d.DNo, count(*) from Department d join Employee e on e.DNo=d.DNo where salary>600000 group by d.DNo having count(*) >1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create a view that shows name, dept name and location of all employees

create view emp_details as
select name,DName,DLoc from Employee e join Department d on e.DNo=d.DNo join DLocation dl on d.DNo=dl.DNo;

select * from emp_details;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create a trigger that prevents a project from being deleted if it is currently being worked by any employee.

DELIMITER //
create trigger PreventDelete
before delete on Project
for each row
BEGIN
	IF EXISTS (select * from Works_on where PNo=old.PNo) THEN
		signal sqlstate '45000' set message_text='This project has an employee assigned';
	END IF;
END; //

DELIMITER ;

delete from Project where PNo=241563; -- Will give error 

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx








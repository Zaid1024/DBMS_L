
Creation:-

CREATE TABLE PERSON (
    driver_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100)
);

CREATE TABLE CAR (
    regno VARCHAR(20) PRIMARY KEY,
    model VARCHAR(50),
    year INT
);

CREATE TABLE ACCIDENT (
    report_number INT PRIMARY KEY,
    acc_date DATE,
    location VARCHAR(100)
);

CREATE TABLE OWNS (
    driver_id VARCHAR(20),
    regno VARCHAR(20),
    PRIMARY KEY (driver_id, regno),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (regno) REFERENCES CAR(regno)
);

CREATE TABLE PARTICIPATED (
    driver_id VARCHAR(20),
    regno VARCHAR(20),
    report_number INT,
    damage_amount INT,
    PRIMARY KEY (driver_id, regno, report_number),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (regno) REFERENCES CAR(regno),
    FOREIGN KEY (report_number) REFERENCES ACCIDENT(report_number)
);

---------------------------------------------------------------------------------------------------------------->>>>>>>>>>>>>>>>>

Insertion:-

INSERT INTO PERSON(DRIVER_ID,NAME,ADDRESS) VALUES 
('D01','VARUN','MYSURU'),
('D02','ZAID','MYSURU'),
('D03','AMEEN','MYSURU'),
('D04','RAHUL','MYSURU'),
('D05','LOKESH','MYSURU');

INSERT INTO CAR(REGNO,MODEL,YEAR) VALUES
('ABC123','TOYOTA','2020'),
('XYZ456','HONDA','2019'),
('DEF789','FORD','2021'),
('GHI101','TATA','2020'),
('JKL121','NISSAN','2018');

INSERT INTO ACCIDENT(REPORT_NUMBER,ACC_DATE,LOCATION) VALUES 
(1,'2020-09-15','INTERSECTION A'),
(2,'2020-09-18','HIGHWAY B'),
(3,'2020-09-20','STREET C'),
(4,'2020-09-22','AVENUE D'),
(5,'2020-09-25','ROAD E');

INSERT INTO OWNS(DRIVER_ID,REGNO) VALUES
('D01','ABC123'),
('D02','XYZ456'),
('D03','DEF789'),
('D04','GHI101'),
('D05','JKL121');

INSERT INTO PARTICIPATED(DRIVER_ID,REGNO,REPORT_NUMBER,DAMAGE_AMOUNT) values 
('D01','ABC123',1,5000),
('D02','XYZ456',2,1500),
('D03','DEF789',3,800),
('D04','GHI101',4,1200),
('D05','JKL121',5,2000);

-----------------------------------------------------------------------------------------------------------------------------------------------------

1.Find the total number of people who owned cars that were involved in accidents in 2021.

SELECT COUNT(DISTINCT p.DRIVER_ID) AS TotalPeople
FROM PERSON p
JOIN OWNS o ON p.DRIVER_ID = o.DRIVER_ID
JOIN CAR c ON o.REGNO = c.REGNO
JOIN PARTICIPATED pa ON o.DRIVER_ID = pa.DRIVER_ID AND o.REGNO = pa.REGNO
JOIN ACCIDENT a ON pa.REPORT_NUMBER = a.REPORT_NUMBER
WHERE YEAR(a.ACC_DATE) = 2021;

--------------------------------------------------------------------------------------------------------------

2.Find the number of accidents in which the cars belonging to “ZAID” were involved.

SELECT COUNT(*) AS NumberOfAccidents
FROM PERSON p
JOIN OWNS o ON p.DRIVER_ID = o.DRIVER_ID
JOIN CAR c ON o.REGNO = c.REGNO
JOIN PARTICIPATED pa ON o.DRIVER_ID = pa.DRIVER_ID AND o.REGNO = pa.REGNO
JOIN ACCIDENT a ON pa.REPORT_NUMBER = a.REPORT_NUMBER
WHERE p.NAME = 'ZAID';

--------------------------------------------------------------------------------------------------------------

3.Add a new accident to the database; assume any values for required attributes.

INSERT INTO ACCIDENT (REPORT_NUMBER, ACC_DATE, LOCATION)
VALUES (6, '2023-01-15', 'JUNCTION F');

---------------------------------------------------------------------------------------------------------------

4.Delete the HONDA belonging to “ZAID”.


DECLARE @regnoToDelete VARCHAR(20);

SELECT @regnoToDelete = o.REGNO
FROM PERSON p
JOIN OWNS o ON p.DRIVER_ID = o.DRIVER_ID
JOIN CAR c ON o.REGNO = c.REGNO
WHERE p.NAME = 'ZAID' AND c.MODEL = 'HONDA';


DELETE FROM OWNS
WHERE REGNO = @regnoToDelete;


DELETE FROM CAR
WHERE REGNO = @regnoToDelete;

----------------------------------------------------------------------------------------------------------------

5.Update the damage amount for the car with license number “ABC123” in the accident with report.

UPDATE PARTICIPATED
SET DAMAGE_AMOUNT = 6000
WHERE REGNO = 'ABC123' AND REPORT_NUMBER = 1;

-----------------------------------------------------------------------------------------------------------------

6.A view that shows models and year of cars that are involved in accident.

CREATE VIEW AccidentCarsView AS
SELECT DISTINCT c.MODEL, c.YEAR
FROM CAR c
JOIN OWNS o ON c.REGNO = o.REGNO
JOIN PARTICIPATED pa ON o.DRIVER_ID = pa.DRIVER_ID AND o.REGNO = pa.REGNO;

-----------------------------------------------------------------------------------------------------------------

7.A trigger that prevents a driver from participating in more than 3 accidents in a given year.
DELIMITER //

CREATE TRIGGER prevent_excessive_accidents
BEFORE INSERT ON PARTICIPATED
FOR EACH ROW
BEGIN
    DECLARE accidents_count INTEGER;

    SELECT COUNT(*)
    INTO accidents_count
    FROM PARTICIPATED pa
    JOIN ACCIDENT a ON pa.REPORT_NUMBER = a.REPORT_NUMBER
    WHERE pa.DRIVER_ID = NEW.DRIVER_ID AND YEAR(a.ACC_DATE) = YEAR(CURRENT_DATE);

    IF accidents_count >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Driver has already participated in 3 accidents this year';
    END IF;
END;
//

DELIMITER ;

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx



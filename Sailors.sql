
--Creation:-
CREATE DATABASE sailors;
use sailors;

CREATE TABLE sailors (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    rating INT,
    age INT
);

CREATE TABLE boat (
    bid INT PRIMARY KEY,
    bname VARCHAR(50),
    color VARCHAR(10)
);

CREATE TABLE reserves (
    sid INT,
    bid INT,
    date DATE,
    PRIMARY KEY (sid, bid),
    FOREIGN KEY (sid) REFERENCES sailors(sid),
    FOREIGN KEY (bid) REFERENCES boat(bid)
ON DELETE CASCADE
);
-----------------------------------------------------------------------------------------------------------------------

--Insertion

-- Insert into SAILORS table
INSERT INTO sailors (sid, sname, rating, age) VALUES
(1, 'John', 8, 22),
(2, 'Alice', 9, 21),
(3, 'Bob', 7, 23),
(4, 'Eve', 8, 22),
(5, 'Charlie', 9, 24),
(6, 'Grace', 9, 45),
(7, 'Daniel', 8, 42);

-- Insert into BOAT table
INSERT INTO boat (bid, bname, color) VALUES
(101, 'Sailor Delight', 'Red'),
(102, 'Sea Breeze', 'Blue'),
(103, 'Ocean Explorer', 'White'),
(104, 'Sunset Cruiser', 'Yellow'),
(105, 'Wave Rider', 'Green');

-- Insert into RESERVES table
INSERT INTO reserves (sid, bid, date) VALUES
(1, 101, '2023-10-25'),
(2, 102, '2023-10-26'),
(3, 103, '2023-10-27'),
(4, 104, '2023-10-28'),
(5, 105, '2023-10-29'),
(6, 101, '2023-11-01'),
(7, 101, '2023-11-02'),
(1, 102, '2023-11-02'),
(1, 103, '2023-11-03'),
(1, 104, '2023-11-04'),
(1, 105, '2023-11-05'),
(2, 101, '2023-11-06'),
(2, 103, '2023-11-08'),
(2, 104, '2023-11-09'),
(2, 105, '2023-11-10'),
(3, 101, '2023-11-11'),
(3, 102, '2023-11-12'),
(3, 104, '2023-11-14'),
(3, 105, '2023-11-15');

-----------------------------------------------------------------------------------------------------------------------------------------------------------

--1. Find the colors of boats reserved by Alice:

SELECT DISTINCT b.color
FROM sailors s
JOIN reserves r ON s.sid = r.sid
JOIN boat b ON r.bid = b.bid
WHERE s.sname = 'Alice';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Find all sailor IDs of sailors who have a rating of at least 8 or reserved boat 103:


SELECT DISTINCT s.sid
FROM sailors s
LEFT JOIN reserves r ON s.sid = r.sid
WHERE s.rating >= 8 OR r.bid = 103;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3. Find the names of sailors who have not reserved a boat whose name contains the string "storm". Order the names in ascending order:


SELECT DISTINCT s.sname
FROM sailors s
LEFT JOIN reserves r ON s.sid = r.sid
LEFT JOIN boat b ON r.bid = b.bid
WHERE b.bname NOT LIKE '%storm%'
   OR r.bid IS NULL
ORDER BY s.sname ASC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4. Find the names of sailors who have reserved all boats:


SELECT s.sname
FROM sailors s
WHERE NOT EXISTS (
    SELECT b.bid
    FROM boat b
    WHERE NOT EXISTS (
        SELECT r.bid
        FROM reserves r
        WHERE r.bid = b.bid AND r.sid = s.sid
    )
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5. Find the name and age of the oldest sailor:


SELECT sname, age
FROM sailors
ORDER BY age DESC
LIMIT 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--6. For each boat reserved by at least 5 sailors with age >= 40, find the boat ID and the average age of such sailors:


SELECT r.bid, AVG(s.age) AS avg_age
FROM reserves r
JOIN sailors s ON r.sid = s.sid
WHERE s.age >= 40
GROUP BY r.bid
HAVING COUNT(r.sid) >= 5;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--7. Create a view that shows the names and colors of all the boats that have been reserved by a sailor with a specific rating:


CREATE VIEW SailorRatingReservations AS
SELECT s.sname, b.color
FROM sailors s
JOIN reserves r ON s.sid = r.sid
JOIN boat b ON r.bid = b.bid;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--8. A trigger that prevents boats from being deleted if they have active reservations:
DELIMITER //

CREATE TRIGGER PreventBoatDeletion
BEFORE DELETE ON boat
FOR EACH ROW
BEGIN
    DECLARE reservation_count INT;

    SELECT COUNT(*)
    INTO reservation_count
    FROM reserves
    WHERE bid = OLD.bid;

    IF reservation_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete. Boat has active reservations.';
    END IF;
END;
//
DELIMITER ;
-----------------------------------------------------------------------------------------------------------------------------------------------------------

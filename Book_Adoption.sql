
CREATE DATABASE bookadoption;
use bookadoption;

CREATE TABLE STUDENT (
    regno VARCHAR(20) PRIMARY KEY,
    name VARCHAR(50),
    major VARCHAR(50),
    bdate DATE
);

CREATE TABLE COURSE (
    course_no INT PRIMARY KEY,
    cname VARCHAR(50),
    dept VARCHAR(50)
);

CREATE TABLE ENROLL (
    regno VARCHAR(20),
    course_no INT,
    sem INT,
    marks INT,
    PRIMARY KEY (regno, course_no, sem),
    FOREIGN KEY (regno) REFERENCES STUDENT(regno),
    FOREIGN KEY (course_no) REFERENCES COURSE(course_no)
);

CREATE TABLE BOOK_ADOPTION (
    course_no INT,
    sem INT,
    book_ISBN INT,
    PRIMARY KEY (course_no, sem, book_ISBN),
    FOREIGN KEY (course_no) REFERENCES COURSE(course_no),
    FOREIGN KEY (book_ISBN) REFERENCES TEXT(book_ISBN)
);

CREATE TABLE TEXT (
    book_ISBN INT PRIMARY KEY,
    book_title VARCHAR(100),
    publisher VARCHAR(100),
    author VARCHAR(100)
);

INSERT INTO STUDENT (regno, name, major, bdate) VALUES
('IND014', 'Aditi Sharma', 'Computer Science', '1998-04-02'),
('IND015', 'Arun Kapoor', 'Information Technology', '1997-09-15'),
('IND016', 'Neha Verma', 'Electrical Engineering', '1999-01-10'),
('IND017', 'Rahul Das', 'Computer Science', '1996-06-25'),
('IND018', 'Preeti Patel', 'Information Technology', '1998-11-12'),
('IND019', 'Karan Singh', 'Electrical Engineering', '1997-03-20'),
('IND020', 'Ananya Mehta', 'Computer Science', '1999-08-08'),
('IND021', 'Rajat Verma', 'Information Technology', '1996-02-18'),
('IND022', 'Sneha Kapoor', 'Electrical Engineering', '1998-07-14'),
('IND023', 'Sachin Sharma', 'Computer Science', '1997-12-22');

INSERT INTO COURSE (course_no, cname, dept) VALUES
(107, 'Computer Networks', 'Computer Science'),
(108, 'Software Engineering', 'Information Technology'),
(109, 'Power Systems', 'Electrical Engineering');

INSERT INTO ENROLL (regno, course_no, sem, marks) VALUES
('IND014', 107, 1, 86),
('IND015', 108, 1, 79),
('IND016', 109, 1, 91),
('IND017', 107, 1, 80),
('IND018', 108, 1, 88),
('IND019', 109, 1, 92),
('IND020', 107, 1, 85),
('IND021', 108, 1, 90),
('IND022', 109, 1, 83),
('IND023', 107, 1, 89);

INSERT INTO TEXT (book_ISBN, book_title, publisher, author) VALUES
(1007, 'Computer Networking: A Top-Down Approach', 'Pearson', 'James F. Kurose'),
(1008, 'Clean Code: A Handbook of Agile Software Craftsmanship', 'Prentice Hall', 'Robert C. Martin'),
(1009, 'Electric Power Systems: A Conceptual Introduction', 'Wiley', 'Alexandre Nassif');

INSERT INTO BOOK_ADOPTION (course_no, sem, book_ISBN) VALUES
(107, 1, 1007),
(108, 1, 1008),
(109, 1, 1009);

--1. Demonstrate how you add a new text book to the database and make this book be adopted by some department.--

-- Inserting data into TEXT table for the new textbook--

INSERT INTO TEXT (book_ISBN, book_title, publisher, author) VALUES
(1010, 'New Database Technologies', 'McGraw-Hill', 'John Smith');

-- Inserting data into the BOOK_ADOPTION table for the new textbook--
INSERT INTO BOOK_ADOPTION (course_no, sem, book_ISBN) VALUES
(107, 2, 1010); 
-- Assuming you want to adopt it for the Computer Networks course in semester 2--


--2. Produce a list of textbooks for 'CS' department courses that use more than two books--


SELECT C.course_no, BA.book_ISBN, T.book_title
FROM BOOK_ADOPTION BA
JOIN COURSE C ON BA.course_no = C.course_no
JOIN TEXT T ON BA.book_ISBN = T.book_ISBN
WHERE C.dept = 'Computer Science'
GROUP BY C.course_no, BA.book_ISBN, T.book_title
HAVING COUNT(BA.book_ISBN) > 2
ORDER BY T.book_title;


--3. List departments that have all their adopted books published by a specific publisher--


SELECT C.dept
FROM COURSE C
WHERE NOT EXISTS (
    SELECT * 
    FROM BOOK_ADOPTION BA
    JOIN TEXT T ON BA.book_ISBN = T.book_ISBN
    WHERE BA.course_no = C.course_no
    AND T.publisher <> 'McGraw-Hill'  -- Specify the publisher you are interested in
);

--4. List the students who have scored the maximum marks in the 'DBMS' course--


SELECT E.regno, S.name, E.marks
FROM ENROLL E
JOIN STUDENT S ON E.regno = S.regno
WHERE E.course_no = (SELECT course_no FROM COURSE WHERE cname = 'DBMS')
ORDER BY E.marks DESC
LIMIT 1;


--5. Create a view to display all courses opted by a student along with marks obtained--

CREATE VIEW StudentCourses AS
SELECT E.regno, E.course_no, C.cname, E.marks
FROM ENROLL E
JOIN COURSE C ON E.course_no = C.course_no;


--6. Create a trigger to prevent a student from enrolling in a course if the marks prerequisite is less than 40--


-- Assuming PrereqTable structure: (course_no INT PRIMARY KEY, prereq_marks INT)

DELIMITER //

CREATE TRIGGER PreventEnroll
BEFORE INSERT ON ENROLL
FOR EACH ROW
BEGIN
    DECLARE prereq_marks INT;

    -- Replace 'PrereqTable' with the actual name of your prerequisite table
    SELECT prereq_marks
    INTO prereq_marks
    FROM PrereqTable
    WHERE course_no = NEW.course_no;

    IF NEW.marks < prereq_marks THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot enroll, marks prerequisite not met';
    END IF;
END;

//

DELIMITER ;

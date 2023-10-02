create database ZDB;
use ZDB;

create table student(
sid int primary key,
name varchar(50),
branch varchar(5),
sem int,
address varchar(50),
phone bigint unique,
email varchar(50) unique
);

insert into student(sid,name,branch,sem,address,phone,email
)values
(1, 'zaid', 'cse', 5, 'kalyanigir', 9456123456, 'zaidhussain@gmail.com'),
(2, 'varun', 'mece', 6, 'kuvempunagar', 9356123456, 'varun@gmail.com'),
(3, 'bean', 'eee', 7, 'london', 9466123456, 'bean@gmail.com'),
(4,'ameen','cse',5,'kuvempunagar',9998870123,'ameena@gmail.com');


update student SET phone = 9466123455 where sid = 3;

select * from student;

select * from student where branch = 'cse';

select * from student where branch = 'cse' AND address = 'kuvempunagar';
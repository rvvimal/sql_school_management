create database school_management;  use school_management;
create table school(
id int primary key auto_increment ,
a_name varchar(250) NOT NULL,
address varchar(250),
contact bigint
);

create table student(
id int primary key auto_increment,
first_name varchar(250) NOT NULL,
last_name varchar(250),
email_id varchar(210),
contact bigint,
enrollment_date date,
school_id int,
FOREIGN KEY (school_id) REFERENCES school(id)
);


create table tutor(
id int primary key auto_increment,
first_name varchar(250) NOT NULL,
last_name varchar(250),
email_id varchar(210),
contact bigint,
school_id int,
FOREIGN KEY (school_id) REFERENCES school(id)
);


create table course (
id int primary key auto_increment,
a_name varchar(250) NOT NULL
);


create table tutor_course (
id int primary key auto_increment,
tutor_id int,
course_id int,
FOREIGN KEY (tutor_id) REFERENCES tutor(id),
FOREIGN KEY (course_id) REFERENCES course(id)
);


create table student_course (
id int primary key auto_increment,
student_id int,
student_school_id int,
course_id int,
FOREIGN KEY (student_id) REFERENCES student(id),
FOREIGN KEY (student_school_id) REFERENCES school(id),
FOREIGN KEY (course_id) REFERENCES course(id)
);



create table fee_payment (
id int primary key auto_increment,
a_date date,
fee_amount double,
a_status varchar(250),
student_id int,
FOREIGN KEY (student_id) REFERENCES student(id)
);

create table tutor_salary (
id int primary key auto_increment,
payment_moth varchar(250),
salary_paid boolean,
salary_amount double,
tutor_id int,
FOREIGN KEY (tutor_id) REFERENCES tutor(id)
);



/*.Select student and teacher details belonging to 1 school with pagination. (Why pagination)*/
SELECT school.id,school.a_name,
tutor.id,tutor.first_name,tutor.last_name,
student.id,student.first_name,student.last_name,student.enrollment_date
FROM school
JOIN tutor ON school.id=tutor.school_id
JOIN student ON school.id=student.school_id
JOIN student_course ON student.id=student_course.student_id
JOIN course ON student_course.course_id=course.id
  WHERE school.id=3308 limit 10;
  
  /*Select schools with total course counts.*/
  SELECT school.id AS school_id,school.a_name AS school_name,COUNT( student_course.course_id) AS total_courses
FROM school
JOIN student ON school.id = student.school_id
JOIN student_course ON student.id = student_course.student_id
GROUP BY school.id, school.a_name;

/*Select tutors from 1 school with a salary > 20000.*/
SELECT tutor.id AS tutor_id,tutor.first_name AS tutor_first_name,tutor.last_name AS tutor_last_name,tutor_salary.salary_amount
FROM tutor
JOIN tutor_salary ON tutor.id = tutor_salary.tutor_id
WHERE tutor.school_id = 1930 AND tutor_salary.salary_amount < 20000;

/*Select min and maximum cost courses offered by all the schools.*/
SELECT school.id AS school_id,school.a_name AS school_name,fee_payment,
MIN(course.fee_amount) AS minimum_course_cost,MAX(course.fee_amount) AS maximum_course_cost
FROM school
JOIN student_course ON school.id = student_course.student_school_id
JOIN course ON student_course.course_id = course.id
GROUP BY school.id, school.a_name;


SELECT 
    school.id AS school_id,
    school.a_name AS school_name,
    MIN(fee_payment.fee_amount) AS minimum_fee,
    MAX(fee_payment.fee_amount) AS maximum_fee
FROM 
    school
JOIN 
    student_course ON school.id = student_course.student_school_id
JOIN 
    fee_payment ON student_course.student_id = fee_payment.student_id
GROUP BY 
    school.id, school.a_name;

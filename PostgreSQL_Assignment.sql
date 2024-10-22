-- Active: 1729336898502@@127.0.0.1@5432@university_db

-- Creating a "students" table:
CREATE TABLE students(
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    age INTEGER,
    email VARCHAR(50) NOT NULL UNIQUE,
    frontend_mark INTEGER,
    backend_mark INTEGER,
    status VARCHAR(10)
);

-- Creating a "courses" table:
CREATE TABLE courses(
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    credit INTEGER NOT NULL
);

-- Creating an "enrollment" table:
CREATE TABLE enrollment(
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL, 
    course_id INTEGER NOT NULL,
    CONSTRAINT fk_student_id_in_enrollment FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_course_id_in_enrollment FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Inserting data into students table:
INSERT INTO students (student_name, age, email, frontend_mark, backend_mark) VALUES
('Sameer', 21, 'sameer@example.com', 48, 60),
('Zoya', 23, 'zoya@example.com', 52, 58),
('Nabil', 22, 'nabil@example.com', 37, 46),
('Rafi', 24, 'rafi@example.com', 41, 40),
('Sophia', 22, 'sophia@example.com', 50, 52),
('Hasan', 23, 'hasan@gmail.com', 43, 39);

--Inserting data into courses table:
INSERT INTO courses (course_name, credits) VALUES
('Next.js', 3),
('React.js', 4),
('Databases', 3),
('Prisma', 3);

--Inserting data into enrollment table:
INSERT INTO enrollment(student_id, course_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 2);

-- Query 1: Inserting data into students table
INSERT INTO students (student_name, age, email, frontend_mark, backend_mark, status) VALUES
('Monishat Baishnab', 21, 'monishat@gmail.com', 30, 56, null);

-- Query 2: Retrieve the names of all students who are enrolled in the course titled 'Next.js' 
SELECT student_name FROM enrollment
    JOIN students USING(student_id)
        JOIN courses USING(course_id)
            WHERE course_name = 'Next.js';

-- Query 3: Update the status of the student with the highest total (frontend_mark + backend_mark) to 'Awarded'
UPDATE students SET status = 'Awarded' 
    WHERE (frontend_mark + backend_mark) = (SELECT max(frontend_mark + backend_mark) as total_mark FROM students);

-- Query 4: Delete all courses that have no students enrolled
DELETE FROM courses 
    WHERE course_id IN (
        SELECT course_id FROM enrollment
            RIGHT JOIN courses USING(course_id)
                WHERE student_id is NULL
    );

-- Query 5: Retrieve the names of students using a limit of 2, starting from the 3rd student.
SELECT student_name FROM students
    LIMIT 2 OFFSET 2;

-- Query 6: Retrieve the course names and the number of students enrolled in each course
SELECT course_name, count(*) as students_enrolled FROM enrollment
    RIGHT JOIN courses USING(course_id) 
        GROUP BY course_name
            ORDER BY course_name;

-- Query 7: Calculate and display the average age of all students
SELECT avg(age) as average_age FROM students;

-- Query 8: Retrieve the names of students whose email addresses contain 'example.com'
SELECT student_name FROM students WHERE email LIKE '%example.com%';

/*
Question 1: What is PostgreSQL?
Answer: Postgres SQL is an open source, highly scalable, secure, relational database management system. Which is basically built using Structured Query Language (SQL).

Question 2: What is the purpose of a database schema in PostgreSQL?
Answer: A database schema in PostgreSQL is a logical container. It is a combination of database objects such as tables, views, functions, data types, stored procedures, indexes, etc. A database can have many schemas, but a schema can contain only one database.

Question 3: Explain the primary key and foreign key concepts in PostgreSQL.
Answer: In Postgres SQL, a primary key is an entity that can be used to uniquely identify a row. Primary is never duplicated. When the primary key of a table is placed in another table, it is called the foreign key of that table.

Question 4: What is the difference between the VARCHAR and CHAR data types?
Answer: Both VARCHAR and CHAR store text in PostgreSQL, but they work a bit differently:
VARCHAR: The length can vary. It only uses as much space as the text needs.
CHAR: The length is fixed. If the text is shorter, extra spaces are added to fill the length.
Use VARCHAR when the text length can change (like names or emails). Use CHAR for data with a set length (like country codes or product IDs).

Question 5: Explain the purpose of the WHERE clause in a SELECT statement.
Answer: SELECT clause is used in PostgreSQL when data needs to be retrieved from database. The WHERE clause is used to add various conditions to the SELECT clause.

Question 6: What are the LIMIT and OFFSET clauses used for?
Answer: LIMIT and OFFSET are used in Postgres SQL to control what number of data the query will return and from what position it will return. It is used for pagination.

Question 7: How can you perform data modification using UPDATE statements?
Answer: In PostgreSQL, data modification requires some syntax. For example: 
UPDATE users SET email = 'newemail@example.com' WHERE id = 1;
Here it is said using the UPDATE key word to update the email from the users table whose ID is 1.

Question 8: What is the significance of the JOIN operation, and how does it work in PostgreSQL?
Answer: In PostgreSQL, joins are used to combine data from two or more tables based on a related column. Although joins often use a primary key-foreign key relationship, it is not mandatory; any matching columns can be used. For example:
SELECT course_name FROM enrollment JOIN courses USING(course_id);
Here the Enrollment and Courses tables are joined using the course ID. There are 6 types of joins in Postgres: INNER JOIN LEFT JOIN (LEFT OUTER JOIN), RIGHT JOIN (RIGHT OUTER JOIN), FULL JOIN (FULL OUTER JOIN), CROSS JOIN, SELF JOIN.

Question 9: Explain the GROUP BY clause and its role in aggregation operations.
Answer: GROUP BY clause is used to group rows containing similar data. With this, various operations can be performed using the aggregate function. It's allows you to perform calculations on each group, like finding the total sales for each product or counting the number of orders for each customer.

Question 10: Explain the concept of a PostgreSQL view and how it differs from a table.
Answer: A view in PostgreSQL is a virtual table created from a SQL query that lets users see specific data without storing it separately. It helps simplify complex queries and can enhance security by hiding the original tables. For example, a view can show only active users from a user table, keeping other data hidden.
*/
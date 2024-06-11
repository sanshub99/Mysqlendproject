-- Create the database
CREATE DATABASE IF NOT EXISTS library;

-- Use the library database
USE library;


-- Create the Branch table
CREATE TABLE Branch (
    Branch_no INT PRIMARY KEY,
    Manager_Id INT,
    Branch_address VARCHAR(255),
    Contact_no VARCHAR(15)
);

DESC Branch;

-- Create the Employee table
CREATE TABLE Employee (
    Emp_Id INT PRIMARY KEY,
    Emp_name VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10, 2),
    Branch_no INT,
    FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no)
);

DESC Employee;


-- Create the Books table
CREATE TABLE Books (
    ISBN VARCHAR(13) PRIMARY KEY,
    Book_title VARCHAR(255),
    Category VARCHAR(100),
    Rental_Price DECIMAL(10, 2),
    Status VARCHAR(3),  -- 'yes' for available, 'no' for not available
    Author VARCHAR(100),
    Publisher VARCHAR(100)
);
DESC Books;

-- Create the Customer table
CREATE TABLE Customer (
    Customer_Id INT PRIMARY KEY,
    Customer_name VARCHAR(100),
    Customer_address VARCHAR(255),
    Reg_date DATE
);
DESC Customer;

-- Create the IssueStatus table
CREATE TABLE IssueStatus (
    Issue_Id INT PRIMARY KEY,
    Issued_cust INT,
    Issued_book_name VARCHAR(255),
    Issue_date DATE,
    Isbn_book VARCHAR(13),
    FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);
DESC IssueStatus;

-- Create the ReturnStatus table
CREATE TABLE ReturnStatus (
    Return_Id INT PRIMARY KEY,
    Return_cust INT,
    Return_book_name VARCHAR(255),
    Return_date DATE,
    Isbn_book2 VARCHAR(13),
    FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);

DESC ReturnStatus;

-- Inserting data into the Branch table
INSERT INTO Branch (Branch_no, Manager_Id, Branch_address, Contact_no)
VALUES
(1, 101, '123 Main St, City A', '1234567890'),
(2, 102, '456 Elm St, City B', '2345678901'),
(3, 103, '789 Oak St, City C', '3456789012');
SELECT * FROM Branch;

-- Inserting data into the Employee table
INSERT INTO Employee (Emp_Id, Emp_name, Position, Salary, Branch_no)
VALUES
(1, 'Alice Smith', 'Manager', 60000, 1),
(2, 'Bob Johnson', 'Clerk', 40000, 1),
(3, 'Charlie Davis', 'Assistant', 35000, 2),
(4, 'Diana Ross', 'Manager', 65000, 2),
(5, 'Eve Lewis', 'Clerk', 42000, 3),
(6, 'Frank Clark', 'Assistant', 38000, 3),
(7, 'Grace Walker', 'Clerk', 55000, 1),
(8, 'Hank Green', 'Manager', 70000, 3);
SELECT * FROM Employee;

-- Inserting data into the Books table
INSERT INTO Books (ISBN, Book_title, Category, Rental_Price, Status, Author, Publisher)
VALUES
('122', 'Introduction to Algorithms', 'Technology', 15.00, 'yes', 'Thomas H. Cormen', 'MIT Press'),
('133', 'History of Ancient Rome', 'History', 10.00, 'no', 'Mary Beard', 'Random House'),
('144', 'The C Programming Language', 'Technology', 20.00, 'yes', 'Brian W. Kernighan', 'Prentice Hall'),
('155', 'Artificial Intelligence: A Modern Approach', 'Technology', 25.00, 'yes', 'Stuart Russell', 'Pearson'),
('166', 'Guns, Germs, and Steel', 'History', 12.00, 'no', 'Jared Diamond', 'W. W. Norton & Company');
SELECT * FROM Books;


-- Inserting data into the Customer table
INSERT INTO Customer (Customer_Id, Customer_name, Customer_address, Reg_date)
VALUES
(1, 'John Doe', '111 Maple St, City A', '2021-05-15'),
(2, 'Jane Smith', '222 Pine St, City B', '2022-06-20'),
(3, 'Tom Brown', '333 Birch St, City C', '2023-03-10'),
(4, 'Lucy Black', '444 Cedar St, City A', '2021-12-01');
SELECT * FROM Customer;


-- Inserting data into the IssueStatus table
INSERT INTO IssueStatus (Issue_Id, Issued_cust, Issued_book_name, Issue_date, Isbn_book)
VALUES
(1, 1, 'History of Ancient Rome', '2023-06-15', '133'),
(2, 2, 'Guns, Germs, and Steel', '2023-06-25', '166'),
(3, 3, 'Introduction to Algorithms', '2023-06-05', '122');
SELECT * FROM IssueStatus;


-- Inserting data into the ReturnStatus table
INSERT INTO ReturnStatus (Return_Id, Return_cust, Return_book_name, Return_date, Isbn_book2)
VALUES
(1, 1, 'History of Ancient Rome', '2023-07-10', '133'),
(2, 2, 'Guns, Germs, and Steel', '2023-07-20', '166');
SELECT * FROM ReturnStatus;


SHOW TABLES;


-- 1. Retrieve the book title, category, and rental price of all available books.
select Book_title,Category ,Rental_Price from Books where status='yes';

-- 2. List the employee names and their respective salaries in descending order of salary.
select Emp_name ,Salary from Employee order by Salary desc;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books.
select C.Customer_name, I.Issued_book_name from Customer C right join IssueStatus I on C.Customer_id = I.Issued_cust;

-- 4. Display the total count of books in each category.
select Category, COUNT(ISBN) FROM Books  group by Category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000.
select Emp_name,Position from Employee where salary>50000;

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
select C.Customer_name  from customer C left join  IssueStatus I on C.Customer_id= I.issued_cust where Reg_date<'2022-01-01' and issued_cust is null ;

-- 7. Display the branch numbers and the total count of employees in each branch.
select  B.Branch_no,B.Branch_address,count(E.Emp_id) from  Branch B left join Employee E on B.Branch_no=E.Branch_no group by Branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
select C.Customer_name from customer C left join  IssueStatus I on C.Customer_id= I.issued_cust where month(I.Issue_date)='06' and year(I.Issue_date)='2023';

-- 9. Retrieve book_title from book table containing history.
select Book_title from Books where Category='history';

-- 10.Retrieve the branch numbers along with the count of employees for branches having more than 2 employees
SELECT Branch_no, COUNT(*) AS Total_Employees
FROM Employee
GROUP BY Branch_no
HAVING COUNT(*) > 2;
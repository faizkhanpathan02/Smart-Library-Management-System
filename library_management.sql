/*
    Project: Smart Library Management System
    Database: MySQL
    Author: [faiz khan]
*/

-- ==========================================
-- 0. SETUP DATABASE AND SCHEMA
-- ==========================================

DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- 1. Create Authors Table
CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- 2. Create Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    category VARCHAR(50),
    isbn VARCHAR(20) UNIQUE,
    published_date DATE,
    price DECIMAL(10, 2),
    available_copies INT DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE SET NULL
);

-- 3. Create Members Table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    membership_date DATE
);

-- 4. Create Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    fine_amount DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
);

-- ==========================================
-- SAMPLE DATA INSERTION (Seeding the DB)
-- ==========================================

INSERT INTO Authors (name, email) VALUES 
('J.K. Rowling', 'jk@example.com'),
('George Orwell', 'george@example.com'),
('Isaac Asimov', 'isaac@example.com'),
('F. Scott Fitzgerald', NULL), -- Null email for testing Task 10
('Stephen Hawking', 'stephen@example.com');

INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies) VALUES 
('Harry Potter', 1, 'Fantasy', '978-1', '2001-06-26', 450.00, 5),
('1984', 2, 'Dystopian', '978-2', '1949-06-08', 300.00, 3),
('Foundation', 3, 'Science', '978-3', '1951-05-01', 550.00, 4),
('The Great Gatsby', 4, 'Classic', '978-4', '1925-04-10', 250.00, 2),
('A Brief History of Time', 5, 'Science', '978-5', '1988-03-01', 400.00, 0), -- 0 copies for testing
('Modern Physics', 5, 'Science', '978-6', '2021-01-15', 600.00, 10);

INSERT INTO Members (name, email, phone_number, membership_date) VALUES 
('Alice Johnson', 'alice@test.com', '1234567890', '2021-01-10'),
('Bob Smith', 'bob@test.com', '0987654321', '2023-05-20'),
('Charlie Brown', 'charlie@test.com', '1122334455', '2019-08-15'),
('Diana Prince', 'diana@test.com', NULL, '2024-02-01'), -- Joined after 2022
('Evan Ghost', 'evan@test.com', '5555555555', '2020-01-01'); -- Inactive member

INSERT INTO Transactions (member_id, book_id, borrow_date, return_date, fine_amount) VALUES 
(1, 1, '2023-01-01', '2023-01-10', 0.00),
(1, 2, '2023-02-01', '2023-02-15', 5.00), -- Late
(2, 3, '2023-06-01', NULL, 0.00), -- Not returned yet
(3, 1, '2023-01-05', '2023-01-12', 0.00),
(3, 4, '2023-03-10', '2023-03-20', 0.00),
(1, 3, '2023-04-01', '2023-04-10', 0.00);


-- ==========================================
-- TASKS & FUNCTIONALITIES
-- ==========================================

-- ------------------------------------------
-- 1. Implement CRUD Operations
-- ------------------------------------------

-- A. Insert new book (Example)
INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies) 
VALUES ('The Hobbit', 1, 'Fantasy', '978-7', '1937-09-21', 350.00, 5);

-- B. Update book availability (Decrease copy when borrowed)
UPDATE Books 
SET available_copies = available_copies - 1 
WHERE book_id = 1 AND available_copies > 0;

-- C. Delete members who haven't borrowed in the last year (Assuming 'current' date is 2024-01-01 for logic)
DELETE FROM Members 
WHERE member_id NOT IN (SELECT DISTINCT member_id FROM Transactions WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR));

-- D. Retrieve all books with available copies
SELECT * FROM Books WHERE available_copies > 0;

-- ------------------------------------------
-- 2. Use SQL Clauses (WHERE, HAVING, LIMIT)
-- ------------------------------------------

-- A. Books published after 2015
SELECT * FROM Books WHERE YEAR(published_date) > 2015;

-- B. Top 5 most expensive books
SELECT * FROM Books ORDER BY price DESC LIMIT 5;

-- C. Members who joined before 2022
SELECT * FROM Members WHERE YEAR(membership_date) < 2022;

-- ------------------------------------------
-- 3. Apply SQL Operators (AND, OR, NOT)
-- ------------------------------------------

-- A. Category 'Science' AND price < 500
SELECT * FROM Books WHERE category = 'Science' AND price < 500;

-- B. Books NOT available
SELECT * FROM Books WHERE NOT available_copies > 0;

-- C. Members joined after 2020 OR borrowed > 3 books
SELECT m.member_id, m.name 
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
GROUP BY m.member_id
HAVING YEAR(m.membership_date) > 2020 OR COUNT(t.transaction_id) > 3;

-- ------------------------------------------
-- 4. Sorting & Grouping Data
-- ------------------------------------------

-- A. List books sorted by title
SELECT * FROM Books ORDER BY title ASC;

-- B. Number of books borrowed by each member
SELECT member_id, COUNT(transaction_id) as total_borrowed
FROM Transactions
GROUP BY member_id;

-- C. Group books by category and show count
SELECT category, COUNT(*) as total_books
FROM Books
GROUP BY category;

-- ------------------------------------------
-- 5. Use Aggregate Functions
-- ------------------------------------------

-- A. Total books in each category
SELECT category, SUM(available_copies) as total_copies FROM Books GROUP BY category;

-- B. Average price of books
SELECT AVG(price) as average_price FROM Books;

-- C. Identify most borrowed book
SELECT book_id, COUNT(transaction_id) as borrow_count
FROM Transactions
GROUP BY book_id
ORDER BY borrow_count DESC
LIMIT 1;

-- D. Total fines collected
SELECT SUM(fine_amount) as total_fines FROM Transactions;

-- ------------------------------------------
-- 6. Establish Relationships (Demonstrated in DDL above)
-- ------------------------------------------
-- (Keys were established in CREATE TABLE statements using FOREIGN KEY constraints)

-- ------------------------------------------
-- 7. Implement Joins
-- ------------------------------------------

-- A. Books with Author names (INNER JOIN)
SELECT b.title, a.name as author_name
FROM Books b
INNER JOIN Authors a ON b.author_id = a.author_id;

-- B. Members who borrowed books (LEFT JOIN)
SELECT m.name, b.title, t.borrow_date
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
LEFT JOIN Books b ON t.book_id = b.book_id
WHERE t.transaction_id IS NOT NULL;

-- C. Books that haven't been borrowed (RIGHT JOIN simulation for "Books not in Transactions")
-- Note: Logic implies finding books present in Books table but not in Transactions
SELECT b.title
FROM Transactions t
RIGHT JOIN Books b ON t.book_id = b.book_id
WHERE t.transaction_id IS NULL;

-- D. FULL OUTER JOIN Simulation (Members who never borrowed)
-- MySQL does not support FULL OUTER JOIN. We simulate it using LEFT JOIN... UNION... RIGHT JOIN
SELECT m.name
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
WHERE t.transaction_id IS NULL
UNION
SELECT m.name
FROM Transactions t
RIGHT JOIN Members m ON t.member_id = m.member_id
WHERE t.transaction_id IS NULL;

-- ------------------------------------------
-- 8. Use Subqueries
-- ------------------------------------------

-- A. Books borrowed by members registered after 2022
SELECT DISTINCT title 
FROM Books 
WHERE book_id IN (
    SELECT book_id 
    FROM Transactions 
    WHERE member_id IN (SELECT member_id FROM Members WHERE YEAR(membership_date) > 2022)
);

-- B. Most borrowed book using subquery (Alternative to LIMIT)
SELECT title FROM Books WHERE book_id = (
    SELECT book_id FROM Transactions GROUP BY book_id ORDER BY COUNT(*) DESC LIMIT 1
);

-- C. Members who never borrowed
SELECT name FROM Members WHERE member_id NOT IN (SELECT DISTINCT member_id FROM Transactions);

-- ------------------------------------------
-- 9. Implement Date & Time Functions
-- ------------------------------------------

-- A. Count books by publication year
SELECT YEAR(published_date) as pub_year, COUNT(*) 
FROM Books 
GROUP BY pub_year;

-- B. Difference in days (Late return calculation logic)
SELECT transaction_id, DATEDIFF(return_date, borrow_date) as days_held 
FROM Transactions 
WHERE return_date IS NOT NULL;

-- C. Format borrow_date
SELECT transaction_id, DATE_FORMAT(borrow_date, '%d-%m-%Y') as formatted_date 
FROM Transactions;

-- ------------------------------------------
-- 10. String Manipulation
-- ------------------------------------------

-- A. Titles to Uppercase
SELECT UPPER(title) FROM Books;

-- B. Trim whitespace
SELECT TRIM(name) FROM Authors;

-- C. Replace missing email
SELECT name, IFNULL(email, 'Not Provided') as email_status FROM Authors;

-- ------------------------------------------
-- 11. Implement Window Functions
-- ------------------------------------------

-- A. Rank books by borrow count
SELECT book_id, COUNT(*) as borrow_count,
RANK() OVER (ORDER BY COUNT(*) DESC) as rank_position
FROM Transactions
GROUP BY book_id;

-- B. Cumulative books borrowed per member
SELECT member_id, borrow_date,
COUNT(transaction_id) OVER (PARTITION BY member_id ORDER BY borrow_date) as cumulative_borrows
FROM Transactions;

-- C. Moving average (last 3 rows/transactions per member)
SELECT member_id, borrow_date, fine_amount,
AVG(fine_amount) OVER (PARTITION BY member_id ORDER BY borrow_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_fine
FROM Transactions;

-- ------------------------------------------
-- 12. Apply SQL CASE Expressions
-- ------------------------------------------

-- A. Membership Status
SELECT m.name,
CASE 
    WHEN m.member_id IN (SELECT member_id FROM Transactions WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)) 
    THEN 'Active'
    ELSE 'Inactive'
END as membership_status
FROM Members m;

-- B. Categorize Books
SELECT title, published_date,
CASE
    WHEN YEAR(published_date) > 2020 THEN 'New Arrival'
    WHEN YEAR(published_date) < 2000 THEN 'Classic'
    ELSE 'Regular'
END as book_age_category
FROM Books;

# Smart Library Management System

## Project Overview
This project is a relational database management system designed for a library. It is built using **MySQL** and enables librarians to manage books, authors, members, and borrowing transactions efficiently.

The system supports core functionalities such as tracking inventory, monitoring borrowed books, calculating fines, and analyzing member activity using advanced SQL techniques.

## Database Schema

The database `library_db` consists of four main tables:

1.  **Authors**: Stores author details.
    * `author_id` (PK), `name`, `email`
2.  **Books**: Stores book inventory.
    * `book_id` (PK), `title`, `author_id` (FK), `category`, `isbn`, `published_date`, `price`, `available_copies`
3.  **Members**: Stores library member information.
    * `member_id` (PK), `name`, `email`, `phone_number`, `membership_date`
4.  **Transactions**: Records borrowing and returning of books.
    * `transaction_id` (PK), `member_id` (FK), `book_id` (FK), `borrow_date`, `return_date`, `fine_amount`

## Features & SQL Techniques Used

The SQL script implements the following technical requirements:

* **CRUD Operations**: Full Create, Read, Update, Delete capabilities for books and members.
* **Data Integrity**: Usage of Primary Keys and Foreign Keys to enforce relationships.
* **Advanced Filtering**: Usage of `WHERE`, `HAVING`, `LIMIT`, `AND`, `OR`, `NOT`.
* **Aggregation**: Summarizing data using `SUM`, `AVG`, `COUNT`, `MAX`.
* **Joins**: `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and simulated `FULL OUTER JOIN` to merge data across tables.
* **Subqueries**: Nested queries for complex filtering (e.g., finding the most borrowed book).
* **Window Functions**: `RANK()`, `PARTITION BY`, and moving averages for analytical insights.
* **Date & String Functions**: manipulating timestamps and formatting text data.
* **Logic Control**: `CASE` statements to categorize books and define member status dynamically.

## How to Run

1.  Ensure you have **MySQL** installed on your machine.
2.  Clone this repository.
3.  Open your SQL client (MySQL Workbench, DBeaver, or Command Line).
4.  Run the script `library_management.sql`.
    * This script will automatically create the database, tables, insert sample dummy data, and execute the analysis queries.

## Author
[faiz khan]

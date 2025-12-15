# 📚 Library Management System - SQL Project

![ERD Diagram](ERD%20Diagram.png)

## 📋 Project Overview

**Project Title**: Library Management System  
**Database**: PostgreSQL  
**Level**: Intermediate to Advanced  
**Focus**: Database Design, CRUD Operations, Advanced Queries, Stored Procedures

This Library Management System is a comprehensive database project built with PostgreSQL that simulates real-world library operations. The system manages books, members, employees, branches, and tracks book issuance and returns with complete automation through stored procedures.

### 🎯 What This Project Does

This database solution handles the complete lifecycle of library operations:

**Core Functionality:**
- **Book Management**: Track inventory, availability, categories, authors, and rental prices across multiple library branches
- **Member Services**: Maintain member records, registration dates, addresses, and borrowing history
- **Employee Operations**: Manage staff information, positions, salaries, and branch assignments with hierarchical manager relationships
- **Issue & Return System**: Automated book checkout and return processes with real-time status updates
- **Branch Management**: Multi-branch support with individual performance tracking and manager assignments

**Advanced Features:**
- **Overdue Tracking**: Automatically identifies books overdue beyond 30 days with member notifications
- **Revenue Analytics**: Calculates rental income by category, branch, and time period
- **Performance Reporting**: Generates comprehensive branch performance metrics including books issued, returned, and revenue generated
- **Active Member Analysis**: Identifies and tracks members with recent borrowing activity
- **Employee Performance**: Ranks employees by number of transactions processed

### 💡 Why This Project Matters

This project demonstrates professional-level database engineering skills applicable to real-world scenarios:

1. **Normalized Database Design**: Implements proper 3NF normalization with clear entity relationships, foreign key constraints, and data integrity rules

2. **Business Logic Automation**: Uses stored procedures to encapsulate complex business rules, ensuring data consistency and reducing application-side code

3. **Scalable Architecture**: Designed to handle multiple branches, thousands of books, and concurrent transactions efficiently

4. **Data Analytics Ready**: Structured to support business intelligence queries, reporting dashboards, and decision-making insights

5. **Production-Ready Code**: Includes error handling, transaction management, and proper indexing strategies for optimal performance

### 🔍 Technical Highlights

- **18+ Complex SQL Queries**: From basic CRUD to advanced multi-table joins, subqueries, and window functions
- **2 Custom Stored Procedures**: Automates book issuance and return workflows with built-in validation
- **CTAS Implementation**: Creates summary tables for faster reporting and analytics
- **LEFT JOIN Mastery**: Handles unreturned books and missing data scenarios elegantly
- **Aggregate Functions**: Sophisticated use of COUNT, SUM, AVG with GROUP BY and HAVING clauses
- **Date Arithmetic**: Calculates overdue periods, registration windows, and activity timeframes

### 📚 Perfect For

- **Students**: Learning database design, SQL, and PL/pgSQL programming
- **Developers**: Portfolio project demonstrating backend database skills
- **Data Analysts**: Understanding data modeling and query optimization
- **Interviewers**: Assessing SQL proficiency and problem-solving abilities

This project bridges theoretical database concepts with practical implementation, making it an excellent showcase of SQL expertise and database management capabilities.

---

## 🎯 Objectives

1. **Database Architecture**: Design and implement a normalized database schema with proper relationships
2. **CRUD Mastery**: Perform Create, Read, Update, and Delete operations efficiently
3. **Advanced Queries**: Develop complex queries using JOINs, subqueries, and aggregations
4. **Automation**: Implement stored procedures for business logic
5. **Analytics**: Generate performance reports and insights using CTAS
6. **Data Integrity**: Maintain referential integrity and data consistency

---

## 🗂️ Database Schema

### Entity Relationship Diagram (ERD)
![ERD](library_erd.png)

### Tables Structure

**1. branch**
- `branch_id` (VARCHAR, PRIMARY KEY)
- `manager_id` (VARCHAR)
- `branch_address` (VARCHAR)
- `contact_no` (VARCHAR)

**2. employees**
- `emp_id` (VARCHAR, PRIMARY KEY)
- `emp_name` (VARCHAR)
- `position` (VARCHAR)
- `salary` (DECIMAL)
- `branch_id` (VARCHAR, FOREIGN KEY)

**3. members**
- `member_id` (VARCHAR, PRIMARY KEY)
- `member_name` (VARCHAR)
- `member_address` (VARCHAR)
- `reg_date` (DATE)

**4. books**
- `isbn` (VARCHAR, PRIMARY KEY)
- `book_title` (VARCHAR)
- `category` (VARCHAR)
- `rental_price` (DECIMAL)
- `status` (VARCHAR)
- `author` (VARCHAR)
- `publisher` (VARCHAR)

**5. issued_status**
- `issued_id` (VARCHAR, PRIMARY KEY)
- `issued_member_id` (VARCHAR, FOREIGN KEY)
- `issued_book_name` (VARCHAR)
- `issued_date` (DATE)
- `issued_book_isbn` (VARCHAR, FOREIGN KEY)
- `issued_emp_id` (VARCHAR, FOREIGN KEY)

**6. returned_status**
- `return_id` (VARCHAR, PRIMARY KEY)
- `issued_id` (VARCHAR)
- `return_date` (DATE)
- `book_quality` (VARCHAR)

---

## 💻 Project Tasks & Solutions

### **Task 1: Create a New Book Record**
📌 **Question**: Insert a new book into the database with the following details:
- ISBN: '978-1-60129-456-2'
- Title: 'To Kill a Mockingbird'
- Category: 'Classic'

```sql
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES 
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

---

### **Task 2: Update Existing Member Address**
📌 **Question**: Update the address of a member with member_id 'C101' to '125 Main St.'

```sql
UPDATE members
SET member_address = '125 Main St.'
WHERE member_id = 'C101';
```

---

### **Task 3: Delete a Record from Issued Status**
📌 **Question**: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

---

### **Task 4: Retrieve All Books Issued by Specific Employee**
📌 **Question**: Select all books issued by the employee with emp_id = 'E101'.

```sql
SELECT issued_book_name
FROM issued_status 
WHERE issued_emp_id = 'E101';
```

---

### **Task 5: List Members Who Issued More Than One Book**
📌 **Question**: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT 
    issued_member_id,
    COUNT(*) AS no_of_books_assigned
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(*) > 1;
```

---

### **Task 6: CTAS - Create Summary Tables**
📌 **Question**: Create a new table that summarizes the total number of books issued for each book title.

```sql
CREATE TABLE book_cnts AS 
SELECT 
    b.isbn, 
    b.book_title,
    COUNT(*) AS total_book_issued
FROM books AS b 
JOIN issued_status AS ist
    ON b.isbn = ist.issued_book_isbn
GROUP BY b.isbn, b.book_title;
```

---

### **Task 7: Retrieve Books by Category**
📌 **Question**: Retrieve all books in the 'Classic' category.

```sql
SELECT * 
FROM books
WHERE category = 'Classic';
```

---

### **Task 8: Find Total Rental Income by Category**
📌 **Question**: Calculate the total rental income generated by each book category.

```sql
SELECT 
    b.category, 
    SUM(b.rental_price) AS total_rental_income
FROM books b
JOIN issued_status ist 
    ON b.isbn = ist.issued_book_isbn
GROUP BY b.category;
```

---

### **Task 9: List Members Registered in Last 180 Days**
📌 **Question**: Find all members who registered in the last 180 days.

```sql
SELECT *
FROM members
WHERE reg_date > CURRENT_DATE - INTERVAL '180 days';
```

---

### **Task 10: List Employees with Branch Manager Details**
📌 **Question**: Display employees along with their branch manager's name and branch details.

```sql
SELECT 
    emp.*,
    e2.emp_name AS manager
FROM employees AS emp
JOIN branch AS b 
    ON b.branch_id = emp.branch_id
JOIN employees AS e2
    ON b.manager_id = e2.emp_id;
```

---

### **Task 11: Create Table of High-Value Books**
📌 **Question**: Create a table containing books with rental price above $7.

```sql
CREATE TABLE books_price_greater_than_seven AS
SELECT *
FROM books
WHERE rental_price > 7;
```

---

### **Task 12: Retrieve Unreturned Books**
📌 **Question**: Find all books that have been issued but not yet returned.

```sql
SELECT DISTINCT ist.issued_book_name
FROM issued_status AS ist
LEFT JOIN returned_status AS rst
    ON ist.issued_id = rst.issued_id
WHERE rst.return_id IS NULL;
```

---

### **Task 13: Identify Overdue Books**
📌 **Question**: Identify members with overdue books (>30 days). Display member_id, member name, book title, issue date, and days overdue.

```sql
SELECT *
FROM (
    SELECT 
        m.member_id,
        m.member_name,
        b.book_title,
        ist.issued_date,
        rst.return_date,
        CURRENT_DATE - ist.issued_date AS overdue_days
    FROM issued_status AS ist 
    JOIN members AS m
        ON ist.issued_member_id = m.member_id
    JOIN books AS b
        ON ist.issued_book_isbn = b.isbn
    LEFT JOIN returned_status AS rst
        ON ist.issued_id = rst.issued_id
    WHERE rst.return_date IS NULL
) AS overdue_info
WHERE overdue_days > 30;
```

---

### **Task 14: Update Book Status on Return (Stored Procedure)**
📌 **Question**: Create a stored procedure to update book status to 'yes' when returned.

```sql
CREATE OR REPLACE PROCEDURE add_return_records(
    p_return_id VARCHAR(10), 
    p_issued_id VARCHAR(10), 
    p_book_quality VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_isbn VARCHAR(20);
    v_title VARCHAR(70);
BEGIN
    -- Insert data into returned_status
    INSERT INTO returned_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    -- Fetch ISBN and title
    SELECT issued_book_isbn, issued_book_name 
    INTO v_isbn, v_title
    FROM issued_status 
    WHERE issued_id = p_issued_id;
    
    -- Update book status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Acknowledgment
    RAISE NOTICE 'Thank you for returning the book: %', v_title;
END;
$$;

-- Example usage:
-- CALL add_return_records('RS001', 'IS001', 'Good');
```

---

### **Task 15: Branch Performance Report**
📌 **Question**: Generate a performance report showing books issued, returned, and revenue by branch.

```sql
CREATE TABLE branch_reports AS 
SELECT 
    b.branch_id, 
    b.branch_address, 
    COUNT(ist.issued_id) AS total_books_issued,
    SUM(bk.rental_price) AS total_rental_revenue,
    COUNT(rst.return_id) AS total_books_returned
FROM branch AS b
JOIN employees AS emp
    ON b.branch_id = emp.branch_id
JOIN issued_status AS ist
    ON ist.issued_emp_id = emp.emp_id
JOIN books AS bk 
    ON ist.issued_book_isbn = bk.isbn
LEFT JOIN returned_status AS rst 
    ON rst.issued_id = ist.issued_id
GROUP BY b.branch_id, b.branch_address
ORDER BY b.branch_id;
```

---

### **Task 16: CTAS - Active Members**
📌 **Question**: Create a table of active members who issued books in the last 2 months.

```sql
CREATE TABLE active_members AS 
SELECT * 
FROM members 
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status 
    WHERE issued_date >= CURRENT_DATE - INTERVAL '2 months'
);
```

---

### **Task 17: Top 3 Employees by Book Issues**
📌 **Question**: Find the top 3 employees who processed the most book issues with their branch details.

```sql
SELECT 
    emp.emp_id,
    emp.emp_name,
    ist.total_book_issues,
    b.branch_id,
    b.branch_address
FROM employees AS emp 
JOIN (
    SELECT 
        issued_emp_id,
        COUNT(issued_id) AS total_book_issues
    FROM issued_status 
    GROUP BY issued_emp_id
    ORDER BY COUNT(issued_id) DESC 
    LIMIT 3 
) AS ist
    ON emp.emp_id = ist.issued_emp_id
JOIN branch AS b 
    ON b.branch_id = emp.branch_id;
```

---

### **Task 18: Book Issue Management (Stored Procedure)**
📌 **Question**: Create a stored procedure to issue a book, checking availability first.

```sql
CREATE OR REPLACE PROCEDURE issue_book(
    p_issued_id VARCHAR(10), 
    p_issued_member_id VARCHAR(10), 
    p_issued_book_isbn VARCHAR(25), 
    p_issued_emp_id VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE 
    v_status VARCHAR(10);
BEGIN
    -- Check if book is available
    SELECT status 
    INTO v_status 
    FROM books 
    WHERE isbn = p_issued_book_isbn;
    
    IF v_status = 'yes' THEN 
        -- Issue the book
        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id) 
        VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        -- Update book status
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        RAISE NOTICE 'Book issued successfully!';
    ELSE 
        RAISE NOTICE 'Book is currently unavailable.';
    END IF;
END;
$$;

-- Example usage:
-- CALL issue_book('IS155', 'C101', '978-0-553-29698-2', 'E101');
```

---

## 🛠️ Technologies Used

- **Database**: PostgreSQL
- **Language**: SQL, PL/pgSQL
- **Concepts**: 
  - Database Design & Normalization
  - CRUD Operations
  - JOINs (INNER, LEFT, RIGHT)
  - Aggregate Functions
  - Subqueries & CTEs
  - Stored Procedures
  - Triggers
  - CTAS (Create Table As Select)

---

## 🚀 Getting Started

### Prerequisites
- PostgreSQL 12 or higher
- pgAdmin 4 (optional, for GUI)
- Basic understanding of SQL

### Installation Steps

1. **Clone the repository**
```bash
git clone <your-repository-url>
cd library-management-system
```

2. **Create the database**
```sql
CREATE DATABASE library_db;
```

3. **Run the schema scripts**
Execute the table creation scripts in order:
- Create tables (branch, employees, members, books, issued_status, returned_status)
- Insert sample data
- Create stored procedures

4. **Verify installation**
```sql
-- Quick check
SELECT * FROM books LIMIT 5;
SELECT * FROM members LIMIT 5;
```

---

## 📊 Key Features

✅ Complete library database schema with referential integrity  
✅ CRUD operations for all entities  
✅ Advanced query examples (18+ tasks)  
✅ Automated book issue/return with stored procedures  
✅ Overdue book tracking  
✅ Branch performance analytics  
✅ Member activity monitoring  
✅ Revenue reporting by category  

---

## 📈 Sample Queries for Practice

```sql
-- View all books currently issued
SELECT * FROM issued_status WHERE issued_id NOT IN (SELECT issued_id FROM returned_status);

-- Find most popular book category
SELECT category, COUNT(*) as issue_count 
FROM books b JOIN issued_status ist ON b.isbn = ist.issued_book_isbn 
GROUP BY category 
ORDER BY issue_count DESC;

-- Calculate average rental price by category
SELECT category, ROUND(AVG(rental_price), 2) as avg_price 
FROM books 
GROUP BY category;
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

---

## 📝 License

This project is open source and available for educational purposes.

---


## 🎓 Learning Outcomes

By completing this project, you will master:
- Database design and normalization principles
- Complex SQL query writing
- Stored procedure development
- Transaction management
- Data analysis using SQL
- Real-world database problem-solving

---

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL Tutorial - W3Schools](https://www.w3schools.com/sql/)
- [Database Design Best Practices](https://www.postgresql.org/docs/current/ddl.html)

---

**⭐ If you find this project helpful, please consider giving it a star!**

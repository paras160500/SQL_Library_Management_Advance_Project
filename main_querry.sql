-- For Easyness
select * from books;
select * from members;
select * from branch;
select * from employees;
select * from issued_status;
select * from returned_status;



-- Project Tasks 

-- 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books (isbn,book_title,category,rental_price,status,author,publisher)
values 
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. update exsisting members address
update  members
set member_address = '125 Main St.'
where member_id = 'C101'

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issued_status
where issued_id = 'IS121'

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 4. Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select issued_book_name
from issued_status 
where issued_emp_id = 'E101'

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 5. List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select 
issued_member_id ,
count(*) as no_of_books_assign
from issued_status
group by issued_member_id
having count(*) > 1

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 6. Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_cnts
as 
select 
b.isbn , 
b.book_title,
count(*) as totalBookIssued
from books as b 
join issued_status as ist
on b.isbn = ist.issued_book_isbn
group by b.isbn

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 7. Retrieve All Books in a Specific Category
select * 
from books
where category = 'Classic'

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 8. Find Total Rental Income by Category:
select 
b.category , 
sum(b.rental_price) as sum_of_rental
from books b
join issued_status ist 
on b.isbn = ist.issued_book_isbn
group by b.category;

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 9. List Members Who Registered in the Last 180 Days:
insert into members(member_id , member_name , member_address , reg_date) values 
('C117' , 'Sam' , '111123 street' , '2025-11-01');
insert into members(member_id , member_name , member_address , reg_date) values 
('C1200' , 'Karran' , '666666 street' , '2025-10-21');

select *
from members
where reg_date > current_date - 180

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 10. List Employees with Their Branch Manager's Name and their branch details:
select emp.*,
e2.emp_name as manager
from
employees as emp
join branch as b 
on b.branch_id = emp.branch_id
join employees as e2
on b.manager_id = e2.emp_id;

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 11.  Create a Table of Books with Rental Price Above a Certain Threshold 10 USD:
create table  books_price_greater_than_seven
as
select *
from books
where rental_price > 7;

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 12. Retrieve the List of Books Not Yet Returned
select
distinct ist.issued_book_name
from issued_status as ist
left join returned_status as rst
on ist.issued_id = rst.issued_id
where rst.return_id is null 

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 13. Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
-- members == issued_status == books == returned_status
-- filter book that is return 
-- over due > 30 
select *
from (
	select 
	m.member_id,
	m.member_name,
	b.book_title,
	ist.issued_date,
	rst.return_date,
	'2024-08-24' - ist.issued_date as over_due
	from issued_status as ist 
	join members as m
	on ist.issued_member_id = m.member_id
	join books as b
	on ist.issued_book_isbn = b.isbn
	left join returned_status as rst
	on ist.issued_id = rst.issued_id
	where rst.return_date is null
) as t2
where over_due > 30

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 14.  Update Book Status on Return
--      Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
create or replace procedure add_return_records(p_return_id varchar(10), p_issued_id varchar(10) , p_book_quality varchar(20))
language plpgsql
as $$
declare
	v_isbn varchar(20);
	v_title varchar(70);
begin
	--insert data into returned_status
	insert into returned_status(return_id , issued_id ,return_date , book_quality )
	values 
	(p_return_id , p_issued_id , current_date , p_book_quality);

	--fetching the isbn
	select issued_book_isbn , issued_book_name 
	into v_isbn,v_title
	from issued_status 
	where issued_id = p_issued_id;
	
	--update book status
	update books
	set status = 'yes'
	where isbn = v_isbn;

	--acknowlegde
	raise notice 'Thank you for returning the book : %', v_title;
end;
$$

call add_return_records()

select * from issued_status

-- 15. Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
create table branch_reports
as 
	select 
	b.branch_id , 
	b.branch_address , 
	count(ist.issued_id) as total_book_issued,
	sum(bk.rental_price) as total_rental_revenue,
	count(rst.return_id) as total_return_number
	from branch as b
	join employees as emp
	on b.branch_id = emp.branch_id
	join issued_status as ist
	on ist.issued_emp_id = emp.emp_id
	join books as bk 
	on ist.issued_book_isbn = bk.isbn
	left join returned_status as rst 
	on rst.issued_id = ist.issued_id
	group by b.branch_id
	order by 1

select * from returned_status 

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 16. CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
create table active_member
as 
	select * from
	members where 
	member_id in (
	select 
		distinct issued_member_id
	from issued_status 
	where issued_date >= (date '2024-06-01' - interval '2 month')
	)

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 17. Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
select emp.emp_id ,
emp.emp_name ,ist.total_book_issue,
b.branch_id,b.branch_address
from
employees as emp 
join (
	select 
	issued_emp_id,
	count(issued_id) as total_book_issue
	from issued_status 
	group by issued_emp_id
	order by count(issued_id) desc 
	limit 3 
) as ist
on emp.emp_id = ist.issued_emp_id
join branch as b 
on b.branch_id = emp.branch_id

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- 18.  Stored Procedure Objective: 
	-- 	Create a stored procedure to manage the status of books in a library system. 
	-- 	Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
	-- 	The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
	-- 	The procedure should first check if the book is available (status = 'yes'). 
	-- 	If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
	-- 	If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.*/

select * from books  

select * from issued_status

create or replace procedure issue_book(p_issued_id varchar(10), p_issued_member_id varchar(10) , p_issued_book_isbn varchar(25) , p_issued_emp_id varchar(10))
language plpgsql
as $$

declare 
	v_status varchar(10);
begin
	-- check if book is available 
	select status 
	into v_status 
	from books where 
	isbn = p_issued_book_isbn ;
	
	if v_status = 'yes' then 
		insert into issued_status(issued_id , issued_member_id , issued_date , issued_book_isbn , issued_emp_id) 
		values (p_issued_id , p_issued_member_id , current_date ,  p_issued_book_isbn , p_issued_emp_id);

		update books
		set status = 'yes'
		where isbn = v_isbn;

		raise notice 'Book Record added successfully';

	else 
		raise notice 'Book already assign to someone';
	end if;
end;
$$



-- LIBRARY MANAGEMENT SYSTEM

--Creating Tables 

drop table if exists branch;
create table branch (
	branch_id varchar(10) primary key,
	manager_id varchar(10),
	branch_address varchar(50),
	contact_n0 varchar(10)
);

drop table if exists employees;
create table employees (
	emp_id varchar(10) primary key,
	emp_name varchar(25),
	position varchar(15),
	salary int ,
	branch_id varchar(10)   -- FK
);

drop table if exists books;
create table books (
	isbn varchar(20) primary key,
	book_title varchar(70),
	category varchar(30),
	rental_price float,
	status varchar(15),
	author varchar(40),
	publisher varchar(40)
);

drop table if exists members;
create table members (
	member_id varchar(20) primary key,
	member_name varchar(25),
	member_address varchar(75),
	reg_date date
);

drop table if exists issued_status;
create table issued_status (
	issued_id varchar(10) primary key,
	issued_member_id varchar(10),  -- FK
	issued_book_name varchar(75),
	issued_date date,
	issued_book_isbn varchar(25),  -- FK
	issued_emp_id varchar(10)      -- FK
);

drop table if exists returned_status;
create table returned_status (
	return_id varchar(10) primary key,
	issued_id varchar(10),
	return_book_name varchar(75),
	return_date date,
	return_book_isbn varchar(20)
);



-- Foreign Key Constraint

alter table issued_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);

alter table issued_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_employees
foreign key (issued_emp_id)
references employees(emp_id);

alter table employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);

alter table returned_status
add constraint fk_issued_status
foreign key (issued_id)
references issued_status(issued_id);


























































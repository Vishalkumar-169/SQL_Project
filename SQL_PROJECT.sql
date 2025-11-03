create database Book_store;
use Book_store;

create table Books (Books_id int primary key, Title varchar(50),
Author varchar(50),Genre varchar(50),Published_Year int,
price float,stock int);


create table Customers (Customer_id int primary key,Name varchar(50),
Email varchar(50),Phone int,city varchar(20),Country varchar(20));


CREATE TABLE Orders (
    Order_id INT primary key,
    Customer_id int,
    Book_id int,
    Order_Date date,
    Quantity int,
    Total_Amount float,
   constraint fk_customers foreign key (Customer_id) references Customers(Customer_id),
    constraint fk_books foreign key (Book_id) references Books(Books_id)
);

select*from books;
select * from Customers;
select * from Orders;

# Basics Queries

# 1. Retrieve all books in the "Fiction" genre ?
select *from Books where genre="Fiction";

# 2. Find books published after the year 1950 ?
select * from Books where published_Year>1950;

# 3. List all customers from tha Canada ?
select * from Customers where country = "Canada";

# 4. Show orders placed in November 2023 ?
select * from Orders where Order_Date between "2023-11-01" and "2023-11-30"

# 5. Retrieve the total stock of books avaliable ?
select sum(stock) as Total_Stock from Books;

# 6. Find the details of the most expensive books ?
select * from Books order by price desc limit 1;

# 7. Show all customers who ordered more than 1 quantity of a book ?
select *from Orders where quantity>1;

# 8. Retrieve all orders where the total amount exceeds $20 ?
select * from Orders where Total_Amount>20;

# 9. List all genres available in the Books table ?
select genre from Books;
select distinct genre from Books; 

# 10. Find the books with the lowest stocks ?
select * from Books order by stock asc limit 2;

# 11. Calculate the total revenue generated from all order ?
select sum(Total_Amount) as  total_revenue from Orders;

#   ------------------------- ADVANCE QUERIES---------------------

# 1.Retrieve the total number of books sold for each genre ?
select Genre,Quantity from Orders join Books  on Orders.book_id=Books.books_id;

# 2. Find the average price of books in the "Fantasy" genre ?
select avg(price) as average_price  from Books where Genre="Fantasy";

# 3. List customer who have placed at least 2 orders ?
select Customer_id, count(Order_id) as order_count
from Orders group by customer_id having count(Order_id)>=2;

# 4. Find the most frequently ordered books ?
select book_id,Books.Title, count(Orders.Order_id) as order_count
from Orders join Books on Orders.book_id=Books.Books_id group by Orders.book_id,Books.Title order by order_count desc limit 1;

# 5. Show the top 3 most expensive books of "Fantasy" genre ?
select * from Books where Genre ="Fantasy" order by price desc limit 3;

# 6. Retrive the total quantity of books sold by each author ?
select Author ,sum(Quantity) as total_book_sold from Orders join Books on Books.books_id=Orders.book_id
group by Author;

# 7. List the cities where customers who spent over $30 are located ?
select distinct city ,Total_amount from Orders join Customers on Orders.Customer_id=Customers.Customer_id
where Total_Amount>30;

# 8. Find the customers who spent the most on orders ?
select Customer_id,Name ,sum(Total_amount) as Total_spent 
from Orders join Customers on Orders.Customer_id=Customers.Customer_id
group by Customer_id, Name order by Total_spent desc limit 1;

Select
    Customers.Customer_id,
    Customers.Name,
    SUM(Orders.Total_amount) as Total_spent
from Orders
 join Customers 
    on Orders.Customer_id = Customers.Customer_id
group by 
    Customers.Customer_id, Customers.Name
order by 
    Total_spent desc
limit 1;

# 9. Calculate the stock remaining after fulfilling all orders:
select Book_id,Title,stock, coalesce(sum(quantity),0)as Order_quantity, stock-coalesce(sum(quantity),0)as reamining_quantity from Books 
left join Orders on Books.books_id=Orders.book_id
group by books_id;
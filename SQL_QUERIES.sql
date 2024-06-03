
CREATE TABLE customer (
    Customer_ID varchar PRIMARY KEY,
	User_ID INT,
    Age INT,
    Gender VARCHAR(10),
    State VARCHAR(50),
    Country VARCHAR(50),
    Pincode VARCHAR(20)
);

-- Inserting into the customer table
INSERT INTO customer (Customer_ID, User_ID, Age, Gender, State, Country, Pincode)
VALUES (1, 276725, 30, 'M', 'California', 'USA', '90001');

select * from customer
copy customer FROM 'D:/DATA ANALYTICS/sql task/customerr.csv' DELIMITER ',' CSV HEADER;
---------------------------------------------------------------------------------------
CREATE TABLE book_details (
    ISBN VARCHAR(20) PRIMARY KEY,
    Book_Title VARCHAR(255),
    Book_Author VARCHAR(255),
    Year_Of_Publication varchar,
    Publisher VARCHAR(255)
);
-- Inserting into the book_details table
INSERT INTO book_details (ISBN, Book_Title, Book_Author, Year_Of_Publication, Publisher)
VALUES ('9781503261969', 'Pride and Prejudice', 'Jane Austen', 1813, 'CreateSpace Independent Publishing Platform');

INSERT INTO book_details (ISBN, Book_Title, Book_Author, Year_Of_Publication, Publisher)
VALUES ('9781503251969', 'Pride and Prejudice', 'Jane Austen', 1813, 'CreateSpace Independent Publishing Platform');

copy book_details FROM 'D:\DATA ANALYTICS\sql task\BBook.csv' DELIMITER ',' CSV HEADER;
select * from book_details
--------------------------------------------------------------------------------------
CREATE TABLE sale (
    Sale_ID  VARCHAR(20) PRIMARY KEY,
	Customer_ID varchar,
	User_ID  VARCHAR(20),
    ISBN VARCHAR(20),
    Ship_Mode VARCHAR(50),
    Price  VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
    FOREIGN KEY (ISBN) REFERENCES book_details(ISBN)
);

INSERT INTO sale (Sale_ID, Customer_ID, User_ID, ISBN, Ship_Mode, Price)
VALUES (1, 1, 276725, '9781503261969', 'Standard', 259);
INSERT INTO sale (Sale_ID, Customer_ID, User_ID, ISBN, Ship_Mode, Price)
VALUES (400, 400, 276890, '9781503261969', 'Standard', 259);
INSERT INTO sale (Sale_ID, Customer_ID, User_ID, ISBN, Ship_Mode, Price)
VALUES (401, 401, 276889, '9781503261969', 'Standard', 259);

select * from sale

copy sale FROM 'D:\DATA ANALYTICS\sql task\SALES.csv' DELIMITER ',' CSV HEADER;
-----------------------------------------------

===========================================================
==============================================================================
1---GROUP,ORDER,HAVING:- What are the  sale prices used for each shipping method?
	
SELECT Ship_mode, 
	Sum(CAST(sale.price as int)) AS Total_Sales
FROM sale
    GROUP BY Ship_mode
HAVING sum(CAST(sale.price as int)) > 1000
    ORDER BY Total_Sales DESC;

=================================================================

2------Retrieve the total sales per Customer by Gender
---------- Identify genders with more than 3 total sales by total sales amount.

SELECT customer.Gender,
COUNT(sale.sale_ID) AS Total_Sales_Count,
sum(CAST(sale.price as int)) AS Total_Sales_Amount
from sale join Customer ON
sale.Customer_ID = customer.Customer_ID
Group By Customer.Gender
Having Count(sale.Sale_id) > 3;

=================================================================
3---------WINDOW FUNCTION--Give rank for each shipping mode.

	select Sale_ID, Customer_ID, Ship_Mode, Price,
   RANK() 
OVER(
	PARTITION BY ship_mode
ORDER BY Price) as RANK_SALE
     from sale 

========================================================================
4--subquery with where:- --Retrive all the price where price is greater than 
------950 and Ship_mode is Same Day

	select * from sale where sale_ID 
	in(select distinct sale_ID from sale  
	WHERE CAST(Price AS NUMERIC) > 950)
    and ship_mode = 'Same Day'
=====================================================================
5-----Join with where query:- Retrive book_title and Price of author 'Jane Austen'
select book_details.Book_Title, sale.Price, sale.Ship_mode
	from book_details
inner join sale
	on book_details.ISBN = sale.ISBN
where  Ship_mode = 'Same Day'
==========================================================
6-----3 table join:- Retrieve Age,Country from customer,Ship_mode from sale,Book_Title from book_details 
	select customer.Age,customer.Country,sale.Ship_mode,book_details.Book_Title
	from customer 
	inner join sale
	on customer.Customer_ID = sale.Customer_ID
	inner join book_details
	on sale.ISBN = book_details.ISBN
===========================================================
7-----Create table with select Query
-----:-where 15 most recently published unique books based on their titles and years of publication.

	CREATE TABLE Most_Common_Book AS
      SELECT DISTINCT book_Title, Year_Of_Publication
FROM book_details
       ORDER BY Year_Of_Publication 
DESC limit 15;
select * from Most_Common_Book	

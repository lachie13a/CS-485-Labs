--1.	Display the invoice number, the invoice date, the customer id, and the customer name for each order in the database.
SELECT invoice_num, invoice_date, customer.cust_id, cust_name FROM invoice, customer WHERE customer.cust_id = invoice.cust_id;

SELECT invoice_num, invoice_date, c.cust_id, cust_name FROM invoice as i, customer as c WHERE c.cust_id = i.cust_id;

SELECT invoice_num, invoice_date, customer.cust_id, cust_name FROM invoice INNER JOIN customer ON invoice.cust_id = customer.cust_id;
--2.	Display the invoice number, the customer id, and the customer name for each order placed on September 12th, 2007.
SELECT invoice_num, invoice_date, c.cust_id, cust_name FROM invoice as i, customer as c WHERE c.cust_id = i.cust_id AND invoice_date = '12-SEP-07';

--3.	Display the invoice number, the invoice date, the product id, the number of units ordered, and the line price for each line in each order.
SELECT 
    i.invoice_num, 
    i.invoice_date, 
    il.prod_id, 
    il.line_num_ordered,
    il.line_price 
FROM 
    invoice i, 
    line il 
WHERE 
    i.invoice_num = il.invoice_num;
	
--4.	Display the id and the name of each customer that placed an order on September 12th, 2007, using the IN operator in your query.
SELECT cust_id, cust_name FROM customer WHERE cust_id IN (SELECT cust_id FROM invoice WHERE invoice_date = '12-SEP-07');

--5.	Display the id and the name of each customer that placed an order on September 12th, 2007, using the EXISTS operator in your query.
SELECT c.cust_id, c.cust_name 
FROM customer c 
WHERE EXISTS (
    SELECT * FROM invoice i 
    WHERE i.cust_id = c.cust_id AND i.invoice_date = '12-SEP-07'
);

--6.	Display the id and the name of each customer that did not place an order on September 12th, 2007.   (Be careful in performing this query.)
SELECT cust_id, cust_name 
FROM customer 
WHERE cust_id NOT IN (
    SELECT cust_id 
    FROM invoice 
    WHERE invoice_date = '12-SEP-07'
);
 
--7.	Display the invoice number, the invoice date, the product id, the product description, and the product type for each line in each order.
SELECT 
    i.invoice_num, 
    i.invoice_date, 
    p.prod_id, 
    p.prod_desc, 
    p.prod_type 
FROM 
    invoice i, 
    line il, 
    product p 
WHERE 
    i.invoice_num = il.invoice_num 
    AND il.prod_id = p.prod_id;

--8.	Display the same data as in question 7, but order the display by product type.  Within each type, order the display by invoice number.
SELECT 
    i.invoice_num, 
    i.invoice_date, 
    p.prod_id, 
    p.prod_desc, 
    p.prod_type 
FROM 
    invoice i, 
    line il, 
    product p 
WHERE 
    i.invoice_num = il.invoice_num 
    AND il.prod_id = p.prod_id
ORDER BY 
    prod_type, invoice_num;

--9.	Display the sales representative's id, last name, and first name of each representative who represents, at a minimum, one customer whose credit is $10,000 using a subquery.
SELECT rep_id, rep_lname, rep_fname 
FROM rep 
WHERE rep_id IN (
    SELECT rep_id 
    FROM customer 
    WHERE cust_limit = 10000.00
);
 
--10.	Display the same data as in the previous question without using a subquery.
SELECT DISTINCT (r.rep_id), rep_lname, rep_fname FROM rep as r JOIN customer AS c ON r.rep_id = c.rep_id WHERE cust_limit >= 10000;

--11.	Display the id and the name of each customer with a current order for a Blender.
SELECT DISTINCT c.cust_id, c.cust_name FROM customer AS c JOIN invoice AS i ON c.cust_id = i.cust_id JOIN line AS l ON i.invoice_num = l.invoice_num JOIN product AS p ON l.prod_id = p.prod_id WHERE p.prod_desc = 'Blender';

--12.	Display the invoice number and the invoice date for each customer order placed by Charles Appliance and Sport.
SELECT i.invoice_num, i.invoice_date FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id WHERE c.cust_name = 'Charles Appliance and Sport';

--13.	Display the invoice number and the invoice date for each invoice that contains an Electric Range.
SELECT i.invoice_num, i.invoice_date FROM invoice AS i WHERE i.invoice_num IN (SELECT l.invoice_num FROM line AS l JOIN product AS p ON l.prod_id = p.prod_id WHERE p.prod_desc = 'Electric Range');

--14.	Display the invoice number and the invoice date for each invoice that was either placed by Charles Appliance and Sport or whose invoice contains an Electric Range.  Use a set operation to perform this query.
SELECT i.invoice_num, i.invoice_date FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id WHERE c.cust_name = 'Charles Applicance and Sport' 
UNION
SELECT i.invoice_num, i.invoice_date FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num JOIN product AS p ON l.prod_id = p.prod_id WHERE p.prod_desc = 'Electric Range';

--15.	Display the invoice number and the invoice date for each invoice that was placed by Charles Appliance and Sport and whose invoice contains an Electric Range.  Use a set operation to perform this query.
SELECT i.invoice_num, i.invoice_date FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id WHERE c.cust_name = 'Charles Appliance and Sport'
INTERSECT
SELECT i.invoice_num, i.invoice_date FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num JOIN product AS p ON l.prod_id = p.prod_id WHERE p.prod_desc = 'Electric Range';

--16.	Display the invoice number and the invoice date for each invoice that was placed by Charles Appliance and Sport and whose invoice does not contain an Electric Range.  Use a set operation to perform this query.
SELECT i.invoice_num, i.invoice_date FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id WHERE c.cust_name = 'Charles Appliance and Sport'
EXCEPT
SELECT i.invoice_num, i.invoice_date FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num JOIN product AS p ON l.prod_id = p.prod_id WHERE p.prod_desc = 'Electric Range';

--17.	Display the product id, the product description, the product price, and the product type for each product whose product price is greater than the price of every part in product type SG.  Be sure to correctly choose either the ALL or the ANY operator in your query.
SELECT prod_id, prod_desc, prod_price, prod_type FROM product
WHERE prod_price > ALL (
	SELECT prod_price
	FROM product
	WHERE prod_type = 'SG'
);

--18.	Display the same attributes as in the previous question.  However, use the other of the two operators: ALL or ANY.  This version of the SQL statement provides the answer to a question.  What is that question?  Add your answer as a comment to your list file.
SELECT prod_id, prod_desc, prod_price, prod_type FROM product
WHERE prod_price > ANY (
	SELECT prod_price
	FROM product
	WHERE prod_type = 'SG'
);

--19.	Display the id, the description, the quantity, the invoice number, and the number of units ordered for each product.  Make sure to include all products in your output.  The order number and the number of ordered units must remain blank for any product that is not contained in an invoice.  Order your display by product number.
SELECT p.prod_id, p.prod_desc, p.prod_quantity, l.invoice_num, l.line_num_ordered FROM product AS p LEFT JOIN line l ON p.prod_id = l.prod_id
ORDER BY p.prod_id;
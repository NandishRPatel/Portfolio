### LIMIT

/*
1. Try using LIMIT yourself below by writing a query 
that displays all the data in the occurred_at, 
account_id, and channel columns of the web_events table, 
and limits the output to only the first 15 rows.
*/

SELECT occurred_at, account_id, channel 
FROM web_events
LIMIT(15); # LIMIT 15




### ORDER BY

/*
1. Write a query to return the 10 earliest orders in 
the orders table. Include the id, occurred_at, and 
total_amt_usd.
*/

SELECT id, occurred_at, total_amt_usd 
FROM orders
ORDER BY occurred_at # ORDER BY 2
LIMIT(10); # LIMIT 10


/*
2. Write a query to return the top 5 orders in terms of 
largest total_amt_usd. Include the id, account_id, and 
total_amt_usd.
*/

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC # ORDER BY 3 DESC
LIMIT(5); # LIMIT 5


/*
3. Write a query to return the lowest 20 orders in 
terms of smallest total_amt_usd. Include the id, 
account_id, and total_amt_usd.
*/

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd # ORDER BY 3
LIMIT(20); # LIMIT 20




### ORDER BY RETURNS

/*
1. Write a query that displays the order ID, account 
ID, and total dollar amount for all the orders, sorted 
first by the account ID (in ascending order), and then 
by the total dollar amount (in descending order).
*/

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, 
total_amt_usd DESC; # ORDER BY 2, 3 DESC


/*
2. Now write a query that again displays order ID, 
account ID, and total dollar amount for each order, but 
this time sorted first by total dollar amount (in 
descending order), and then by account ID (in 
ascending order).
*/

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, 
account_id; # ORDER BY 3 DESC, 2


/*
3. Compare the results of these two queries above. How 
are the results different when you switch the column 
you sort on first?
*/

/*
In query #1, all of the orders for each account ID are 
grouped together, and then within each of those 
groupings, the orders appear from the greatest order 
mount to the least. In query #2, since you sorted by 
the total dollar amount first, the orders appear from 
greatest to least regardless of which account ID hey 
were from. Then they are sorted by account ID next. 
(The secondary sorting by account ID is difficult to 
see here, since only if there were two orders with 
equal total dollar amounts would there need to be any 
sorting by account ID.)
*/




### WHERE


/*
1. Pulls the first 5 rows and all columns from the 
orders table that have a dollar amount of gloss_amt_usd 
greater than or equal to 1000.
*/

SELECT * 
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT(5); # LIMIT 5


/*
2. Pulls the first 10 rows and all columns from the 
orders table that have a total_amt_usd less than 500.
*/

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT(10); # LIMIT 10




### Practice Question Using WHERE with Non-Numeric Data


/*
1. Filter the accounts table to include the company 
name, website, and the primary point of contact 
(primary_poc) just for the Exxon Mobil company in the 
accounts table.
*/

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil'; 
# WHERE name IN('Exxon Mobil')




### Questions using Arithmetic Operations


/*
1. Create a column that divides the standard_amt_usd by 
the standard_qty to find the unit price for standard 
paper for each order. Limit the results to the first 10 
orders, and include the id and account_id fields.
*/

SELECT id, account_id, standard_amt_usd/standard_qty 
AS unit_price
FROM orders
LIMIT(10); # LIMIT 10


SELECT id, account_id, 
round(standard_amt_usd/standard_qty, 2) AS unit_price
FROM orders
LIMIT(10); # LIMIT 10


/*
2. Write a query that finds the percentage of revenue 
that comes from poster paper for each order. You will 
need to use only the columns that end with _usd. (Try 
to do this without using the total column.) Display 
the id and account_id fields also. NOTE - you will 
receive an error with the correct solution to this 
question. This occurs because at least one of the 
values in the data creates a division by zero in your 
formula. You will learn later in the course how to 
fully handle this issue. For now, you can just limit 
your calculations to the first 10 orders, as we did 
in question #1, and you'll avoid that set of data that
causes the problem.
*/

SELECT id, account_id, (poster_amt_usd * 100)/(poster_amt_usd + standard_amt_usd + 
	gloss_amt_usd) AS percentage_revenue_poster
FROM orders;


SELECT id, account_id, round((poster_amt_usd * 100)/(poster_amt_usd + standard_amt_usd + 
	gloss_amt_usd + 0.0000001), 2) AS percentage_revenue_poster
FROM orders;




### Questions using the LIKE operator


/*
1. All the companies whose names start with 'C'.
*/

SELECT *
FROM accounts
WHERE name LIKE 'C%';


/*
2. All companies whose names contain the string 'one' somewhere in the name.
*/

SELECT *
FROM accounts
WHERE name LIKE '%one%';


/*
3. All companies whose names end with 's'.
*/

SELECT *
FROM accounts
WHERE name LIKE '%s';




### Questions using IN operator


/*
1. Use the accounts table to find the account name, primary_poc, and 
sales_rep_id for Walmart, Target, and Nordstrom.
*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');


/*
2. Use the web_events table to find all information regarding individuals who 
were contacted via the channel of organic or adwords.
*/

SELECT * 
FROM web_events
WHERE channel IN ('organic', 'adwords');




### Questions using the NOT operator


/*
1. Use the accounts table to find the account name, primary poc, and sales 
rep id for all stores except Walmart, Target, and Nordstrom.
*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');


/*
2. Use the web_events table to find all information regarding individuals who 
were contacted via any method except using organic or adwords methods.
*/

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');


/*
3. All the companies whose names do not start with 'C'.
*/

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';


/*
4. All companies whose names do not contain the string 'one' somewhere in the 
name.
*/

SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';


/*
5. All companies whose names do not end with 's'.
*/

SELECT *
FROM accounts
WHERE name NOT LIKE '%s';




### Questions using AND and BETWEEN operators


/*
1. Write a query that returns all the orders where the standard_qty is over 
1000, the poster_qty is 0, and the gloss_qty is 0.
*/

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;


/*
2. Using the accounts table, find all the companies whose names do not start 
with 'C' and end with 's'.
*/

SELECT *
FROM accounts
WHERE (name NOT LIKE 'C%') AND (name NOT LIKE '%s');


/*
3. When you use the BETWEEN operator in SQL, do the results include the values 
of your endpoints, or not? Figure out the answer to this important question by 
writing a query that displays the order date and gloss_qty data for all orders 
where gloss_qty is between 24 and 29. Then look at your output to see if the 
BETWEEN operator included the begin and end values or not.
*/

SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty DESC; # ORDER BY 2 DESC


/*
4. Use the web_events table to find all information regarding individuals who 
were contacted via the organic or adwords channels, and started their account 
at any point in 2016, sorted from newest to oldest.
*/

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND 
occurred_at BETWEEN '01-01-2016' AND '01-01-2017';




### Questions using the OR operator


/*
1. Find list of orders ids where either gloss_qty or poster_qty is greater than
4000. Only include the id field in the resulting table.
*/

SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;


/*
2. Write a query that returns a list of orders where the standard_qty is zero
and either the gloss_qty or poster_qty is over 1000.
*/

SELECT *
FROM orders
WHERE (gloss_qty > 1000 OR poster_qty > 1000)
AND standard_qty = 0;


/*
3. Find all the company names that start with a 'C' or 'W', and the primary
contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
*/

SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND 
	(primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND
	(primary_poc NOT LIKE '%eana%');




### JOIN


/*
1. Try pulling all the data from the accounts table, and all the data from 
the orders table.
*/

SELECT *
FROM orders
JOIN accounts
	ON orders.account_id = accounts.id;


/*
2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, 
and the website and the primary_poc from the accounts table.
*/

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, 
accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;




### JOIN and Alias


/*
1. Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of 
the event, and the channel for each event. Additionally, you might choose to 
add a fourth column to assure only Walmart events were chosen.
*/

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.name = 'Walmart';


SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
WHERE a.name = 'Walmart';


/*
2. Provide a table that provides the region for each sales_rep along with their
associated accounts. Your final table should include three columns: the region
name, the sales rep name, and the account name. Sort the accounts 
alphabetically (A-Z) according to account name.
*/

SELECT r.name region_name, s.name sales_rep_name, 
a.name account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a 
ON s.id = a.sales_rep_id
ORDER BY account_name;


SELECT r.name AS region_name, s.name AS sales_rep_name, 
a.name AS account_name
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a 
ON s.id = a.sales_rep_id
ORDER BY account_name;


SELECT r.name region_name, s.name sales_rep_name, 
a.name account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a 
ON s.id = a.sales_rep_id
ORDER BY 3;


/*
3. Provide the name for each region for every order, as well as the account 
name and the unit price they paid (total_amt_usd/total) for the order. Your 
final table should have 3 columns: region name, account name, and unit price. 
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not 
dividing by zero.
*/


SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id;


### JOIN and Filtering


/* You can filter using on clause with AND(This happens before joining the 
tables) */


/*
1. Provide a table that provides the region for each sales_rep along with 
their associated accounts. This time only for the Midwest region. Your final 
table should include three columns: the region name, the sales rep name, and 
the account name. Sort the accounts alphabetically (A-Z) according to account
name.
*/

SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id  AND r.name = 'Midwest'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name; /*ORDER BY account_name*/


SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id  AND r.name = 'Midwest'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY 2; /*ORDER BY account_name*/


SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id 
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
ORDER BY a.name; /*ORDER BY account_name*/


/*
2. Provide a table that provides the region for each sales_rep along with 
their associated accounts. This time only for accounts where the sales rep 
has a first name starting with S and in the Midwest region. Your final table 
should include three columns: the region name, the sales rep name, and the 
account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id  AND (s.name LIKE 'S%' AND r.name = 'Midwest')
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name; /*ORDER BY account_name*/


SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id  AND (s.name LIKE 'S%' AND r.name = 'Midwest')
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY 2; /*ORDER BY account_name*/


SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id 
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name; /*ORDER BY account_name*/


/*
3. Provide a table that provides the region for each sales_rep along with 
their associated accounts. This time only for accounts where the sales rep 
has a last name starting with K and in the Midwest region. Your final table 
should include three columns: the region name, the sales rep name, and the 
account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id  AND 
(s.name LIKE '% K%' AND r.name = 'Midwest')
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name; /*ORDER BY account_name*/


SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id  AND 
(s.name LIKE '% K%' AND r.name = 'Midwest')
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY 2; /*ORDER BY account_name*/


SELECT r.name region_name, a.name account_name, 
s.name sales_rep_name
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id 
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name; /*ORDER BY account_name*/


/*
4. Provide the name for each region for every order, as well as the account 
name and the unit price they paid (total_amt_usd/total) for the order. However,
you should only provide the results if the standard order quantity exceeds 100.
Your final table should have 3 columns: region name, account name, and unit 
price. In order to avoid a division by zero error, adding .01 to the 
denominator here is helpful total_amt_usd/(total+0.01).
*/

SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id AND o.standard_qty > 100
ORDER BY unit_price;


SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id AND o.standard_qty > 100
ORDER BY 3;


SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100
ORDER BY unit_price;

/*
5. Provide the name for each region for every order, as well as the account 
name and the unit price they paid (total_amt_usd/total) for the order. However,
you should only provide the results if the standard order quantity exceeds 100
and the poster order quantity exceeds 50. Your final table should have 3 
columns: region name, account name, and unit price. Sort for the smallest 
unit price first. In order to avoid a division by zero error, adding .01 to 
the denominator here is helpful (total_amt_usd/(total+0.01).
*/

SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id AND o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;


SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id AND o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY 3;


SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;



/*
6. Provide the name for each region for every order, as well as the account 
name and the unit price they paid (total_amt_usd/total) for the order. However,
you should only provide the results if the standard order quantity exceeds 100
and the poster order quantity exceeds 50. Your final table should have 3 
columns: region name, account name, and unit price. Sort for the largest unit
price first. In order to avoid a division by zero error, adding .01 to the 
denominator here is helpful (total_amt_usd/(total+0.01).
*/

SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id AND o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;


SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id AND o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY 3 DESC;


SELECT r.name region_name, a.name account_name, 
o.total_amt_usd/(o.total + 0.001) unit_price
FROM region r 
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;


/*
7. What are the different channels used by account id 1001? Your final table 
should have only 2 columns: account name and the different channels. You can 
try SELECT DISTINCT to narrow down the results to only the unique values.
*/

SELECT w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id AND a.id = 1001;

/* BETTER */

SELECT DISTINCT w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id AND a.id = 1001;


SELECT DISTINCT w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.id = 1001;


/*
8. Find all the orders that occurred in 2015. Your final table should have 4 
columns: occurred_at, account name, order total, and order total_amt_usd.
*/


SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id AND o.occurred_at BETWEEN 
'01-01-2015' AND '01-01-2016';

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
WHERE o.occurred_at BETWEEN '01-01-2015' AND 
'01-01-2016';



### Aggregation Questions


/*
1. Find the total amount of poster_qty paper ordered in 
the orders table.
*/

SELECT SUM(poster_qty) total_poster_qty
FROM orders;

/*
2. Find the total amount of standard_qty paper ordered 
in the orders table.
*/

SELECT SUM(standard_qty) total_standard_qty
FROM orders;

/*
3. Find the total dollar amount of sales using the 
total_amt_usd in the orders table.
*/

SELECT SUM(total_amt_usd) total_amount_usd
FROM orders;

/*
4. Find the total amount spent on standard_amt_usd and 
gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the 
table.
*/

SELECT SUM(standard_amt_usd) std_amount_usd, 
SUM(gloss_amt_usd) gloss_amount_usd
FROM orders;

/*
5. Find the standard_amt_usd per unit of standard_qty 
paper. Your solution should use both an aggregation and 
a mathematical operator.
*/

SELECT SUM(standard_amt_usd)/SUM(standard_qty) 
AS unit_price_standard
FROM orders;


### Questions: MIN, MAX, & AVERAGE

/*
1. When was the earliest order ever placed? You only 
need to return the date.
*/

SELECT MIN(occurred_at) 
FROM orders;

/*
2. Try performing the same query as in question 1 
without using an aggregation function.
*/

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;


SELECT occurred_at
FROM orders
ORDER BY 1
LIMIT 1;


/*
3. When did the most recent (latest) web_event occur?
*/

SELECT MAX(occurred_at)
FROM web_events;

/*
4. Try to perform the result of the previous query 
without using an aggregation function.
*/

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;


SELECT occurred_at
FROM web_events
ORDER BY 1 DESC
LIMIT 1;


/*
5. Find the mean (AVERAGE) amount spent per order on 
each paper type, as well as the mean amount of each 
paper type purchased per order. Your final answer 
should have 6 values - one for each paper type for the 
average number of sales, as well as the average amount.
*/

SELECT AVG(standard_qty) mean_standard, 
AVG(gloss_qty) mean_gloss, 
AVG(poster_qty) mean_poster, 
AVG(standard_amt_usd) mean_standard_usd, 
AVG(gloss_amt_usd) mean_gloss_usd, 
AVG(poster_amt_usd) mean_poster_usd
FROM orders;

/*
6. Via the video, you might be interested in how to 
calculate the MEDIAN. Though this is more advanced than 
what we have covered so far try finding - what is the 
MEDIAN total_usd spent on all orders?
*/

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;


### Questions: GROUP BY



/*
1. Which account (by name) placed the earliest order? 
Your solution should have the account name and the date 
of the order.
*/


SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;


SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a
ON o.account_id = a.id
ORDER BY 2
LIMIT 1;


/*
2. Find the total sales in usd for each account. You 
should include two columns - the total sales for each 
company's orders in usd and the company name.
*/


SELECT a.name, SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total_sales DESC;


SELECT a.name, SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;


/*
3. Via what channel did the most recent (latest) 
web_event occur, which account was associated with this 
web_event? Your query should return only three values - 
the date, channel, and account name.
*/


SELECT w.channel, a.name, w.occurred_at
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;


SELECT w.channel, a.name, w.occurred_at
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY 3 DESC
LIMIT 1;


/*
4. Find the total number of times each type of channel 
from the web_events was used. Your final table should 
have two columns - the channel and the number of times 
the channel was used.
*/


SELECT channel, COUNT(*) times_used
FROM web_events
GROUP BY channel
ORDER BY times_used DESC;


SELECT channel, COUNT(*) times_used
FROM web_events
GROUP BY 1
ORDER BY 2 DESC;


/*
5. Who was the primary contact associated with the 
earliest web_event?
*/


SELECT w.occurred_at, a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1; 


SELECT w.occurred_at, a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY 1
LIMIT 1; 


/*
6. What was the smallest order placed by each account 
in terms of total usd. Provide only two columns - the 
account name and the total usd. Order from smallest 
dollar amounts to largest.
*/


SELECT a.name, MIN(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_usd;


SELECT a.name, MIN(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2;


/*
7. Find the number of sales reps in each region. Your 
final table should have two columns - the region and 
the number of sales_reps. Order from fewest reps to 
most reps.
*/


SELECT r.name, COUNT(*) total_sales_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY total_sales_reps;


SELECT r.name, COUNT(*) total_sales_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY 1
ORDER BY 2;


### Questions: GROUP BY Part II


/*
1. For each account, determine the average amount of 
each type of paper they purchased across their orders. 
Your result should have four columns - one for the 
account name and one for the average quantity purchased 
for each of the paper types for each account.
*/


SELECT a.name, AVG(standard_qty) standard_avg, 
AVG(gloss_qty) gloss_avg, AVG(poster_qty) poster_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;


SELECT a.name, AVG(standard_qty) standard_avg, 
AVG(gloss_qty) gloss_avg, AVG(poster_qty) poster_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 1;


/*
2. For each account, determine the average amount spent 
per order on each paper type. Your result should have 
four columns - one for the account name and one for the 
average amount spent on each paper type.
*/


SELECT a.name, AVG(standard_amt_usd) standard_amt, 
AVG(gloss_amt_usd) gloss_amt, 
AVG(poster_amt_usd) poster_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;


SELECT a.name, AVG(standard_amt_usd) standard_amt, 
AVG(gloss_amt_usd) gloss_amt, 
AVG(poster_amt_usd) poster_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 1;


/*
3. Determine the number of times a particular channel 
was used in the web_events table for each sales rep. 
Your final table should have three columns - the name 
of the sales rep, the channel, and the number of 
occurrences. Order your table with the highest number 
of occurrences first.
*/


SELECT s.name, w.channel, COUNT(*) num_occ
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name, w.channel
ORDER BY num_occ DESC;


SELECT s.name, w.channel, COUNT(*) num_occ
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1, 2
ORDER BY 3 DESC;


/*
4. Determine the number of times a particular channel 
was used in the web_events table for each region. Your 
final table should have three columns - the region name, 
the channel, and the number of occurrences. Order your 
table with the highest number of occurrences first.
*/


SELECT r.name, w.channel, COUNT(*) num_occ
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY r.name, w.channel
ORDER BY num_occ DESC;


SELECT r.name, w.channel, COUNT(*) num_occ
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1, 2
ORDER BY 3 DESC;


### Questions: DISTINCT


/*
1. Use DISTINCT to test if there are any accounts 
associated with more than one region.
*/


SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;


SELECT DISTINCT id, name
FROM accounts;


/*
2. Have any sales reps worked on more than one account?
*/


SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;


SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1, 2
ORDER BY 3;


SELECT DISTINCT id, name
FROM sales_reps;



### Questions: HAVING

# NOTE
/*
HAVING is the “clean” way to filter a query that has 
been aggregated, but this is also commonly done using 
a subquery. Essentially, any time you want to perform 
a WHERE on an element of your query that was created 
by an aggregate, you need to use HAVING instead.
*/


/*
1. How many of the sales reps have more than 5 accounts 
that they manage?
*/

SELECT s.id, s.name COUNT(a.id) num_accounts
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name # GROUP BY 1, 2
HAVING COUNT(a.id) > 5
ORDER BY num_accounts DESC; # ORDER BY 2 DESC


/*
2. How many accounts have more than 20 orders?
*/

SELECT a.id, a.name, COUNT(o.id) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING COUNT(o.id) > 20
ORDER BY 3 DESC; # ORDER BY num_orders


/*
3. Which account has the most orders?
*/

SELECT a.id, a.name, COUNT(o.id) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING COUNT(o.id) > 20
ORDER BY 3 DESC # ORDER BY num_orders
LIMIT 1; 


/*
4. Which accounts spent more than 30,000 usd total 
across all orders?
*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING SUM(o.total) > 30000
ORDER BY 3 DESC; # ORDER BY total_amt


/*
5. Which accounts spent less than 1,000 usd total 
across all orders?
*/

SELECT a.id, a.name, SUM(o.total) total_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING SUM(o.total) < 1000
ORDER BY 3; # ORDER BY total_amt

/*
6. Which account has spent the most with us?
*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
ORDER BY 3 DESC # ORDER BY total_amt
LIMIT 1; 


/*
7. Which account has spent the least with us?
*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
ORDER BY 3 # ORDER BY total_amt
LIMIT 1; 


/*
8. Which accounts used facebook as a channel to contact 
customers more than 6 times?
*/

SELECT a.id, a.name, COUNT(*) times_used
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING COUNT(*) > 6 # HAVING COUNT(*) > 6 
                    # AND w.channel = 'facebook'
ORDER BY 3 DESC; # ORDER BY times_used


/*
9. Which account used facebook most as a channel?
*/

SELECT a.id, a.name, COUNT(*) times_used
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY 1, 2 # GROUP BY a.id, a.name
ORDER BY 3 DESC # ORDER BY times_used
LIMIT 1;


/*
10. Which channel was most frequently used by most 
accounts?
*/

SELECT a.id, a.name, w.channel, COUNT(*) times_used
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1, 2, 3 # GROUP BY a.id, a.name, w.channel
ORDER BY 4 DESC # ORDER BY times_used
LIMIT 20;




### DATE FUNCTIONS


/*
GROUPing BY a date column is not usually very useful in 
SQL, as these columns tend to have transaction data 
down to a second. Keeping date information at such a 
granular data is both a blessing and a curse, as it 
gives really precise information (a blessing), but it 
makes grouping information together directly difficult 
(a curse).

Lucky for us, there are a number of built in SQL 
functions that are aimed at helping us improve our 
experience in working with dates.

The first function you are introduced to in working 
with dates is DATE_TRUNC.

DATE_TRUNC allows you to truncate your date to a 
particular part of your date-time column. Common 
trunctions are day, month, and year. Here is a great 
blog post by Mode Analytics on the power of this 
function.

DATE_PART can be useful for pulling a specific portion 
of a date, but notice pulling month or day of the week 
(dow) means that you are no longer keeping the years 
in order. Rather you are grouping for certain 
components regardless of which year they belonged in.

For additional functions you can use with dates, check 
out the documentation here, but the DATE_TRUNC and 
DATE_PART functions definitely give you a great start!
*/


/*
1. Find the sales in terms of total dollars for all 
orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals?
*/

SELECT DATE_TRUNC('year', occurred_at) year_order,
       # DATE_PART('year', occurred_at) year_order,
SUM(total_amt_usd) total_amt_usd
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/* 
When we look at the yearly totals, you might notice 
that 2013 and 2017 have much smaller totals than all 
other years. If we look further at the monthly data, 
we see that for 2013 and 2017 there is only one month 
of sales for each of these years (12 for 2013 and 1 
for 2017). Therefore, neither of these are evenly 
represented. Sales have been increasing year over year, 
with 2016 being the largest sales to date. At this rate, 
we might expect 2017 to have the largest sales.
*/


/*
2. Which month did Parch & Posey have the greatest 
sales in terms of total dollars? Are all months evenly 
represented by the dataset?
*/

SELECT DATE_PART('month', occurred_at) month_order,
SUM(total_amt_usd) total_amt_usd
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
# December


/*
3. Which year did Parch & Posey have the greatest sales 
in terms of total number of orders? Are all years 
evenly represented by the dataset?
*/

SELECT DATE_PART('year', occurred_at) month_order,
COUNT(*) total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
# 2016. 
# NO, year 13 and 17 are not


/*
4. Which month did Parch & Posey have the greatest 
sales in terms of total number of orders? Are all 
months evenly represented by the dataset?
*/

SELECT DATE_PART('month', occurred_at) month_order,
COUNT(*) total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
# December

/*
5. In which month of which year did Walmart spend the 
most on gloss paper in terms of dollars?
*/


SELECT a.name, 
DATE_TRUNC('month', o.occurred_at) month_order,
SUM(o.gloss_amt_usd) as gloss_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC;
# May 2016




### CASE Statement

/*
The CASE statement always goes in the SELECT clause.

CASE must include the following components: WHEN, THEN, 
and END. ELSE is an optional component to catch cases 
that didn’t meet any of the other previous CASE 
conditions.

CASE WHEN <statement> THEN <value> END

You can make any conditional statement using any 
conditional operator (like WHERE) between WHEN and 
THEN. This includes stringing together multiple 
conditional statements using AND and OR.

You can include multiple WHEN statements, as well as 
an ELSE statement again, to deal with any unaddressed 
conditions.
*/



/*
1. Write a query to display for each order, the account 
ID, total amount of the order, and the level of the 
order - ‘Large’ or ’Small’ - depending on if the order 
is $3000 or more, or smaller than $3000.
*/

SELECT o.account_id, o.total_amt_usd, 
	CASE WHEN o.total_amt_usd >= 3000 
		THEN 'Large' ELSE 'Small' END AS Level
FROM orders o;


/*
2. Write a query to display the number of orders in 
each of three categories, based on the total number of 
items in each order. The three categories are: 
'At Least 2000', 'Between 1000 and 2000' and 
'Less than 1000'.
*/

SELECT CASE 
			WHEN o.total >= 2000 THEN 'At Least 2000'
			WHEN o.total >= 1000 AND o.total < 2000 
				THEN 'Between 1000 and 2000'
			WHEN o.total < 1000 THEN 'Less than 1000'
	    END AS Order_Category, 
		COUNT(*) as total_orders
FROM orders o
GROUP BY 1;


/*
3. We would like to understand 3 different levels of 
customers based on the amount associated with their 
purchases. The top level includes anyone with a 
Lifetime Value (total sales of all orders) greater than 
200,000 usd. The second level is between 200,000 and 
100,000 usd. The lowest level is anyone under 100,000
usd. Provide a table that includes the level associated 
with each account. You should provide the account name, 
the total sales of all orders for the customer, and the 
level. Order with the top spending customers listed 
first.
*/

SELECT a.name, SUM(o.total_amt_usd) as total_sales,
       CASE
           WHEN SUM(o.total_amt_usd) > 200000 
               THEN 'TOP'
           WHEN SUM(o.total_amt_usd) >= 100000 AND
               SUM(o.total_amt_usd) <= 200000 
               THEN 'MIDDLE'
           WHEN SUM(o.total_amt_usd) < 100000 
               THEN 'LOWEST'
       END AS Level_Account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


/*
4. We would now like to perform a similar calculation 
to the first, but we want to obtain the total amount 
spent by customers only in 2016 and 2017. Keep the same 
levels as in the previous question. Order with the top 
spending customers listed first.
*/

SELECT a.name, SUM(o.total_amt_usd) as total_sales,
       CASE
           WHEN SUM(o.total_amt_usd) > 200000 
               THEN 'TOP'
           WHEN SUM(o.total_amt_usd) >= 100000 AND
               SUM(o.total_amt_usd) <= 200000 
               THEN 'MIDDLE'
           WHEN SUM(o.total_amt_usd) < 100000 
               THEN 'LOWEST'
       END AS Level_Account
FROM accounts a
JOIN orders o
ON a.id = o.account_id AND 
    o.occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;


/*
5. We would like to identify top performing sales reps, 
which are sales reps associated with more than 200 
orders. Create a table with the sales rep name, the 
total number of orders, and a column with top or not 
depending on if they have more than 200 orders. Place 
the top sales people first in your final table.
*/

SELECT s.name, COUNT(*) total_orders,
       CASE
           WHEN COUNT(*) > 200 THEN 'TOP' ELSE 'NOT TOP'
       END AS Level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


/*
6. The previous didn't account for the middle, nor the 
dollar amount associated with the sales. Management 
decides they want to see these characteristics 
represented as well. We would like to identify top 
performing sales reps, which are sales reps associated 
with more than 200 orders or more than 750000 in total 
sales. The middle group has any rep with more than 150 
orders or 500000 in sales. Create a table with the 
sales rep name, the total number of orders, total 
sales across all orders, and a column with top, middle, 
or low depending on this criteria. Place the top sales 
people based on dollar amount of sales first in your 
final table. You might see a few upset sales people by 
this criteria!
*/

SELECT s.name, COUNT(*) total_orders, 
       SUM(o.total_amt_usd) total_amt,
       CASE
           WHEN COUNT(*) > 200 OR 
                    SUM(o.total_amt_usd) > 750000
               THEN 'TOP'
           WHEN COUNT(*) > 150
               OR SUM(o.total_amt_usd) > 500000
               THEN 'MIDDLE'
           ELSE 'LOW'
       END AS Level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;




### Subqueries and temporary tables

/*
Both subqueries and table expressions are methods for 
being able to write a query that creates a table, and 
then write a query that interacts with this newly 
created table. Sometimes the question you are trying to 
answer doesn't have an answer when working directly 
with existing tables in database.
*/


/*
1. On which day-channel pair did the most events occur.
*/

SELECT DATE_TRUNC('day', w.occurred_at) as day, 
w.channel, COUNT(*) event_count
FROM web_events w
GROUP BY 1, 2
ORDER BY 3 desc;

# January 1 2017; direct
# Decemeber 21 2016; direct


/*
2. Mark all of the below that are true regarding 
writing your subquery.
*/

# a. The original query goes in the FROM statement.
# b. A * is used to pull all the data from the original
	# query
#c. Ypu must use an alias for the table you nest within
	# the outer query


/*
3. Match each channel to its corresponding average 
number of events per day.
*/


SELECT channel, AVG(event_count)
FROM
	(
	SELECT DATE_TRUNC('day', occurred_at) as day, 
	channel, COUNT(*) event_count
	FROM web_events 
	GROUP BY 1, 2
	) inner_query

GROUP BY 1
ORDER BY 2 DESC;


# direct - 4.90
# facebook - 1.60
# organic - 1.67
# twitter - 1.32




# Subqueries and temporary tables II

/*
Note that you should not include an alias when you 
write a subquery in a conditional statement. This is 
because the subquery is treated as an individual value 
(or set of values in the IN case) rather than as a 
table.

Also, notice the query here compared a single value. If 
we returned an entire column IN would need to be used 
to perform a logical argument. If we are returning an 
entire table, then we must use an ALIAS for the table, 
and perform additional logic on the entire table.
*/


/*
1. What was the month/year combo for the first order 
placed?
*/

SELECT MIN(occurred_at) as first_order_date
FROM orders;

/*
2. Match each value to the corresponding description.
*/

/*
a. The average amount of standard paper sold on the 
first month that any order was placed in the orders 
table (in terms of quantity).
*/

SELECT AVG(standard_qty) AS first_month_standard_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);

/*
b. The average amount of gloss paper sold on the first 
month that any order was placed in the orders table 
(in terms of quantity).
*/

SELECT AVG(gloss_qty) AS first_month_gloss_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);


/*
c. The average amount of poster paper sold on the first 
month that any order was placed in the orders table 
(in terms of quantity).
*/

SELECT AVG(poster_qty) AS first_month_poster_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);



/*
d. The total amount spent on all orders on the first 
month that any order was placed in the orders table 
(in terms of usd).
*/

SELECT SUM(total_amt_usd) AS first_month_sales
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);


/*
OR a, b, c & d together can be written as
*/

SELECT AVG(standard_qty) AS first_month_std_qty,
	   AVG(gloss_qty) AS first_month_gloss_qty,
	   AVG(poster_qty) AS first_month_poster_qty,
	   SUM(total_amt_usd) AS first_month_sales
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);




### More Subquery Questions

/*
1. Provide the name of the sales_rep in each region 
with the largest amount of total_amt_usd sales.
*/

SELECT t2.sname, t1.max_total
FROM (SELECT rname, MAX(total) as max_total
	  FROM (SELECT r.name rname, s.name sname, 
	   		SUM(o.total_amt_usd) total
			FROM orders o
			JOIN accounts a
			ON a.id = o.account_id
			JOIN sales_reps s
			ON a.sales_rep_id = s.id
			JOIN region r
			ON s.region_id = r.id
			GROUP BY 1, 2
			) sub
	   GROUP BY 1
	   ) t1
JOIN   (SELECT r.name rname, s.name sname, 
	    SUM(o.total_amt_usd) total
	    FROM orders o
		JOIN accounts a
		ON a.id = o.account_id
		JOIN sales_reps s
		ON a.sales_rep_id = s.id
		JOIN region r
		ON s.region_id = r.id
		GROUP BY 1, 2
	    ) t2
ON t1.max_total = t2.total and t1.rname = t2.rname;


/*
2. For the region with the largest (sum) of sales 
total_amt_usd, how many total (count) orders were 
placed?
*/

SELECT r.name, COUNT(o.id)
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name = (SELECT rname 
	FROM  (SELECT r.name rname, SUM(o.total_amt_usd) total_region
			FROM orders o
			JOIN accounts a
			ON a.id = o.account_id
			JOIN sales_reps s
			ON a.sales_rep_id = s.id
			JOIN region r
			ON s.region_id = r.id
			GROUP BY 1
			ORDER BY 2 DESC
		   ) t1
	LIMIT 1
	)
GROUP BY 1

/*
3. How many accounts had more total purchases than the 
account name which has bought the most standard_qty 
paper throughout their lifetime as a customer?
*/

SELECT COUNT(*) 
FROM
	(SELECT a.name aname, SUM(o.total) total_qty
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > 
		(SELECT total_qty
		FROM 
			(SELECT a.name aname, 
				SUM(o.standard_qty) std_qty,
				SUM(o.total) total_qty
			FROM orders o
			JOIN accounts a
			ON a.id = o.account_id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1) t1
		)
	) t3

/*
4. For the customer that spent the most (in total over 
their lifetime as a customer) total_amt_usd, how many 
web_events did they have for each channel?
*/

SELECT w.channel, COUNT(*)
FROM web_events w
JOIN accounts a
ON a.id = w.account_id and a.name = (SELECT aname
FROM
	(SELECT a.name aname, SUM(total_amt_usd) total_spent
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1) t1
)
GROUP BY 1
ORDER BY 2 DESC


/*
5. What is the lifetime average amount spent in terms 
of total_amt_usd for the top 10 total spending 
accounts?
*/

SELECT AVG(total_spent)
FROM (SELECT a.name aname, SUM(o.total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10) t1


/*
6. What is the lifetime average amount spent in terms 
of total_amt_usd, including only the companies that 
spent more per order, on average, than the average of 
all orders.
*/

SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > 
    (SELECT AVG(o.total_amt_usd) avg_all
           FROM orders o)) temp_table;




## SQL Data Cleaning


### LEFT and RIGHT


/*
1. In the accounts table, there is a column holding the
website for each company. The last three digits specify
what type of web address they are using. A list of 
extensions (and pricing) is provided here. Pull these 
extensions and provide how many of each website type 
exist in the accounts table.
*/

SELECT RIGHT(website, 3), COUNT(*) AS counts
FROM accounts
GROUP BY 1
ORDER BY 2 DESC


/*
2. There is much debate about how much the name (or 
even the first letter of a company name) matters. Use 
the accounts table to pull the first letter of each 
company name to see the distribution of company names 
that begin with each letter (or number).
*/

SELECT LEFT(name, 1), COUNT(*) AS frequency
FROM accounts
GROUP BY 1
ORDER BY 2 DESC


/*
3. Use the accounts table and a CASE statement to 
create two groups: one group of company names that 
start with a number and a second group of those company
names that start with a letter. What proportion of 
company names start with a letter? 
*/

SELECT
	CASE 
		WHEN LEFT(name, 1) IN 
			('0', '1', '2', '3', '4', '5', '6', '7', 
				'8', '9') THEN 'Digit'
    	ELSE 'Letter' 
    END AS group, COUNT(*) frequency
FROM accounts
GROUP BY 1
ORDER BY 2 DESC

/*
4. Consider vowels as a, e, i, o, and u. What 
proportion of company names start with a vowel, and 
what percent start with anything else?
*/

SELECT 
	CASE 
		WHEN LEFT(name, 1) IN 
			('A', 'E', 'I', 'O', 'U') THEN 'Vowel'
        ELSE 'Other' 
    END AS group, COUNT(*) frequency
FROM accounts
GROUP BY 1
ORDER BY 2 DESC



## STRPOS, POSITION, LOWER and UPPER


/*
In this lesson, you learned about:
	1. POSITION
	2. STRPOS
	3. LOWER
	4. UPPER

- POSITION takes a character and a column, and provides 
the index where that character is for each row. The 
index of the first position is 1 in SQL. If you come 
rom another programming language, many begin indexing 
at 0. Here, you saw that you can pull the index of a 
comma as POSITION(',' IN city_state).

- STRPOS provides the same result as POSITION, but the 
syntax for achieving those results is a bit different 
as shown here: STRPOS(city_state, ',').

- Note, both POSITION and STRPOS are case sensitive, 
so looking for A is different than looking for a.

- Therefore, if you want to pull an index regardless of 
the case of a letter, you might want to use LOWER or 
UPPER to make all of the characters lower or uppercase.
*/


/*
1. Use the accounts table to create first and last 
name columns that hold the first and last names for 
the primary_poc.
*/

# STRPOS(primary_poc, ' ')

SELECT primary_poc, 
	   LEFT(primary_poc, pos_space) AS firstName,
	   RIGHT(primary_poc, len - pos_space) AS lastName
FROM 
	(SELECT POSITION(' ' IN primary_poc) AS pos_space, 
		LENGTH(primary_poc) AS len, primary_poc
      FROM accounts) AS t1


/*
2. Now see if you can do the same thing for every rep 
name in the sales_reps table. Again provide first and 
last name columns.
*/

# STRPOS(name, ' ')

SELECT name, LEFT(name, pos_space) AS firstName,
	RIGHT(name, len - pos_space)  lastName
FROM 
	(SELECT POSITION(' ' IN name) AS pos_space, 
		LENGTH(name) AS len, name
      FROM sales_reps) AS t1



### CONCAT

/*
In this lesson you learned about:

	1. CONCAT
	2. Piping ||

- Each of these will allow you to combine columns 
together across rows. In this video, you saw how first 
and last names stored in separate columns could be 
combined together to create a full name: 
CONCAT(first_name, ' ', last_name) or with piping as 
first_name || ' ' || last_name.
*/


/*
1. Each company in the accounts table wants to create 
an email address for each primary_poc. The email 
address should be the first name of the primary_poc '.' 
last name primary_poc @ company name .com.
*/

SELECT primary_poc, name, 
	   LOWER(CONCAT(firstName, '.', lastName, 
	   	'@', name, '.com')) AS email
FROM
(SELECT SPLIT_PART(primary_poc, ' ', 1) AS firstName,
		SPLIT_PART(primary_poc, ' ', 2) AS lastName,
        name,
 		primary_poc
from accounts) AS t1


/*
2. You may have noticed that in the previous solution 
some of the company names include spaces, which will 
certainly not work in an email address. See if you can 
create an email address that will work by removing all 
of the spaces in the account name, but otherwise your 
solution should be just as in question 1. Some helpful 
documentation is here.
*/

SELECT primary_poc, name, LOWER(CONCAT(firstName, '.', lastName, '@', REPLACE(name, ' ', ''), '.com'))
FROM
(SELECT SPLIT_PART(primary_poc, ' ', 1) AS firstName,
		SPLIT_PART(primary_poc, ' ', 2) AS lastName,
        name,
 		primary_poc
from accounts) AS t1


/*
3. We would also like to create an initial password, 
which they will change after their first log in. The 
first password will be the first letter of the 
primary_poc's first name (lowercase), then the last 
letter of their first name (lowercase), the first 
letter of their last name (lowercase), the last letter 
of their last name (lowercase), the number of letters 
in their first name, the number of letters in their 
last name, and then the name of the company they are 
working with, all capitalized with no spaces.
*/

SELECT primary_poc, name, 
	    CONCAT(LOWER(LEFT(firstName, 1)),
			LOWER(RIGHT(firstName, 1)),
			LOWER(LEFT(lastName, 1)),
			LOWER(RIGHT(lastName, 1)),
			LENGTH(firstName),
			LENGTH(lastName),
			UPPER(REPLACE(name, ' ', ''))
		)
FROM
(SELECT SPLIT_PART(primary_poc, ' ', 1) AS firstName,
		SPLIT_PART(primary_poc, ' ', 2) AS lastName,
        name,
 		primary_poc
from accounts) AS t1



### CASt

/*
In this video, you saw additional functionality for 
working with dates including:

	1. TO_DATE
	2. CAST
	3. Casting with ::

DATE_PART('month', TO_DATE(month, 'month')) here 
changed a month name into the number associated with 
that particular month.

Then you can change a string to a date using CAST. 
CAST is actually useful to change lots of column types.
Commonly you might be doing as you saw here, where you 
change a string to a date using CAST(date_column AS 
DATE). However, you might want to make other changes 
to your columns in terms of their data types. You can 
see other examples here.

In this example, you also saw that instead of 
CAST(date_column AS DATE), you can use 
date_column::DATE.
*/


/*
1. Change the date into correct format
*/

SELECT (year || '-' || month  || '-' || day)::date
FROM
	(SELECT SPLIT_PART(date, '/', 1) AS month, 
		SPLIT_PART(date, '/', 2) AS day,
        LEFT(SPLIT_PART(date, '/', 3), 4) AS year
from sf_crime_data) as t1


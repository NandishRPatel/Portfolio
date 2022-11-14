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

-- OR -- BETTER WAY USING WINDOW FUNCTION

SELECT sname, rname, sales
FROM (
  SELECT s.name sname, r.name rname, 
         SUM(o.total_amt_usd) sales, 
         RANK() OVER(
         	PARTITION BY r.name 
         	ORDER BY SUM(o.total_amt_usd) DESC
         	) AS ranks
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  JOIN sales_reps s
  ON s.id = a.sales_rep_id
  JOIN region r
  ON s.region_id = r.id
  GROUP BY 1, 2
) AS subq
WHERE ranks = 1;


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

-- OR -- Better way

SELECT r.name rname, SUM(o.total_amt_usd) total_sales, 
	   COUNT(o.id) order_count
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


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


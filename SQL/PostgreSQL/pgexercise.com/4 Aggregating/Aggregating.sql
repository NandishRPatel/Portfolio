# Question 1

/* 
For our first foray into aggregates, we're going to stick to something 
simple. We want to know how many facilities exist - simply produce a 
total count.
*/

SELECT COUNT(*) FROM cd.facilities;

# Question 2

/* 
Produce a count of the number of facilities that have a cost to guests 
of 10 or more.
*/

SELECT COUNT(*) FROM cd.facilities
WHERE guestcost > 10;

# Question 3

/* 
Produce a count of the number of recommendations each 
member has made. Order by member ID.
*/

SELECT m.recommendedby, COUNT(*)
FROM cd.members m
WHERE m.recommendedby IS NOT NULL
GROUP BY 1
ORDER BY 1;

# Question 4

/* 
Produce a list of the total number of slots booked 
per facility. For now, just produce an output table 
consisting of facility id and slots, sorted by 
facility id.
*/

SELECT b.facid, SUM(b.slots)
FROM cd.bookings b
GROUP BY 1
ORDER BY 1;

# Question 5

/*
Produce a list of the total number of slots booked 
per facility in the month of September 2012. Produce 
an output table consisting of facility id and slots, 
sorted by the number of slots.
*/

SELECT b.facid, SUM(b.slots) Total_Slots
FROM cd.bookings b
WHERE to_char(b.starttime, 'YYYY-MM') = '2012-09'
GROUP BY 1
ORDER BY 2;

# Question 6

/*
Produce a list of the total number of slots booked 
per facility per month in the year of 2012. Produce 
an output table consisting of facility id and slots, 
sorted by the id and month.
*/

SELECT b.facid, DATE_PART('month', b.starttime) AS month, SUM(b.slots) Total_Slots
FROM cd.bookings b
WHERE to_char(b.starttime, 'YYYY') = '2012'
GROUP BY 1, 2
ORDER BY 1, 2;

# Question 7

/*
Find the total number of members (including guests) 
who have made at least one booking.
*/

SELECT COUNT( DISTINCT memid) FROM cd.bookings;

# Question 8

/*
Produce a list of facilities with more than 1000 
slots booked. Produce an output table consisting of 
facility id and slots, sorted by facility id.
*/

SELECT b.facid, SUM(b.slots) TotalSlots
FROM cd.bookings b
GROUP BY 1
HAVING SUM(b.slots) > 1000
ORDER BY 1

# Question 9

/*
Produce a list of facilities along with their total 
revenue. The output table should consist of facility 
name and revenue, sorted by revenue. Remember that 
there's a different cost for guests and members!
*/

SELECT name, SUM(cost) revenue 
FROM
(SELECT f.name, 
    CASE 
    WHEN b.memid = 0 THEN b.slots * f.guestcost
    ELSE b.slots * f.membercost
    END as cost
FROM cd.bookings b
JOIN cd.facilities f
ON b.facid = f.facid
) sub
GROUP BY 1
ORDER BY 2;


# Question 10

/*
Produce a list of facilities with a total revenue 
less than 1000. Produce an output table consisting 
of facility name and revenue, sorted by revenue. 
Remember that there's a different cost for guests 
and members!
*/

SELECT name, SUM(cost) revenue 
FROM
(SELECT f.name, 
    CASE 
    WHEN b.memid = 0 THEN b.slots * f.guestcost
    ELSE b.slots * f.membercost
    END as cost
FROM cd.bookings b
JOIN cd.facilities f
ON b.facid = f.facid
) sub
GROUP BY 1
HAVING SUM(cost) < 1000
ORDER BY 2;

# Question 11

/*
Output the facility id that has the highest number 
of slots booked.
*/

SELECT b.facid, SUM(b.slots) total
FROM cd.bookings b
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

# Question 12

/*
Produce a list of the total number of slots booked 
per facility per month in the year of 2012. In this 
version, include output rows containing totals for 
all months per facility, and a total for all months 
for all facilities. The output table should consist 
of facility id, month and slots, sorted by the id 
and month. When calculating the aggregated values 
for all months and all facids, return null values in 
the month and facid columns.
*/

SELECT b.facid, DATE_PART('month', b.starttime) AS month, SUM(slots) slots
FROM cd.bookings b
WHERE DATE_PART('year', b.starttime) = '2012'
GROUP BY ROLLUP(1, 2)
ORDER BY 1, 2;

# Question 13

/*
Produce a list of the total number of hours booked 
per facility, remembering that a slot lasts half an 
hour. The output table should consist of the facility 
id, name, and hours booked, sorted by facility id. 
Try formatting the hours to two decimal places.
*/

SELECT f.facid, f.name, ROUND(SUM(b.slots) * 0.5, 2) AS "Total Hours"
FROM cd.bookings b
JOIN cd.facilities f
ON b.facid = f.facid
GROUP BY 1, 2
ORDER BY 1;


# Question 14

/*
Produce a list of each member name, id, and their 
first booking after September 1st 2012. Order by 
member ID.
*/

SELECT m.surname, m.firstname, m.memid, MIN(b.starttime)
FROM cd.members m
JOIN cd.bookings b
ON m.memid = b.memid AND b.starttime > '2012-09-01'
GROUP BY 1,2,3
ORDER BY 3;


# Question 15

/*
Produce a list of facilities with a total revenue 
less than 1000. Produce an output table consisting 
of facility name and revenue, sorted by revenue. 
Remember that there's a different cost for guests 
and members!
*/

select count(*) over(),
  firstname, surname
  from cd.members

/*---OR---*/

select (select count(*) from cd.members) as cnt, 
       firstname, surname
  from cd.members
order by joindate

# Question 16

/*
Produce a monotonically increasing numbered list of 
members (including guests), ordered by their date of 
joining. Remember that member IDs are not guaranteed 
to be sequential.
*/

SELECT COUNT(*) OVER(ORDER BY joindate), firstname, 
       surname
FROM cd.members;

/*---OR---*/

SELECT ROW_NUMBER(*) OVER(ORDER BY joindate), 
       firstname, surname
FROM cd.members;

# Question 17

/*
Output the facility id that has the highest number 
of slots booked. Ensure that in the event of a tie, 
all tieing results get output.
*/

SELECT facid, total 
FROM (
  SELECT facid, SUM(slots) total, RANK() OVER(ORDER BY SUM(slots) DESC) AS rank
FROM cd.bookings
GROUP BY 1
  ) AS ranked
WHERE rank = 1;
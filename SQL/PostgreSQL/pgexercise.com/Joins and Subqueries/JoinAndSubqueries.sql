# Question 1

/* 
How can you produce a list of the start times for bookings by members 
named 'David Farrell'?
*/

SELECT b.starttime
FROM cd.bookings b
JOIN cd.members m
ON b.memid = m.memid AND (m.firstname = 'David' AND m.surname = 'Farrell');

# Question 2

/* 
How can you produce a list of the start times for bookings for tennis 
courts, for the date '2012-09-21'? Return a list of start time and 
facility name pairings, ordered by the time.
*/

SELECT b.starttime, f.name
FROM cd.bookings b
JOIN cd.facilities f
ON b.facid = f.facid
WHERE DATE(b.starttime) = '2012-09-21' AND f.name LIKE '%Tennis Court%'
ORDER BY 1, 2;

# Question 3

/* 
How can you output a list of all members who have recommended another 
member? Ensure that there are no duplicates in the list, and that results 
are ordered by (surname, firstname).
*/

SELECT DISTINCT r.firstname as firstname, r.surname as surname
FROM cd.members m
INNER JOIN cd.members r
ON r.memid = m.recommendedby
ORDER BY 2, 1;    


# Question 4

/* 
How can you output a list of all members, including the individual who 
recommended them (if any)? Ensure that results are ordered by 
(surname, firstname).
*/

SELECT mem.firstname memfname, mem.surname memsname, rec.firstname recfname, 
	   rec.surname recsname
FROM cd.members mem
LEFT OUTER JOIN cd.members rec
ON rec.memid = mem.recommendedby
ORDER BY 2, 1;

# Question 5

/*
How can you produce a list of all members who have used a tennis court? 
Include in your output the name of the court, and the name of the member 
formatted as a single column. Ensure no duplicate data, and order by the 
member name followed by the facility name.
*/

SELECT DISTINCT CONCAT(mem.firstname, ' ', mem.surname) member, fac.name facility
FROM cd.members mem
JOIN cd.bookings book
ON mem.memid = book.memid
JOIN cd.facilities fac
ON book.facid = fac.facid AND fac.name LIKE '%Tennis Court%'
ORDER BY 1, 2;

# Question 6

/*
How can you retrieve the details of facilities with ID 1 and 5? Try to do 
it without using the OR operator.
*/

SELECT *
FROM cd.facilities
WHERE facid IN (1,5)


# Question 7

/*
How can you produce a list of facilities, with each labelled as 'cheap' or 
'expensive' depending on if their monthly maintenance cost is more than $100?
Return the name and monthly maintenance of the facilities in question.
*/

SELECT name, 
			CASE 
				WHEN monthlymaintenance > 100 THEN 'expensive'
				WHEN monthlymaintenance < 100 THEN 'cheap'
			END AS cost
FROM cd.facilities


# Question 8

/*
How can you produce a list of members who joined after the start of 
September 2012? Return the memid, surname, firstname, and joindate of the 
members in question.
*/

SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate > '2012-09-01'


# Question 9

/*
How can you produce an ordered list of the first 10 surnames in the members 
table? The list must not contain duplicates.
*/

SELECT DISTINCT(surname)
FROM cd.members
ORDER BY surname
LIMIT 10


# Question 10

/*
You, for some reason, want a combined list of all surnames and all facility 
names. Yes, this is a contrived example :-). Produce that list!
*/

SELECT * 
FROM (
	SELECT name FROM cd.facilities
	UNION
	SELECT surname AS name FROM cd.members
	) sub


# Question 11

/*
You'd like to get the signup date of your last member. How can you retrieve 
this information?
*/

SELECT MAX(joindate) AS latest
FROM cd.members;


# Question 12

/*
You'd like to get the first and last name of the last member(s) who signed 
up - not just the date. How can you do that?
*/

SELECT firstname, surname, joindate
FROM cd.members
ORDER BY 3 DESC
LIMIT 1;
# Question 1

/*
Find the upward recommendation chain for member ID 27: 
that is, the member who recommended them, and the 
member who recommended that member, and so on. Return 
member ID, first name, and surname. Order by 
descending member id.
*/

WITH RECURSIVE rec_query(recommender) AS(
  SELECT recommendedby
  FROM cd.members
  WHERE memid = 27
  
  UNION ALL
  
  SELECT m.recommendedby
  FROM cd.members m
  JOIN rec_query r
  ON m.memid = r.recommender
)

SELECT r.recommender, m.firstname, m.surname
FROM rec_query r
JOIN cd.members m
ON r.recommender = m.memid
ORDER BY m.memid DESC;


# Question 2

/*
*/


# Question 3

/*
*/


# Question 4

/*
*/
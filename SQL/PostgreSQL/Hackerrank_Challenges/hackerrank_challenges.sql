## 1. Asian Population

/*
URL - https://www.hackerrank.com/challenges/asian-population/problem

Given the CITY and COUNTRY tables, query the sum of the 
populations of all cities where the CONTINENT is 'Asia'.

Note: CITY.CountryCode and COUNTRY.Code are matching key 
columns.
*/


SELECT SUM(ci.POPULATION) total_pop
FROM COUNTRY co
JOIN CITY ci
ON ci.COUNTRYCODE = co.CODE
WHERE co.CONTINENT = 'Asia';


## 2. African Cities

/*
URL - https://www.hackerrank.com/challenges/african-cities/problem

Given the CITY and COUNTRY tables, query the names of all 
cities where the CONTINENT is 'Africa'.

Note: CITY.CountryCode and COUNTRY.Code are matching key 
columns.
*/


SELECT ci.NAME
FROM COUNTRY co
JOIN CITY ci
ON ci.COUNTRYCODE = co.CODE
WHERE co.CONTINENT = 'Africa';


## 3. Average Population of Each Continent

/*
URL - https://www.hackerrank.com/challenges/average-population-of-each-continent/problem

Given the CITY and COUNTRY tables, query the names of all
the continents (COUNTRY.Continent) and their respective 
average city populations (CITY.Population) rounded down 
to the nearest integer.

Note: CITY.CountryCode and COUNTRY.Code are matching key 
columns.
*/


SELECT co.CONTINENT, floor(AVG(ci.POPULATION))
FROM COUNTRY co
JOIN CITY ci
ON ci.COUNTRYCODE = co.CODE
GROUP BY co.CONTINENT;


## 4. The Report

/*
URL - https://www.hackerrank.com/challenges/the-report/problem

You are given two tables: Students and Grades. Students 
contains three columns ID, Name and Marks.

Grade has : Grade, Min_Mark, Max_Mark

Ketty gives Eve a task to generate a report containing 
three columns: Name, Grade and Mark. Ketty doesn't want
the NAMES of those students who received a grade lower 
than 8. The report must be in descending order by grade 
-- i.e. higher grades are entered first. If there is 
more than one student with the same grade (8-10) assigned 
to them, order those particular students by their name 
alphabetically. Finally, if the grade is lower than 8, 
use "NULL" as their name and list them by their grades 
in descending order. If there is more than one student 
with the same grade (1-7) assigned to them, order those 
particular students by their marks in ascending order.
*/


SELECT IF(GRADE < 8, NULL, s.Name), g.Grade, s.Marks
FROM Students s
JOIN Grades g
WHERE s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
ORDER BY g.Grade DESC, s.Name;


## 5. Top Competitors

/*
URL - https://www.hackerrank.com/challenges/full-score/problem

Julia just finished conducting a coding contest, and she
needs your help assembling the leaderboard! Write a 
query to print the respective hacker_id and name of 
hackers who achieved full scores for more than one 
challenge. Order your output in descending order by the
total number of challenges in which the hacker earned a
full score. If more than one hacker received full scores
in same number of challenges, then sort them by 
ascending hacker_id.
*/


SELECT h.hacker_id, h.name
FROM Hackers h
JOIN Submissions s
ON h.hacker_id = s.hacker_id
JOIN Challenges c
ON s.challenge_id = c.challenge_id
JOIN Difficulty d
ON c.difficulty_level = d.difficulty_level
WHERE s.score = d.score
GROUP BY 1, 2
HAVING COUNT(1) > 1
ORDER BY COUNT(1) DESC, 1; 


## 6. Contest Leaderboard

/*
URL - https://www.hackerrank.com/challenges/contest-leaderboard/problem

The total score of a hacker is the sum of their 
maximum scores for all of the challenges. Write 
a query to print the hacker_id, name, and total 
score of the hackers ordered by the descending 
score. If more than one hacker achieved the same 
total score, then sort the result by ascending 
hacker_id. Exclude all hackers with a total score 
of  from your result.
*/


SELECT h.hacker_id, h.name, t_sum_max_score.total_score
FROM

(
    SELECT hacker_id, SUM(max_score) AS total_score
    FROM
    (
        SELECT s.hacker_id, s.challenge_id, MAX(s.score) max_score
        FROM submissions s
        GROUP BY 1, 2
    ) AS t_max_score
    GROUP BY 1
    HAVING SUM(max_score) > 0
) AS t_sum_max_score

JOIN hackers h
	ON t_sum_max_score.hacker_id = h.hacker_id

GROUP BY 1, 2
ORDER BY 3 DESC, 1;


## 6. Draw The Triangle 1

/*
URL - https://www.hackerrank.com/challenges/draw-the-triangle-1/problem

P(R) represents a pattern drawn by Julia in R rows. 
The following pattern represents P(5):

* * * * * 
* * * * 
* * * 
* * 
*
Write a query to print the pattern P(20).
*/

WITH RECURSIVE decrement_cte(num) AS
(
    SELECT 20
    
    UNION ALL
    
    SELECT d.num - 1 FROM decrement_cte d 
    WHERE d.num > 1
)

SELECT REPEAT('* ', subq.num)
FROM (SELECT num FROM decrement_cte) AS subq;

-- OR

SELECT REPEAT('*',subq.cnt)
FROM (SELECT generate_series(5, 1, -1) AS cnt) AS subq;


## 7. Ollivander's Inventory

/*
URL - https://www.hackerrank.com/challenges/harry-potter-and-wands/problem

Harry Potter and his friends are at Ollivander's with Ron, finally 
replacing Charlie's old broken wand.

Hermione decides the best way to choose is by determining the minimum 
number of gold galleons needed to buy each non-evil wand of high power 
and age. Write a query to print the id, age, coins_needed, and power 
of the wands that Ron's interested in, sorted in order of descending 
power. If more than one wand has same power, sort the result in order 
of descending age.
*/

SELECT w.id, wp.age, w.coins_needed, w.power 
FROM wands w
JOIN wands_property wp
    ON w.code = wp.code
WHERE wp.is_evil = 0 AND w.coins_needed = 
(
    SELECT MIN(w1.coins_needed)
    FROM wands w1
    JOIN wands_property wp1
    ON w1.code = wp1.code
    WHERE wp.age = wp1.age AND w.power = w1.power
)
ORDER BY power DESC, age DESC


## 8. Challenges

/*
URL - https://www.hackerrank.com/challenges/challenges/problem

Julia asked her students to create some coding challenges. Write a 
query to print the hacker_id, name, and the total number of 
challenges created by each student. Sort your results by the total 
number of challenges in descending order. If more than one student 
created the same number of challenges, then sort the result by 
hacker_id. If more than one student created the same number of 
challenges and the count is less than the maximum number of 
challenges created, then exclude those students from the result.
*/

-- VERY POOR attempt

WITH cte AS
(
    SELECT h.hacker_id, h.name, COUNT(*) AS num_challenges
    FROM hackers h
    JOIN challenges c
        ON h.hacker_id = c.hacker_id
    GROUP BY h.hacker_id, h.name
)


SELECT hacker_id, name, num_challenges
FROM cte
WHERE num_challenges = (SELECT MAX(num_challenges) FROM cte)

UNION

SELECT hacker_id, name, num_challenges
FROM
(SELECT hacker_id, name, num_challenges, COUNT(*) OVER (PARTITION BY num_challenges) cnt_cnt_challenges
FROM cte) As subq
WHERE cnt_cnt_challenges = 1
ORDER BY 3 DESC, 1

-- MUCH BETTER attempt

WITH num_challenge AS
(
    SELECT h.hacker_id, COUNT(*) AS hacker_challenges
    FROM hackers h
    JOIN challenges c
        ON h.hacker_id = c.hacker_id
    GROUP BY h.hacker_id
), 

max_challenges AS
(
    SELECT nc.hacker_id, nc.hacker_challenges,
            COUNT(*) OVER (PARTITION BY nc.hacker_challenges) AS num_num_challenges,
            MAX(nc.hacker_challenges) OVER() AS max_challenges
    FROM num_challenge nc
)

SELECT h.hacker_id, h.name, mc.hacker_challenges
FROM hackers h
JOIN max_challenges mc
    ON h.hacker_id = mc.hacker_id
WHERE mc.num_num_challenges = 1 OR 
        mc.hacker_challenges = mc.max_challenges
ORDER BY hacker_challenges DESC, hacker_id
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
FROM (SELECT generate_series(20, 1, -1) AS cnt) AS subq;


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
(
    SELECT hacker_id, name, num_challenges, 
           COUNT(*) OVER (PARTITION BY num_challenges) cnt_cnt_challenges
    FROM cte
) As subq
WHERE cnt_cnt_challenges = 1
ORDER BY num_challenges DESC, hacker_id

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


## 9. Placements

/*
URL - https://www.hackerrank.com/challenges/placements/problem

You are given three tables: Students, Friends and Packages. Students 
contains two columns: ID and Name. Friends contains two columns: ID 
and Friend_ID (ID of the ONLY best friend). Packages contains two 
columns: ID and Salary (offered salary in $ thousands per month).

*/


SELECT s.name
FROM
(
    SELECT subq1.pid, subq1.isalary, subq2.friend_id, subq2.fsalary 
    FROM (
        SELECT p.id pid, p.salary isalary
        FROM packages p
    ) AS subq1

    JOIN (
        SELECT f.id fid, f.friend_id, p.salary fsalary
        FROM friends f
        JOIN packages p
            ON f.friend_id = p.id
    ) AS subq2

        ON subq1.pid = subq2.fid
    WHERE isalary < fsalary
) AS final
JOIN students s
    ON final.pid = s.id
ORDER BY final.fsalary

## 10. SQL Project Planning

/*
URL - https://www.hackerrank.com/challenges/sql-projects/problem

Write a query to output the start and end dates 
of projects listed by the number of days it took 
to complete the project in ascending order. If 
there is more than one project that have the same 
number of completion days, then order by the 
start date of the project.
*/

SELECT subq1.start_date, subq2.end_date
FROM
(
    SELECT start_date, 
           ROW_NUMBER() OVER (ORDER BY start_date) as row_num
    FROM projects
    WHERE start_date NOT IN (SELECT end_date FROM projects)
) AS subq1

JOIN

(
    SELECT end_date, 
           ROW_NUMBER() OVER (ORDER BY end_date) as row_num
    FROM projects
    WHERE end_date NOT IN (SELECT start_date FROM projects)
) AS subq2
    
    ON subq1.row_num = subq2.row_num

ORDER BY DATEDIFF(subq2.end_date, subq1.start_date), subq1.start_date


## 11. Symmetric Pairs

/*
URL - https://www.hackerrank.com/challenges/symmetric-pairs/problem

Two pairs (X1, Y1) and (X2, Y2) are said to be 
symmetric pairs if X1 = Y2 and X2 = Y1.

Write a query to output all such symmetric pairs 
in ascending order by the value of X. List the 
rows such that X1 ≤ Y1.
*/


SELECT t1.x, t1.y
FROM functions t1
JOIN functions t2
    ON t1.x = t2.y AND t2.x = t1.y
GROUP BY t1.x, t1.y
HAVING t1.x < t1.y OR 
       (t1.x = t1.y AND COUNT(t1.x) > 1)
ORDER BY t1.x


## 12. Prime Numbers

/*
URL - https://www.hackerrank.com/challenges/symmetric-pairs/problem

Write a query to print all prime numbers less 
than or equal to . Print your result on a single 
line, and use the ampersand () character as your 
separator (instead of a space).
*/

WITH RECURSIVE numbers(num) AS 
(
    SELECT 2
    
    UNION ALL
    
    SELECT n.num + 1
    FROM numbers n
    WHERE n.num < 1000
)

SELECT GROUP_CONCAT(subq.num SEPARATOR '&')
FROM
(
    SELECT n.num
    FROM numbers n
    WHERE NOT EXISTS (
      SELECT 1 FROM numbers n1
      WHERE n.num > n1.num AND n.num % n1.num = 0
    )
)AS subq;


-- OR

SELECT seriesA.element AS primes 
FROM generate_series(2, 20, 1) AS seriesA(element)
LEFT JOIN generate_series(2, 20, 1) AS seriesB(element)
    ON seriesA.element >= POWER(seriesB.element, 2) AND
        seriesA.element % seriesB.element = 0
WHERE seriesB IS NULL;


## 13. Interviews

/*
URL - https://www.hackerrank.com/challenges/interviews/problem

Samantha interviews many candidates from 
different colleges using coding challenges and 
contests. Write a query to print the contest_id, 
hacker_id, name, and the sums of 
total_submissions, total_accepted_submissions, 
total_views, and total_unique_views for each 
contest sorted by contest_id. Exclude the contest 
from the result if all four sums are .

Note: A specific contest can be used to screen 
candidates at more than one college, but each 
college only holds  screening contest.
*/


SELECT cts.contest_id, 
       cts.hacker_id,
       cts.name,
       subq1.sum_total_submissions,
       subq1.sum_total_accepted_submissions,
       subq2.sum_total_views,
       subq2.sum_total_unique_views
FROM contests cts
JOIN  ( 
    SELECT clg.contest_id, 
           sum(sbt.total_submissions) sum_total_submissions,
           sum(sbt.total_accepted_submissions) sum_total_accepted_submissions
    FROM colleges clg
    JOIN challenges chlg 
        ON chlg.college_id  = clg.college_id
    JOIN submission_stats sbt
        ON sbt.challenge_id = chlg.challenge_id
    GROUP BY clg.contest_id
) subq1
    ON subq1.contest_id = cts.contest_id

JOIN ( 
    SELECT clg.contest_id, 
           sum(vst.total_views) sum_total_views, 
           sum(vst.total_unique_views) sum_total_unique_views
    FROM colleges clg
    JOIN challenges chlg 
        ON chlg.college_id  = clg.college_id
    JOIN view_stats vst
        ON vst.challenge_id = chlg.challenge_id
    GROUP BY clg.contest_id
) subq2
    ON subq2.contest_id = cts.contest_id
GROUP BY cts.contest_id, cts.hacker_id, cts.name
HAVING subq1.sum_total_submissions + subq2.sum_total_views > 0;


## 14. 15 Days of Learning SQL

/*
URL - https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem

Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the 
end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least  submission each day (starting on 
the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of 
submissions each day. If more than one such hacker has a maximum number of submissions, print the lowest 
hacker_id. The query should print this information for each day of the contest, sorted by the date.
*/


WITH submission_counts AS (
    SELECT submission_date, hacker_id, count(*) AS num_submissions
    FROM submissions
    GROUP BY submission_date, hacker_id
),
top_hacker_rank AS (
    SELECT submission_date, hacker_id, rank() OVER (PARTITION BY submission_date ORDER BY num_submissions DESC, hacker_id ) AS rank_top_hacker
    FROM submission_counts
),
min_max_dates AS (
    SELECT MIN(submission_date) AS min_date, MAX(submission_date) AS max_date
    FROM submissions
),
hackers_with_one_submission_each_day AS (
    SELECT submission_date, hacker_id, count(S.submission_id) AS num_submissions
    FROM submissions S
    CROSS JOIN min_max_dates M
    WHERE EXTRACT(DAY FROM submission_date - M.min_date) = 
        (SELECT COUNT(DISTINCT S2.submission_date)
        FROM submissions S2 
        WHERE S.hacker_id = S2.hacker_id AND S2.submission_date < S.submission_date)
    GROUP BY submission_date, hacker_id
),
unique_hacker_counts_each_day AS (
    SELECT submission_date, count(DISTINCT hacker_id) AS num_unique_hackers
    FROM hackers_with_one_submission_each_day
    GROUP BY submission_date
)
SELECT U.submission_date, U.num_unique_hackers, T.hacker_id, H.name
FROM unique_hacker_counts_each_day U      
INNER JOIN top_hacker_rank T ON U.submission_date = T.submission_date 
INNER JOIN hackers H ON T.hacker_id = H.hacker_id
WHERE T.rank_top_hacker = 1
ORDER BY U.submission_date;

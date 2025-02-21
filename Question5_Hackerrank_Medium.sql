/* 
   HackerRank Problem: Content Leaderboard

   Problem Statement:
   The total score of a hacker is the sum of their maximum scores for all of the challenges. 
   Write a query to print the hacker_id, name, and total score of the hackers ordered by descending score. 
   If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. 
   Exclude all hackers with a total score of 0 from your result.

   Difficulty Level: Medium

   Input Tables:

   Hackers Table:
   +-----------+-------+
   | hacker_id | name  |
   +-----------+-------+

   Submissions Table:
   +---------------+-----------+--------------+-------+
   | submission_id | hacker_id | challenge_id | score |
   +---------------+-----------+--------------+-------+

   Sample Output:
   +-----------+-------+-------------+
   | hacker_id | name  | total_score |
   +-----------+-------+-------------+

   Platform: HackerRank
   Time Taken to Solve: 5 minutes
*/

-- Solution:
;WITH CTE1 AS
(
SELECT hacker_id ,challenge_id,max(score) Max_Score_PerChallenge
FROM Submissions
GROUP BY hacker_id ,challenge_id
)
SELECT * FROM (
    SELECT
    H.hacker_id, name, SUM(Max_Score_PerChallenge) total_score
    FROM CTE1 INNER JOIN Hackers H ON CTE1.hacker_id = H.hacker_id
    GROUP BY H.hacker_id, name
   ) A 
   WHERE total_score <> 0 
   ORDER BY total_score DESC, hacker_id ASC
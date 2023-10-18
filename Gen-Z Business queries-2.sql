Use genzdataset;

-- 1. What percentage of male and female GenZ wants to go to office Every Day? 
SELECT 
    p.Gender,
    CONCAT(ROUND(SUM(CASE
                        WHEN PreferredWorkingEnvironment = 'Every Day Office Environment' THEN 1
                        ELSE 0
                    END) / COUNT(*) * 100,
                    2),
            '%') AS percentage
FROM
    personalized_info p
        JOIN
    learning_aspirations l ON l.ResponseID = p.ResponseID
GROUP BY p.Gender; 

-- 2. What percentage of GenZ's who have chosen their career im Buisiness operations are most likely to be influenced by their parents?
SELECT 
    COUNT(ResponseID) AS Total_GenZ,
    CONCAT(ROUND(SUM(CASE
                        WHEN
                            ClosestAspirationalCareer LIKE '%Business Operations%'
                                AND CareerInfluenceFactor LIKE '%Parents%'
                        THEN
                            1
                        ELSE 0
                    END) / COUNT(ResponseID) * 100,
                    2),
            '%') AS Percentage
FROM
    learning_aspirations;
    
    
    
-- 3. What percentage of Genz prefer opting for higher studies,give a gender wise approach?
    SELECT 
    p.Gender,
    CONCAT(ROUND(SUM(CASE
                        WHEN HigherEducationAbroad LIKE 'Yes%' THEN 1
                        ELSE 0
                    END) / COUNT(*) * 100,
                    2),
            '%') AS Percentage
FROM
    personalized_info p
        JOIN
    learning_aspirations l ON l.ResponseID = p.ResponseID
GROUP BY Gender;

-- 4. What Percentage of GenZ are willing & not work for a company whose mission is misaligned with their public actions or even their products?(Give gender based split)
SELECT 
    Gender,
    CONCAT(ROUND(SUM(CASE
                        WHEN MisalignedMissionLikelihood LIKE 'Will work%' THEN 1
                        ELSE 0
                    END) / COUNT(*) * 100,
                    2),
            '%') AS will_work_percentage,
    CONCAT(ROUND(SUM(CASE
                        WHEN MisalignedMissionLikelihood LIKE 'Will not work%' THEN 1
                        ELSE 0
                    END) / COUNT(*) * 100,
                    2),
            '%') AS will_not_work_percentage
FROM
    personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender
;

-- 5. What is the most suitable working environment according to female gen'Z?
SELECT 
   PreferredWorkingEnvironment AS 'Most_Preferred_Work_Environment_for_Female'
FROM
    learning_aspirations l
        JOIN
    personalized_info p ON p.ResponseID = l.ResponseID
WHERE
    Gender LIKE 'Female%'
GROUP BY PreferredWorkingEnvironment
ORDER BY COUNT(*) DESC
LIMIT 1
;

-- 6. What is the percentage of Males who expected a salary 5 years>50k and also work under Employers who appreciates learning but doesnt enables an learning environment?

SELECT 
    CONCAT(ROUND(SUM(CASE
                        WHEN
                            (ExpectedSalary5Years LIKE '50k%'
                                OR ExpectedSalary5Years LIKE '111k%'
                                OR ExpectedSalary5Years LIKE '131k%'
                                OR ExpectedSalary5Years LIKE '71k%'
                                OR ExpectedSalary5Years LIKE '91k%'
                                OR ExpectedSalary5Years LIKE '>151k%')
                                AND (m.PreferredEmployer = 'Employers who appreciates learning but doesn\'t enables an learning environment')
                        THEN
                            1
                        ELSE 0
                    END) / COUNT(*) * 100,
                    2),
            '%') AS percentage
FROM
    personalized_info p
        JOIN
    mission_aspirations mi ON mi.ResponseID = p.ResponseID
        JOIN
    manager_aspirations m ON m.ResponseID = mi.ResponseID
WHERE
    Gender LIKE 'Male%';
    
    
 --   OR
 SELECT 
    CONCAT(ROUND(SUM(CASE
                        WHEN
                            ExpectedSalary5Years IN (">151k","91k to 110k","71k to 90k","50k to 70k","131k to 150k","111k to 130k")
                                AND PreferredEmployer = "Employers who appreciates learning but doesn't enables an learning environment"
                        THEN
                            1
                        ELSE 0
                    END) / COUNT(*) * 100,
                    2),
            '%') AS percentage
FROM
    personalized_info p
        JOIN
    mission_aspirations mi ON mi.ResponseID = p.ResponseID
        JOIN
    manager_aspirations m ON m.ResponseID = mi.ResponseID
WHERE
    Gender LIKE 'Male%'; -- this code should work but not getting why it is giving output as 0
    
    
    
-- 7. Find out the correlation between gender about their PreferredWorkSetup?

SELECT 
    Gender, PreferredWorkSetup, COUNT(*) AS Frequency
FROM
    personalized_info p
        JOIN
    manager_aspirations m ON p.ResponseID = m.ResponseID
GROUP BY Gender , PreferredWorkSetup
ORDER BY Gender ,PreferredWorkSetup ;


-- 8. Calculate the total number of Female who aspire to work in thier Closest Aspirational Career and Have a No Social Impact Likelihood of "1 to 5"

SELECT 
    COUNT(*) AS Total_no_Female
FROM
    personalized_info p
        JOIN
    learning_aspirations l ON l.ResponseID = p.ResponseID
        JOIN
    mission_aspirations m ON m.ResponseID = l.ResponseID
WHERE
    Gender LIKE 'Female%'
        AND NoSocialImpactLikelihood BETWEEN 1 AND 5
;


-- 9. Retrieve the Male who are intrested in higher education abraod and have a career influence factor of "My Parents"

SELECT 
    p.ResponseID,
    p.Gender,
    HigherEducationAbroad,
    CareerInfluenceFactor
FROM
    personalized_info p
        JOIN
    learning_aspirations l ON l.ResponseID = p.ResponseID
WHERE
    p.Gender LIKE 'Male%'
        AND (HigherEducationAbroad LIKE '%Yes%'
        OR HigherEducationAbroad LIKE '%No,But%')
        AND CareerInfluenceFactor LIKE '%My parents%';
        

-- 10. Determine the percentage of gender who have a NO Social Impact Likihood of "8 to 10" among those who are interested in Higher Education Abroad
        
 SELECT 
    Gender,
    CONCAT(ROUND(SUM(CASE
                        WHEN
                            (NoSocialImpactLikelihood BETWEEN 8 AND 10)
                                AND (HigherEducationAbroad LIKE '%Yes%'
                                OR HigherEducationAbroad LIKE '%No,But%')
                        THEN
                            1
                        ELSE 0
                    END) / COUNT(*) * 100,
                    2),
            '%') AS Percentage
FROM
    personalized_info p
        JOIN
    learning_aspirations l ON l.ResponseID = p.ResponseID
        JOIN
    mission_aspirations m ON m.ResponseID = l.ResponseID
GROUP BY Gender;

-- 11. Give  a detailed split of the GenZ preferences to work with Teams , Data Should include Male,Female and Overall in counts and also the Overall in %
 
 SELECT 
    PreferredWorkSetup,
    SUM(CASE
        WHEN Gender LIKE 'Male%' THEN 1
        ELSE 0
    END) AS Male,
    SUM(CASE
        WHEN Gender LIKE 'Female%' THEN 1
        ELSE 0
    END) AS Female,
    COUNT(*) AS Overall,
    CONCAT(ROUND(COUNT(*) / (SELECT 
                            COUNT(*)
                        FROM
                            personalized_info) * 100,
                    2),
            '%') AS Overall_percentage
FROM
    personalized_info p
        JOIN
    manager_aspirations m ON m.ResponseID = p.ResponseID
WHERE
    PreferredWorkSetup LIKE '%team%'
GROUP BY PreferredWorkSetup;


-- 12. Give a detailed breakdown of "WorkLikelihood3years" for each gender

SELECT 
    WorkLikelihood3Years,
    SUM(CASE
        WHEN Gender LIKE 'Male%' THEN 1
        ELSE 0
    END) AS Male,
    SUM(CASE
        WHEN Gender LIKE 'Female%' THEN 1
        ELSE 0
    END) AS Female,
    SUM(CASE
        WHEN Gender LIKE 'Transgender%' THEN 1
        ELSE 0
    END) AS Transgender,
    COUNT(*) AS Overall,
    CONCAT(ROUND(COUNT(*) / (SELECT 
                            COUNT(*)
                        FROM
                            personalized_info) * 100,
                    2),
            '%') AS Overall_percentage
FROM
    personalized_info p
        JOIN
    manager_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY WorkLikelihood3Years;

--  13. Give a detailed breakdown of "WorkLikelihood3years" for each Country
 
SELECT 
    CurrentCountry,
    SUM(CASE
        WHEN WorkLikelihood3Years LIKE '%hard%' THEN 1
        ELSE 0
    END) AS 'This will be hard to do, but if it is the right company I would try',
    SUM(CASE
        WHEN WorkLikelihood3Years LIKE 'Will work%' THEN 1
        ELSE 0
    END) AS 'Will work for 3 years or more',
    SUM(CASE
        WHEN Gender LIKE '%crazy' THEN 1
        ELSE 0
    END) AS 'No way, 3 years with one employer is crazy',
    SUM(CASE
        WHEN Gender LIKE '%No way%' THEN 1
        ELSE 0
    END) AS 'No way',
    COUNT(*) AS Overall,
    CONCAT(ROUND(COUNT(*) / (SELECT 
                            COUNT(*)
                        FROM
                            personalized_info) * 100,
                    2),
            '%') AS Overall_percentage
FROM
    personalized_info p
        JOIN
    manager_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY CurrentCountry;


-- 14. What is the Average Starting Salary Expectations at 3 year mark for each gender
 
select Gender,
round(Avg(case WHEN ExpectedSalary3Years = '>50k' THEN 50000
            WHEN ExpectedSalary3Years = '5K to 10K' THEN 5000
            WHEN ExpectedSalary3Years = '31k to 40k' THEN 31000
            WHEN ExpectedSalary3Years = '21k to 25k' THEN 21000
            WHEN ExpectedSalary3Years = '26k to 30k' THEN 26000
            WHEN ExpectedSalary3Years = '16k to 20k' THEN 16000
            WHEN ExpectedSalary3Years = '41k to 50k' THEN 41000
            WHEN ExpectedSalary3Years = '11k to 15k' THEN 11000
            end),2)
 as "Avg ExpectedSalary3Years" from 
personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender;


-- 15. What is the Average Starting salary expectation at 5 year mark for each gender

SELECT 
    Gender,
  Round(AVG(CASE
        WHEN ExpectedSalary5Years like '>151k%' THEN 151000
        WHEN ExpectedSalary5Years like '30k to 50k%' THEN 30000
        WHEN ExpectedSalary5Years like '50k to 70k%' THEN 50000
        WHEN ExpectedSalary5Years like '71k to 90k%' THEN 71000
        WHEN ExpectedSalary5Years like '91k to 110k%' THEN 910000
        WHEN ExpectedSalary5Years like '111k to 130k%' THEN 111000
        WHEN ExpectedSalary5Years like '131k to 150k%' THEN 131000
    END),2) AS 'Avg ExpectedSalary5Years'
FROM
    personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender;


--  16. What is the Average Higher bar salary expectations at 3 year mark for each gender
select Gender,
round(Avg(case WHEN ExpectedSalary3Years = '>50k' THEN 51000
            WHEN ExpectedSalary3Years = '5K to 10K' THEN 10000
            WHEN ExpectedSalary3Years = '31k to 40k' THEN 40000
            WHEN ExpectedSalary3Years = '21k to 25k' THEN 25000
            WHEN ExpectedSalary3Years = '26k to 30k' THEN 30000
            WHEN ExpectedSalary3Years = '16k to 20k' THEN 20000
            WHEN ExpectedSalary3Years = '41k to 50k' THEN 50000
            WHEN ExpectedSalary3Years = '11k to 15k' THEN 15000
            end),2)
 as Avg_expectedSalary3Years from 
personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender;


-- 17. What is the Average Higher bar salary expectations at 5 year mark for each gender

SELECT 
    Gender,
    ROUND(AVG(CASE
                WHEN ExpectedSalary5Years LIKE '>151k%' THEN 152000
                WHEN ExpectedSalary5Years LIKE '30k to 50k%' THEN 50000
                WHEN ExpectedSalary5Years LIKE '50k to 70k%' THEN 70000
                WHEN ExpectedSalary5Years LIKE '71k to 90k%' THEN 90000
                WHEN ExpectedSalary5Years LIKE '91k to 110k%' THEN 110000
                WHEN ExpectedSalary5Years LIKE '111k to 130k%' THEN 130000
                WHEN ExpectedSalary5Years LIKE '131k to 150k%' THEN 150000
            END),
            2) AS 'Avg ExpectedSalary5Years'
FROM
    personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender;



-- 18. What is the Average Starting salary expecatations at 3 year mark for each gender and each Country 
 
SELECT 
    Gender,
    CurrentCountry as Country,
    ROUND(AVG(CASE
                WHEN ExpectedSalary3Years = '>50k' THEN 50000
                WHEN ExpectedSalary3Years = '5K to 10K' THEN 5000
                WHEN ExpectedSalary3Years = '31k to 40k' THEN 31000
                WHEN ExpectedSalary3Years = '21k to 25k' THEN 21000
                WHEN ExpectedSalary3Years = '26k to 30k' THEN 26000
                WHEN ExpectedSalary3Years = '16k to 20k' THEN 16000
                WHEN ExpectedSalary3Years = '41k to 50k' THEN 41000
                WHEN ExpectedSalary3Years = '11k to 15k' THEN 11000
            END),
            2) AS 'Avg ExpectedSalary3Years'
FROM
    personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender , CurrentCountry;



-- 19. What is the Average Starting salary expecatations at 5 year mark for each gender and each Country 
 

SELECT 
    Gender,CurrentCountry as Country,
  Round(AVG(CASE
        WHEN ExpectedSalary5Years like '>151k%' THEN 151000
        WHEN ExpectedSalary5Years like '30k to 50k%' THEN 30000
        WHEN ExpectedSalary5Years like '50k to 70k%' THEN 50000
        WHEN ExpectedSalary5Years like '71k to 90k%' THEN 71000
        WHEN ExpectedSalary5Years like '91k to 110k%' THEN 910000
        WHEN ExpectedSalary5Years like '111k to 130k%' THEN 111000
        WHEN ExpectedSalary5Years like '131k to 150k%' THEN 131000
    END),2) AS 'Avg ExpectedSalary5Years'
FROM
    personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender,CurrentCountry;


-- 20. What is the Average Higher Bar salary expecatations at 3 year mark for each gender and each Country 

select Gender,CurrentCountry as Country,
round(Avg(case WHEN ExpectedSalary3Years = '>50k' THEN 51000
            WHEN ExpectedSalary3Years = '5K to 10K' THEN 10000
            WHEN ExpectedSalary3Years = '31k to 40k' THEN 40000
            WHEN ExpectedSalary3Years = '21k to 25k' THEN 25000
            WHEN ExpectedSalary3Years = '26k to 30k' THEN 30000
            WHEN ExpectedSalary3Years = '16k to 20k' THEN 20000
            WHEN ExpectedSalary3Years = '41k to 50k' THEN 50000
            WHEN ExpectedSalary3Years = '11k to 15k' THEN 15000
            end),2)
 as Avg_expectedSalary3Years from 
personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender,CurrentCountry;

-- 21. What is the Average Higher Bar salary expecatations at 5 year mark for each gender and each Country 

SELECT 
    Gender,CurrentCountry as Country,
    ROUND(AVG(CASE
                WHEN ExpectedSalary5Years LIKE '>151k%' THEN 152000
                WHEN ExpectedSalary5Years LIKE '30k to 50k%' THEN 50000
                WHEN ExpectedSalary5Years LIKE '50k to 70k%' THEN 70000
                WHEN ExpectedSalary5Years LIKE '71k to 90k%' THEN 90000
                WHEN ExpectedSalary5Years LIKE '91k to 110k%' THEN 110000
                WHEN ExpectedSalary5Years LIKE '111k to 130k%' THEN 130000
                WHEN ExpectedSalary5Years LIKE '131k to 150k%' THEN 150000
            END),
            2) AS 'Avg ExpectedSalary5Years'
FROM
    personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY Gender,CurrentCountry;


-- 22. Give a detailed breakdown of the possibility of GenZ working for an Org if the "Mission is misaligned" for each country

SELECT 
    CurrentCountry AS Country,
    CONCAT(ROUND(SUM(CASE
                        WHEN MisalignedMissionLikelihood = 'Will work for them' THEN 1
                        ELSE 0
                    END) / COUNT(*) * 100,
                    2),
            '%') AS Possibility_MisalignedMission
FROM
    personalized_info p
        JOIN
    mission_aspirations m ON m.ResponseID = p.ResponseID
GROUP BY CurrentCountry; 


    
    
    


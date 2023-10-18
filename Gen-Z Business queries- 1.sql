Use genzdataset;
Show tables;
--  Questions:

-- 1. How many Male have responded to the survey from india
SELECT 
    COUNT(*)
FROM
    personalized_info
WHERE
    CurrentCountry = 'India'
        AND Gender LIKE 'Male%';
-- 2. How many Female have responded to the survey from india
SELECT 
    COUNT(*)
FROM
    personalized_info
WHERE
    CurrentCountry = 'India'
        AND Gender LIKE '%FeMale%';
-- 3. How many of the Gen-Z are influenced by thier parents in regards to thier career choices from India
SELECT 
    COUNT(*) 
FROM
    learning_aspirations l
     join 
    personalized_info p 
    on p.ResponseID = l.ResponseID
WHERE
   p.CurrentCountry = 'India'
        AND l.CareerInfluenceFactor like "%My parents%";
	
-- 4. How many of the Female Gen-Z are infulenced  by thier parents in regards to thier career chooices from india
SELECT 
    COUNT(*) 
FROM
    learning_aspirations l
     join 
    personalized_info p 
    on p.ResponseID = l.ResponseID
WHERE
   p.CurrentCountry = 'India'
        AND l.CareerInfluenceFactor like "%My parents%"
        AND p.Gender like "%Female%" ;
        
-- 5. How many of the male Gen-Z are infulenced  by thier parents in regards to thier career chooices from india
SELECT 
    COUNT(*) 
FROM
    learning_aspirations l
     join 
    personalized_info p 
    on p.ResponseID = l.ResponseID
WHERE
   p.CurrentCountry = 'India'
        AND l.CareerInfluenceFactor like "%My parents%"
        AND p.Gender like "Male%" ;
        
-- 6. How many of the male and female (individually display in 2 different columns , but as part of the same query) Gen-Z are influenced by their parents in regards to thier career choices from india
SELECT p.Gender,
    COUNT(*) 
FROM
    learning_aspirations l
     join 
    personalized_info p 
    on p.ResponseID = l.ResponseID
WHERE
   p.CurrentCountry = 'India'
        AND l.CareerInfluenceFactor like "%My parents%"
group by p.Gender;

-- 7. How many Gen-Z are influenced by Social Media and influencers together from India
SELECT 
    COUNT(*)
FROM
    learning_aspirations l
        JOIN
    personalized_info p ON p.ResponseID = l.ResponseID
WHERE
    p.CurrentCountry = 'India'
        AND (l.CareerInfluenceFactor LIKE '%Social Media%'
        or l.CareerInfluenceFactor LIKE '%Influencers%');
-- 8. How many Gen-Z are influenced by Social Media and Influencers together,display for Male and Female seperatly from India.
SELECT p.Gender,
    COUNT(*)
FROM
    learning_aspirations l
        JOIN
    personalized_info p ON p.ResponseID = l.ResponseID
WHERE
    p.CurrentCountry = 'India'
        AND (l.CareerInfluenceFactor LIKE '%Social Media%'
        or l.CareerInfluenceFactor LIKE '%Influencers%')
        group by p.Gender;
-- 9. How many of the Gen-Z who are influenced by the social media for thier career aspiration are looking to go abroad.
SELECT 
    COUNT(*)
FROM
    learning_aspirations 
WHERE
    CareerInfluenceFactor LIKE '%Social Media%'
        AND (HigherEducationAbroad like '%Yes%'
        OR HigherEducationAbroad like '%No,But%');
        
-- 10. How many of the Gen-Z who are influenced by " people in thier circle" for career aspiration are looking to go abroad.
SELECT 
    COUNT(*)
FROM
    learning_aspirations 
WHERE
    CareerInfluenceFactor LIKE '%People from my circle%'
        AND (HigherEducationAbroad like '%Yes%'
        OR HigherEducationAbroad like '%No,But%');


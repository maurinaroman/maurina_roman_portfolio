CREATE TABLE student_migration_cleaned AS
SELECT *
FROM student_migration;

SELECT *
FROM student_migration_cleaned
;

-- Changing Column Name
ALTER TABLE student_migration_cleaned
RENAME COLUMN `ï»¿student_id` TO `student_id`
;

-- Checking For Duplicates
SELECT *
FROM (
	SELECT *,
    ROW_NUMBER() OVER(PARTITION BY student_id ORDER BY student_id) AS row_num
FROM student_migration_cleaned) AS row_table
WHERE row_num > 1;

-- Count Placed Vs Not Placed
SELECT placement_status, COUNT(CASE WHEN placement_status = 'Placed' THEN 1
									WHEN placement_status = 'Not Placed' THEN 1 END) AS count_placed
FROM student_migration_cleaned
GROUP BY placement_status
;

-- Number of Students Per Field of Study
SELECT field_of_study, 
	COUNT(field_of_study)
FROM student_migration_cleaned
GROUP BY field_of_study
ORDER BY COUNT(field_of_study) DESC
;

-- Number of Students Placed Per Field of Study
SELECT field_of_study, COUNT(placement_status)
FROM student_migration_cleaned
WHERE placement_status = 'Placed'
GROUP BY field_of_study
ORDER BY COUNT(placement_status) DESC
;

-- Percentage of Students Placed Per Field of Study
SELECT field_of_study,
ROUND(COUNT(CASE WHEN placement_status = 'Placed' THEN 1 END)  / 
COUNT(placement_status) * 100,2) AS percentage_placed
FROM student_migration_cleaned
GROUP BY field_of_study
ORDER BY percentage_placed DESC
;

-- Number of Students Placed Per University
SELECT university_name, COUNT(CASE WHEN placement_status = 'Placed' THEN 1 END) AS num_placed
FROM student_migration_cleaned
GROUP BY university_name
ORDER BY num_placed DESC
;

-- Avg GPA Placed vs Not Placed
SELECT placement_status, ROUND(AVG(gpa_or_score), 2) AS avg_gpa
FROM student_migration_cleaned
GROUP BY placement_status
;


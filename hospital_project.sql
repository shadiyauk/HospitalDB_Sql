CREATE DATABASE hospital;
USE hospital;

SELECT * FROM admissions;
SELECT * FROM doctors;
SELECT * FROM patients;
SELECT * FROM province_names;

/* 1. Show first name, last name, and gender of patients who's gender is 'M' */
SELECT first_name, last_name, gender 
FROM patients
WHERE gender = "M";

/* 2. Show first name and last name of patients who does not have allergies. (null) */
SELECT first_name, last_name
FROM patients
WHERE allergies IS NULL;

/*3. Show first name of patients that start with the letter 'C'*/
SELECT first_name
FROM patients
WHERE first_name LIKE "c%";

/*4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)*/
SELECT first_name,last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;

/*5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'*/
UPDATE patients SET allergies = "NKA"
WHERE allergies IS NULL;

/*6. Show first name and last name concatenated into one column to show their full name.*/
SELECT first_name, last_name, CONCAT(first_name, ' ', last_name) AS full_name 
FROM patients;

/*7. Show first name, last name, and the full province name of each patient.*/
SELECT * FROM patients;
SELECT * FROM province_names;
SELECT p.first_name, p.last_name, pn.names
FROM patients as p
LEFT JOIN province_names as pn ON p.province_id = pn.province_id;

/*8. Show how many patients have a birth_date with 2010 as the birth year.*/
SELECT count(birth_date)
FROM patients
WHERE birth_date LIKE "2010%";

/*9. Show the first_name, last_name, and height of the patient with the greatest height.*/
SELECT first_name, last_name, height
FROM patients
WHERE height = (SELECT max(height) FROM patients);

/*10. Show the total number of admissions*/
SELECT count(admission_date) AS total_admn
FROM admissions;

/*11. Show all the columns from admissions where the patient was admitted and discharged on the same day.*/
SELECT * FROM admissions
WHERE admission_date = discharge_date;

/*12. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?*/
SELECT DISTINCT city 
FROM patients 
WHERE province_id = "NY";

/*13. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70*/
SELECT first_name, last_name, birth_date
FROM patients
WHERE height>160 and weight>70;

/*14. Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null*/

SELECT first_name, last_name, allergies
FROM patients
WHERE city = "Honolulu" AND allergies IS NOT NULL;

/*15. Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city.*/
SELECT DISTINCT city 
FROM patients 
WHERE city LIKE "a%" OR city LIKE "e%" OR city LIKE  "i%" OR city LIKE "o%" OR city LIKE "u%"
ORDER BY city ASC;

/*16. Show unique birth years from patients and order them by ascending.*/

SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY YEAR(birth_date) ASC;

/*17. Show unique first names from the patients table which only occurs once in the list. 
For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list.
 If only 1 person is named 'Leo' then include them in the output*/

 SELECT first_name
 FROM patients
 GROUP BY first_name
 HAVING count(first_name) =1;
 
/*18. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.*/
SELECT first_name
FROM patients
WHERE first_name LIKE "s___%h";


/*19. Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row.*/

SELECT 
(SELECT count(gender) FROM patients WHERE gender= 'M')  AS male_count,
(SELECT count(gender) FROM patients WHERE gender= 'F') AS female_count;


/*20. Show the total amount of male patients and the total amount of female patients in the patients table.
 Display the two results in the same row.*/
 SELECT 
(SELECT count(gender) FROM patients WHERE gender= 'M')  AS male_count,
(SELECT count(gender) FROM patients WHERE gender= 'F') AS female_count;
 
/*21. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.*/
SELECT city, COUNT(*) AS count_of_patients
FROM patients 
GROUP BY city 
ORDER BY count_of_patients DESC, city ASC;

/*22. Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"*/
SELECT p.first_name,p.last_name, ("Patient") AS role
FROM patients p 
UNION 
SELECT d.first_name,d.last_name, ("Doctor") AS role
FROM doctors d;

/*23. Show all allergies ordered by popularity. Remove NULL values from query.*/
SELECT DISTINCT allergies,count(*) AS allergy_count 
FROM patients 
WHERE allergies IS NOT NULL 
GROUP BY allergies 
ORDER BY allergy_count DESC;

/*24. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade.
Sort the list starting from the earliest birth_date.*/
SELECT first_name, last_name, birth_date
FROM patients
WHERE YEAR(birth_date)<1980 AND YEAR(birth_date)>=1970
ORDER BY birth_date ASC; 

/*25. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.*/
SELECT DISTINCT province_id, count(*), sum(height) as sum_of_heights
FROM patients
GROUP BY province_id
HAVING sum_of_heights>2000;

/*26. Show first_name, last_name, and the total number of admissions attended for each doctor. 
Every admission has been attended by a doctor.*/

SELECT d.doctor_id, d.first_name, d.last_name, count(a.admission_date) as total_admn
FROM doctors d
LEFT JOIN admissions a
ON d.doctor_id = a.attending_doctor_id
GROUP BY a.attending_doctor_id, d.doctor_id, d.first_name, d.last_name;


/*27. For each doctor, display their id, full name, and the first and last admission date they attended.*/
SELECT d.doctor_id, concat(d.first_name, " ",d.last_name) as full_name,
min(a.admission_date) as first_admn, max(a.admission_date) as last_admn
FROM doctors d
LEFT JOIN admissions a
ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id, full_name;

/*28. Display the total amount of patients for each province. Order by descending.*/
SELECT DISTINCT province_id, count(*) AS num_of_patients
FROM patients
GROUP BY province_id
ORDER BY num_of_patients DESC;

/*29. For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.*/
SELECT concat(p.first_name, " ", p.last_name) AS patient_name, a.diagnosis , concat(d.first_name, " ", d.last_name) AS doctor_name
FROM patients p
LEFT JOIN admissions a ON p.patient_id = a.patient_id
LEFT JOIN doctors d ON a.attending_doctor_id = d.doctor_id;

/*30. Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'.Check patients, admissions, and doctors tables for required information.*/
SELECT a.patient_id, p.first_name, p.last_name, d.speciality
FROM admissions a
LEFT JOIN doctors d ON a.attending_doctor_id =  d.doctor_id
LEFT JOIN patients p ON a.patient_id = p.patient_id
WHERE a.diagnosis LIKE "%epi%" AND d.first_name = "Lisa";

/*31. All patients who have gone through admissions, can see their medical documents on our site.  Those patients are given a 
temporary password after their first admission. Show the patient_id and temp_password. The password must be the following, in order:
patient_id
the numerical length of patient's last_name
year of patient's birth_date*/
SELECT patient_id,first_name, last_name,concat(patient_id,length(last_name),year(birth_date)) as password
FROM patients;

/*32. We need a breakdown for the total amount of admissions each doctor has started each year. 
Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.*/
SELECT * FROM admissions;
SELECT * FROM doctors;
SELECT DISTINCT a.attending_doctor_id, concat(d.first_name,d.last_name) as full_name, d.speciality, YEAR(a.admission_date) as year,
count(YEAR(a.admission_date)) as no_of_admns
FROM admissions a
LEFT JOIN doctors d ON a.attending_doctor_id = d.doctor_id
GROUP BY YEAR(a.admission_date),a.attending_doctor_id, concat(d.first_name,d.last_name), d.speciality
ORDER BY attending_doctor_id ASC;


-- 11) Отримати дані про продуктивність (середнє число прийнятих пацієнтів за день) за вказаний період для конкретного лікаря, або всіх лікарів поліклініки, або для всіх лікарів названого профілю. 

SELECT * FROM polyclinics;
SELECT * FROM accounting;
SELECT * FROM poly_cabinets;

DELIMITER // 
CREATE PROCEDURE task11 (IN doctor_name VARCHAR(100), IN doctor_category VARCHAR(100),
						 IN polyclinic_name VARCHAR(100), IN date1 DATE, IN date2 DATE)
BEGIN
    IF doctor_name != '' THEN 
		SELECT d.name, COUNT(a.patient_id) AS total_patients, COUNT(a.patient_id) / DATEDIFF(date2, date1) AS average_patients_per_day
		FROM accounting a JOIN doctors d ON a.doctor_id = d.doctor_id 
		WHERE d.name = doctor_name AND a.input_date >= date1 AND a.input_date <= date2;
	ELSEIF doctor_category != '' THEN
		SELECT d.name, d.category, COUNT(a.patient_id) AS total_patients, COUNT(a.patient_id) / DATEDIFF(date2, date1) AS average_patients_per_day
		FROM accounting a JOIN doctors d ON a.doctor_id = d.doctor_id 
		WHERE d.category = doctor_category AND a.input_date >= date1 AND a.input_date <= date2
        GROUP BY d.name;
	ELSEIF polyclinic_name != '' THEN
		SELECT d.name, d.category, p.name, COUNT(a.patient_id) AS total_patients, COUNT(a.patient_id) / DATEDIFF(date2, date1) AS average_patients_per_day
		FROM accounting a 
        JOIN doctors d ON a.doctor_id = d.doctor_id 
        JOIN polyclinics p ON a.polyclinic_name = p.name
		WHERE p.name = polyclinic_name AND a.input_date >= date1 AND a.input_date <= date2
		GROUP BY d.name;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task11;

call task11 ('Соколова М.Н.', '', '', '2023-05-18', '2023-06-20');
call task11 ('', 'хірург', '', '2023-05-18', '2023-06-20');
call task11 ('', '', 'Святовіт', '2023-05-18', '2023-06-20');


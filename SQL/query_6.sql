-- 6) Отримати перелік пацієнтів зазначеної лікарні, відділення, або конкретної палати зазначеного відділення, із зазначенням дати надходження, стану, температури, лікуючого лікаря.

SELECT * FROM hospitals;
SELECT * FROM hospital_buildings;
SELECT * FROM departments;
SELECT * FROM rooms;
SELECT * FROM polyclinics;
SELECT * FROM doctors;
SELECT * FROM doc_hospital_contracts;
SELECT * FROM doc_polyclinic_contracts;
SELECT * FROM accounting;

DELIMITER // 
CREATE PROCEDURE task6 (IN hospital_name VARCHAR(100), IN department_name VARCHAR(100), IN room_number INT)
BEGIN 
    IF hospital_name != '' AND department_name != '' AND room_number != 0 THEN 
		SELECT SQL_CALC_FOUND_ROWS p.name, a.input_date, a.feeling, a.temperature, d.name, a.hospital_name, a.department_name, a.room_number
		FROM patients p
		JOIN accounting a ON p.patient_id = a.patient_id
		JOIN doctors d ON d.doctor_id = a.doctor_id
		WHERE a.hospital_name = hospital_name AND a.department_name = department_name AND a.room_number = room_number;
    ELSEIF hospital_name != '' AND department_name != '' AND room_number = 0 THEN 
		SELECT SQL_CALC_FOUND_ROWS p.name, a.input_date, a.feeling, a.temperature, d.name
		FROM patients p
		JOIN accounting a ON p.patient_id = a.patient_id
		JOIN doctors d ON d.doctor_id = a.doctor_id
		WHERE a.hospital_name = hospital_name AND a.department_name = department_name;
	ELSEIF hospital_name != '' AND department_name = '' AND room_number = 0 THEN
		SELECT SQL_CALC_FOUND_ROWS p.name, a.input_date, a.feeling, a.temperature, d.name
		FROM patients p
		JOIN accounting a ON p.patient_id = a.patient_id
		JOIN doctors d ON d.doctor_id = a.doctor_id
		WHERE a.hospital_name = hospital_name;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task6;

call task6 ('Київська міська №1', 'Хірургія', 101);
call task6 ('Київська міська №1', 'Хірургія', 0);
call task6 ('Київська міська №1', '', 0);
SELECT found_rows();




-- 3) Отримати перелік і загальне число лікарів зазначеного профілю, які зробили число операцій не менш заданого для конкретного медичного закладу, лікарні або всіх медичних установ міста. 

SELECT * FROM hospitals;
SELECT * FROM polyclinics;
SELECT * FROM doctors;
SELECT * FROM doc_hospital_contracts;
SELECT * FROM doc_polyclinic_contracts;

DELIMITER // 
CREATE PROCEDURE task3 (IN hospital_name VARCHAR(100), IN polyclninic_name VARCHAR(100), 
IN doctor_category VARCHAR(100), IN operations_number INT)
BEGIN 
    IF hospital_name != '' THEN 
		SELECT d.doctor_id, d.name, d.category, h.name, d.operations_number
		FROM doctors d
		INNER JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
		INNER JOIN hospitals h ON dhc.hospital_id = h.hospital_id
		WHERE h.name = hospital_name AND d.category = doctor_category AND d.operations_number >= operations_number;
    ELSEIF polyclninic_name != '' THEN
		SELECT d.doctor_id, d.name, d.category, p.name, d.operations_number
		FROM doctors d
		INNER JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
		INNER JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
		WHERE p.name = polyclninic_name AND d.category = doctor_category AND d.operations_number >= operations_number;
	ELSE
		SELECT d.doctor_id, d.name, d.category, h.name, p.name, d.operations_number
		FROM doctors d
		LEFT JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
		LEFT JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
		LEFT JOIN hospitals h ON dhc.hospital_id = h.hospital_id
		LEFT JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
		WHERE d.category = doctor_category AND d.operations_number >= operations_number;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task3;

call task3 ('Київська міська №1', '', 'хірург', 10);
call task3 ('', 'Гіпократ', 'хірург', 40);
call task3 ('', '', 'хірург', 10);

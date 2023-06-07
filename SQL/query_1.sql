-- 1) Отримати перелік і загальне число лікарів зазначеного профілю для конкретного медичного закладу, лікарні або всіх медичних установ міста. 

SELECT * FROM hospitals;
SELECT * FROM polyclinics;
SELECT * FROM doctors;
SELECT * FROM doc_hospital_contracts;
SELECT * FROM doc_polyclinic_contracts;

DELIMITER // 
CREATE PROCEDURE task1 (IN hospital_name VARCHAR(100), IN polyclninic_name VARCHAR(100), 
IN doctor_category VARCHAR(100))
BEGIN 
    IF hospital_name != '' THEN 
		SELECT d.doctor_id, d.name, d.category, h.name
		FROM doctors d
		INNER JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
		INNER JOIN hospitals h ON dhc.hospital_id = h.hospital_id
		WHERE h.name = hospital_name AND d.category = doctor_category;
    ELSEIF polyclninic_name != '' THEN
		SELECT d.doctor_id, d.name, d.category, p.name
		FROM doctors d
		INNER JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
		INNER JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
		WHERE p.name = polyclninic_name AND d.category = doctor_category;
	ELSE
		SELECT d.doctor_id, d.name, d.category, h.name, p.name
		FROM doctors d
		LEFT JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
		LEFT JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
		LEFT JOIN hospitals h ON dhc.hospital_id = h.hospital_id
		LEFT JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
		WHERE d.category = doctor_category;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task1;

call task1 ('Київська міська №1', '', 'хірург');
call task1 ('', 'Гіпократ', 'хірург');
call task1 ('', '', 'хірург');


-- 8) Отримати перелік пацієнтів, що спостерігаються в лікаря зазначеного профілю в конкретній поліклініці. 

SELECT * FROM accounting;
SELECT * FROM doctors;
SELECT * FROM polyclinics;

DELIMITER // 
CREATE PROCEDURE task8 (IN doctor_category VARCHAR(100), IN polyclinic_name VARCHAR(100))
BEGIN
	SELECT SQL_CALC_FOUND_ROWS p.patient_id, p.name, d.name, d.category, pol.name
	FROM accounting a
	INNER JOIN patients p ON p.patient_id = a.patient_id
	INNER JOIN doctors d ON d.doctor_id = a.doctor_id
	INNER JOIN polyclinics pol ON pol.name = a.polyclinic_name
	WHERE d.category = doctor_category AND pol.name = polyclinic_name;
END// 
DELIMITER ;

DROP PROCEDURE task8;

call task8 ('стоматолог', 'Поліклініка +');
SELECT found_rows() as count;
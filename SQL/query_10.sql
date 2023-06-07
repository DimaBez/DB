-- 10) Отримати загальне число кабінетів зазначеної поліклініки, число відвідувань кожного кабінету за певний період. 

SELECT * FROM polyclinics;
SELECT * FROM accounting;
SELECT * FROM poly_cabinets;

DELIMITER // 
CREATE PROCEDURE task10 (IN polyclinic_name VARCHAR(100), IN input_date DATE, IN output_date DATE)
BEGIN
	SELECT 
		count(record_id) as records_count, 
		poly_cabinets.cabinet_number,
        NULL as total_cabinets
	FROM accounting
	JOIN poly_cabinets ON poly_cabinets.cabinet_number = accounting.cabinet_number
	JOIN polyclinics ON poly_cabinets.polyclinic_id = polyclinics.polyclinic_id
    WHERE polyclinics.name = polyclinic_name
    GROUP BY poly_cabinets.cabinet_number
	UNION
	SELECT 
		NULL, 
        NULL,
		count(cabinet_id) as total_cabinets
	FROM polyclinics
	JOIN poly_cabinets ON poly_cabinets.polyclinic_id = polyclinics.polyclinic_id
	WHERE polyclinics.name = polyclinic_name;
END// 
DELIMITER ;

DROP PROCEDURE task10;

call task10 ('Поліклініка +', '2023-04-18', '2023-09-20');



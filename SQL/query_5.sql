-- 5) Отримати перелік і загальне число лікарів зазначеного профілю зі ступенем кандидата або доктора медичних наук, зі званням доцента або професора для конкретного медичного закладу, або лікарні або всіх медичних установ міста. 

SELECT * FROM hospitals;
SELECT * FROM polyclinics;
SELECT * FROM doctors;
SELECT * FROM doc_hospital_contracts;
SELECT * FROM doc_polyclinic_contracts;

DELIMITER // 
CREATE PROCEDURE task5 (IN hospital_name VARCHAR(100), IN polyclninic_name VARCHAR(100), 
IN doctor_category VARCHAR(100), IN doctor_rank VARCHAR(100), IN doctor_degree VARCHAR(100))
BEGIN 
    IF hospital_name != '' THEN 
		SELECT SQL_CALC_FOUND_ROWS d.doctor_id, d.name, d.category, h.name, d.rank, d.degree
		FROM doctors d
		INNER JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
		INNER JOIN hospitals h ON dhc.hospital_id = h.hospital_id
		WHERE h.name = hospital_name AND d.category = doctor_category
        AND d.rank = doctor_rank AND d.degree = doctor_degree;
    ELSEIF polyclninic_name != '' THEN
		SELECT SQL_CALC_FOUND_ROWS d.doctor_id, d.name, d.category, p.name, d.rank, d.degree
		FROM doctors d
		INNER JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
		INNER JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
		WHERE p.name = polyclninic_name AND d.category = doctor_category
        AND d.rank = doctor_rank AND d.degree = doctor_degree;
	ELSE
		SELECT SQL_CALC_FOUND_ROWS d.doctor_id, d.name, d.category, h.name, p.name, d.rank, d.degree
		FROM doctors d
		LEFT JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
		LEFT JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
		LEFT JOIN hospitals h ON dhc.hospital_id = h.hospital_id
		LEFT JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
		WHERE d.category = doctor_category AND d.rank = doctor_rank AND d.degree = doctor_degree;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task5;

call task5 ('Київська міська №1', '', 'гінеколог', 'Професор', 'Доктор медичних наук');
call task5 ('', 'Гіпократ', 'гінеколог', 'Професор', 'Доктор медичних наук');
call task5 ('', '', 'терапевт',  'Доцент', 'Кандидат медичних наук');
SELECT found_rows();




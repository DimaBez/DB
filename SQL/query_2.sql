-- 2) Отримати перелік і загальне число обслуговуючого персоналу зазначеної спеціальності для конкретного медичного закладу, лікарні або всіх медичних установ міста. 

SELECT * FROM hospitals;
SELECT * FROM polyclinics;
SELECT * FROM staff;
SELECT * FROM staff_hospital_contracts;
SELECT * FROM staff_polyclinic_contracts;

DELIMITER // 
CREATE PROCEDURE task2 (IN hospital_name VARCHAR(100), IN polyclninic_name VARCHAR(100), 
IN staff_category VARCHAR(100))
BEGIN 
    IF hospital_name != '' THEN 
		SELECT s.staff_id, s.name, s.category, h.name
		FROM staff s
		INNER JOIN staff_hospital_contracts shc ON s.staff_id = shc.staff_id
		INNER JOIN hospitals h ON shc.hospital_id = h.hospital_id
		WHERE h.name = hospital_name AND s.category = staff_category;
    ELSEIF polyclninic_name != '' THEN
		SELECT s.staff_id, s.name, s.category, p.name
		FROM staff s
		INNER JOIN staff_polyclinic_contracts spc ON s.staff_id = spc.staff_id
		INNER JOIN polyclinics p ON spc.polyclinic_id = p.polyclinic_id
		WHERE p.name = polyclninic_name AND s.category = staff_category;
	ELSE
		SELECT s.staff_id, s.name, s.category, h.name, p.name
		FROM staff s
		LEFT JOIN staff_polyclinic_contracts spc ON s.staff_id = spc.staff_id
		LEFT JOIN staff_hospital_contracts shc ON s.staff_id = shc.staff_id
		LEFT JOIN hospitals h ON shc.hospital_id = h.hospital_id
		LEFT JOIN polyclinics p ON spc.polyclinic_id = p.polyclinic_id
		WHERE s.category = staff_category;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task2;

call task2 ('Київська міська №1', '', 'мед. сестра');
call task2 ('', 'Гіпократ', 'мед. сестра');
call task2 ('', '', 'мед. сестра');






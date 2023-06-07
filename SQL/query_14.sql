-- 14) Отримати дані про продуктивність лабораторії (середнє число проведених обстежень в день) за вказаний період для даного медичного закладу або всіх медичних установ міста. 

SELECT * FROM laboratories;
SELECT * FROM lab_hospital_contracts;
SELECT * FROM lab_visits;

DELIMITER // 
CREATE PROCEDURE task14 (IN hospital_name VARCHAR(100), IN date1 DATE, IN date2 DATE)
BEGIN
    IF hospital_name != '' THEN 
		SELECT l.lab_name as lab_name, h.name as hospital_name, COUNT(lv.visit_id) / (DATEDIFF(date2, date1)+1) as average_visits_per_day
        FROM laboratories l 
        JOIN lab_hospital_contracts lhc ON l.lab_id = lhc.lab_id
        JOIN lab_visits lv ON l.lab_id = lv.lab_id
        JOIN hospitals h ON lhc.hospital_id = h.hospital_id
		WHERE h.name = hospital_name AND lv.visit_date >= date1 AND lv.visit_date <= date2;
    ELSE 
		SELECT l.lab_name as lab_name, h.name as hospital_name, COUNT(lv.visit_id) / (DATEDIFF(date2, date1)+1) as average_visits_per_day
        FROM laboratories l 
        JOIN lab_hospital_contracts lhc ON l.lab_id = lhc.lab_id
        JOIN lab_visits lv ON l.lab_id = lv.lab_id
        JOIN hospitals h ON lhc.hospital_id = h.hospital_id
		WHERE lv.visit_date >= date1 AND lv.visit_date <= date2
        GROUP BY h.name;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task14;

call task14 ('Київська міська №1', '2023-07-07', '2023-07-09');
call task14 ('', '2023-07-07', '2023-07-09');


-- 7) Отримати перелік пацієнтів, які пройшли стаціонарне лікування у зазначеній лікарні, або у конкретного лікаря за деякий проміжок часу. 

SELECT * FROM accounting;
SELECT * FROM doctors;

DELIMITER // 
CREATE PROCEDURE task7 (IN hospital_name VARCHAR(100), IN doctor_name VARCHAR(100),
IN input_date DATE, IN output_date DATE)
BEGIN 
    IF hospital_name != '' THEN
		SELECT SQL_CALC_FOUND_ROWS p.name, a.hospital_name, d.name, a.input_date, a.output_date
        FROM patients p
        INNER JOIN accounting a ON p.patient_id = a.patient_id
        INNER JOIN doctors d ON d.doctor_id = a.doctor_id
        WHERE a.hospital_name = hospital_name AND a.input_date >= input_date AND a.output_date <= output_date;
    ELSEIF doctor_name != '' THEN
		SELECT SQL_CALC_FOUND_ROWS p.name, a.hospital_name, d.name, a.input_date, a.output_date
        FROM patients p
        INNER JOIN accounting a ON p.patient_id = a.patient_id
        INNER JOIN doctors d ON d.doctor_id = a.doctor_id
        WHERE d.name = doctor_name AND a.input_date >= input_date AND a.output_date <= output_date;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task7;

call task7 ('Київська міська №1', '', '2023-05-19', '2023-09-29');
call task7 ('', 'Соколова М.Н.', '2023-05-19', '2023-09-29');
SELECT found_rows() as count;




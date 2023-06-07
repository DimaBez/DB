-- 13) Отримати перелік пацієнтів, які перенесли операції у зазначеній лікарні, або поліклініці, або у конкретного лікаря за деякий проміжок часу. 

SELECT * FROM hospitals;
SELECT * FROM polyclinics;
SELECT * FROM doctors;
SELECT * FROM patients;
SELECT * FROM doc_patient_contract;
SELECT * FROM accounting;

DELIMITER // 
CREATE PROCEDURE task13 (IN hospital_name VARCHAR(100), IN polyclninic_name VARCHAR(100), 
IN doctor_name VARCHAR(100), IN date1 DATE, IN date2 DATE)
BEGIN 
    IF hospital_name != '' THEN 
        SELECT SQL_CALC_FOUND_ROWS DISTINCT p.name, d.name, d.category, h.name, a.input_date
        FROM patients p
        JOIN accounting a ON p.patient_id = a.patient_id
        JOIN doctors d ON a.doctor_id = d.doctor_id
		JOIN hospitals h ON h.name = a.hospital_name
        JOIN doc_patient_contract dpc ON p.patient_id = dpc.patient_id
        WHERE h.name = hospital_name AND d.operations = 1 AND a.input_date >= date1 AND a.input_date <= date2;
    ELSEIF polyclninic_name != '' THEN
        SELECT SQL_CALC_FOUND_ROWS DISTINCT p.name, d.name, d.category, pol.name, a.input_date
        FROM patients p
        JOIN accounting a ON p.patient_id = a.patient_id
        JOIN doctors d ON a.doctor_id = d.doctor_id
		JOIN polyclinics pol ON pol.name = a.polyclinic_name
        JOIN doc_patient_contract dpc ON p.patient_id = dpc.patient_id
        WHERE pol.name = polyclninic_name AND d.operations = 1 AND a.input_date >= date1 AND a.input_date <= date2;
	ELSEIF doctor_name != '' THEN
        SELECT SQL_CALC_FOUND_ROWS DISTINCT p.name, d.name, d.category, a.input_date
        FROM patients p
        JOIN accounting a ON p.patient_id = a.patient_id
        JOIN doctors d ON a.doctor_id = d.doctor_id
		JOIN hospitals h ON h.name = a.hospital_name
		JOIN polyclinics pol ON pol.name = a.polyclinic_name
        JOIN doc_patient_contract dpc ON p.patient_id = dpc.patient_id
        WHERE d.name = doctor_name AND d.operations = 1 AND a.input_date >= date1 AND a.input_date <= date2;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task13;

call task13 ('Лікарня "Феофанія"', '', '', '2023-05-19', '2023-08-29');
call task13 ('', 'Святовіт', '', '2023-05-19', '2023-08-29');
call task13 ('', '', 'Коваленко Н.О.', '2023-05-19', '2023-08-29');
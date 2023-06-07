-- 12) Отримати дані про завантаження (число пацієнтів, у яких лікар в даний час є лікуючим лікарем) для вказаного лікаря, або всіх лікарів лікарні, або для всіх лікарів названого профілю.

SELECT * FROM hospitals;
SELECT * FROM doctors;
SELECT * FROM doc_patient_contract;
SELECT * FROM doc_hospital_contracts;

DELIMITER // 
CREATE PROCEDURE task12 (IN doctor_name VARCHAR(100), IN hospital_name VARCHAR(100),
IN doctor_category VARCHAR(100))
BEGIN 
    IF doctor_name != '' THEN 
        SELECT SQL_CALC_FOUND_ROWS count(dpc.contract_id) as patients_count, d.name
        FROM doctors d
        JOIN doc_patient_contract dpc ON d.doctor_id = dpc.doctor_id
        WHERE d.name = doctor_name;
    ELSEIF hospital_name != '' THEN
        SELECT SQL_CALC_FOUND_ROWS count(dpc.contract_id) as patients_count, d.name, h.name
        FROM doctors d
        JOIN doc_patient_contract dpc ON d.doctor_id = dpc.doctor_id
		JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
		JOIN hospitals h ON h.hospital_id = dhc.hospital_id
        WHERE h.name = hospital_name
        GROUP BY d.name;
	ELSEIF doctor_category != '' THEN
        SELECT SQL_CALC_FOUND_ROWS count(dpc.contract_id) as patients_count, d.name, d.category
        FROM doctors d
        JOIN doc_patient_contract dpc ON d.doctor_id = dpc.doctor_id
        WHERE d.category = doctor_category
		GROUP BY d.name;
    END IF;
END// 
DELIMITER ;

DROP PROCEDURE task12;

call task12 ('Соколова М.Н.', '', '');
call task12 ('', 'Лікарня "Охматдит"', '');
call task12 ('', '', 'хірург');
DELETE FROM hospitals;
DELETE FROM hospital_buildings WHERE building_id < 100;
DELETE FROM departments;
DELETE FROM rooms;

DELETE FROM polyclinics WHERE polyclinic_id < 100;


DELETE FROM accounting WHERE record_id < 100;
DELETE FROM doc_patient_contract WHERE contract_id < 100;
DELETE FROM doctors WHERE doctor_id < 100;
DELETE FROM doctors_contracts WHERE contract_id < 100;


DELETE FROM laboratories WHERE polyclinic_id < 100;
DELETE FROM labs_contracts WHERE polyclinic_id < 100;
DELETE FROM patients WHERE polyclinic_id < 100;

DELETE FROM staff WHERE polyclinic_id < 100;
DELETE FROM staff_contracts WHERE polyclinic_id < 100;
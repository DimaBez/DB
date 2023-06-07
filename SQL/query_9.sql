-- 9) Отримати загальне число палат, ліжок зазначеної лікарні загалом і по кожному відділенню, а також число вільних ліжок у кожному відділенні і число повністю вільних палат. 

SELECT * FROM hospitals;
SELECT * FROM hospital_buildings;
SELECT * FROM departments;
SELECT * FROM rooms;

DELIMITER // 
CREATE PROCEDURE task9 (IN hospital_name VARCHAR(100))
BEGIN
	SELECT
		SUM(r.beds_count) as total_beds,
        COUNT(r.room_id) as total_rooms,
		SUM(r.beds_count - r.occupied_beds_count) as total_free_beds,
        COUNT(CASE WHEN r.occupied_beds_count = 0 THEN r.room_id END) as total_completely_free_rooms,
        d.name
	FROM hospitals h
	LEFT JOIN hospital_buildings hb ON h.hospital_id = hb.hospital_id
	LEFT JOIN departments d ON hb.building_id = d.building_id 
	LEFT JOIN rooms r ON d.department_id = r.department_id
	WHERE h.name = hospital_name
    GROUP BY d.department_id, d.name
    UNION
	SELECT 
		SUM(r.beds_count),
		COUNT(r.room_id),
        NULL,
        NULL,
        h.name
	FROM hospitals h
	LEFT JOIN hospital_buildings hb ON h.hospital_id = hb.hospital_id
	LEFT JOIN departments d ON hb.building_id = d.building_id 
	LEFT JOIN rooms r ON d.department_id = r.department_id
	WHERE h.name = hospital_name;
END// 
DELIMITER ;

DROP PROCEDURE task9;

call task9 ('Київська дитяча лікарня');



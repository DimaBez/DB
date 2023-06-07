USE medical_organizations;


DROP TRIGGER set_operations_flag;

-- Тригер для лікарських категорій
DELIMITER //
CREATE TRIGGER set_characteristics_flag
BEFORE INSERT ON doctors
FOR EACH ROW
BEGIN
    IF NEW.category IN ('хірург', 'стоматолог', 'гінеколог') THEN
        SET NEW.operations = 1;
    END IF;
	IF NEW.category IN ('ренгенолог', 'стоматолог') THEN
        SET NEW.salary_ratio = 1;
    END IF;
	IF NEW.category IN ('ренгенолог', 'невропатолог') THEN
        SET NEW.longer_vacations = 1;
    END IF;
END //
DELIMITER ;


-- Тригер для лікарських звань
DELIMITER //
CREATE TRIGGER set_ranks_flag
BEFORE INSERT ON doctors
FOR EACH ROW
BEGIN
    IF NEW.degree = 'доктор медичних наук' THEN
        SET NEW.rank = 'професор';
    END IF;
    IF NEW.degree = 'кандидат медичних наук' THEN
        SET NEW.rank = 'доцент';
    END IF;
END //
DELIMITER ;



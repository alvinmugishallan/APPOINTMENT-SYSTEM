
CREATE DATABASE IF NOT EXISTS Project;
USE Project;

DROP TABLE IF EXISTS `confirmation`;
DROP TABLE IF EXISTS `payment`;
DROP TABLE IF EXISTS `availability`;
DROP TABLE IF EXISTS `appointment`;
DROP TABLE IF EXISTS `receptionist`;
DROP TABLE IF EXISTS `doctor`;
DROP TABLE IF EXISTS `patient`;
DROP TABLE IF EXISTS `person`;

-- Base Person Table
CREATE TABLE `person` (
  `person_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone_number` VARCHAR(15) DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `role` VARCHAR(50) NOT NULL DEFAULT 'PATIENT',
  PRIMARY KEY (`person_id`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `chk_role` CHECK (`role` IN ('DOCTOR', 'PATIENT', 'Receptionist'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Patient Table
CREATE TABLE `patient` (
  `patient_id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  `date_of_birth` DATE DEFAULT NULL,
  `gender` ENUM('Male','Female','Other') DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `person_id` (`person_id`),
  CONSTRAINT `patient_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Doctor Table
CREATE TABLE `doctor` (
  `DOCTOR_ID` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  `speciality` VARCHAR(100) NOT NULL,
  `license_number` VARCHAR(50) NOT NULL,
  `years_experience` INT DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DOCTOR_ID`),
  UNIQUE KEY `license_number` (`license_number`),
  UNIQUE KEY `person_id` (`person_id`),
  CONSTRAINT `chk_experience` CHECK (`years_experience` >= 0),
  CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Receptionist Table
CREATE TABLE `receptionist` (
  `person_id` INT NOT NULL,
  `employee_number` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`person_id`),
  UNIQUE KEY `employee_number` (`employee_number`),
  CONSTRAINT `receptionist_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Appointment Table
CREATE TABLE `appointment` (
  `appointment_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT DEFAULT NULL,
  `doctor_id` INT DEFAULT NULL,
  `receptionist_id` INT DEFAULT NULL,
  `appointment_date` DATE NOT NULL,
  `appointment_time` TIME NOT NULL,
  `status` VARCHAR(20) DEFAULT 'Pending',
  PRIMARY KEY (`appointment_id`),
  KEY `patient_id` (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `receptionist_id` (`receptionist_id`),
  CONSTRAINT `chk_appt_status` CHECK (`status` IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`person_id`),
  CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`person_id`),
  CONSTRAINT `appointment_ibfk_3` FOREIGN KEY (`receptionist_id`) REFERENCES `receptionist` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Availability Table
CREATE TABLE `availability` (
  `availability_id` INT NOT NULL AUTO_INCREMENT,
  `doctor_id` INT DEFAULT NULL,
  `available_date` DATE NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `availability_status` VARCHAR(20) DEFAULT 'Available',
  PRIMARY KEY (`availability_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `chk_avail_status` CHECK (`availability_status` IN ('Available', 'Booked', 'Not Available')),
  CONSTRAINT `chk_time_range` CHECK (`end_time` > `start_time`),
  CONSTRAINT `availability_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`person_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Payment Table
CREATE TABLE `payment` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT DEFAULT NULL,
  `appointment_id` INT DEFAULT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `payment_method` VARCHAR(30) DEFAULT 'Cash',
  `payment_date` DATE DEFAULT (CURRENT_DATE),
  `insurance_status` VARCHAR(20) DEFAULT 'Not insured',
  PRIMARY KEY (`payment_id`),
  KEY `patient_id` (`patient_id`),
  KEY `appointment_id` (`appointment_id`),
  CONSTRAINT `chk_amount` CHECK (`amount` >= 0),
  CONSTRAINT `chk_insurance` CHECK (`insurance_status` IN ('insured', 'Not insured')),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`person_id`),
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`appointment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Confirmation Table
CREATE TABLE `confirmation` (
  `confirmation_id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  `appointment_id` INT NOT NULL,
  `payment_id` INT NOT NULL,
  `confirmation_type` VARCHAR(50) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`confirmation_id`),
  KEY `person_id` (`person_id`),
  KEY `appointment_id` (`appointment_id`),
  KEY `payment_id` (`payment_id`),
  CONSTRAINT `chk_conf_status` CHECK (`status` IN ('Pending', 'Confirmed', 'Cancelled')),
  CONSTRAINT `confirmation_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`),
  CONSTRAINT `confirmation_ibfk_2` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`appointment_id`),
  CONSTRAINT `confirmation_ibfk_3` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- 2. DATA INSERTION

INSERT INTO `person` (`person_id`, `first_name`, `last_name`, `email`, `phone_number`, `created_at`, `role`) VALUES 
(1,'OGWANG','DAVID','david@gmail.com','0701234567','2026-09-03 07:52:49','DOCTOR'),
(2,'OKELLO','JOSHUA','joshua@gmail.com','0707654321','2026-09-03 07:52:49','PATIENT'),
(5,'NAKATO','JANE','jane@gmail.com','0709876543','2026-09-03 08:36:38','PATIENT'),
(6,'MUSOKE','PAUL','paul@gmail.com','0701111111','2026-09-03 08:36:38','Receptionist'),
(7,'KABAGAMBE','MARY','mary@gmail.com','0702222222','2026-09-03 08:36:38','PATIENT'),
(8,'KASIRYE','DAVID','david2@gmail.com','0703333333','2026-09-03 08:36:38','DOCTOR'),
(9,'KALIBO','ANNE','anne@gmail.com','0704444333','2026-09-03 08:36:38','PATIENT'),
(10,'KABAGAMBE','JAMES','james@gmail.com','0705555555','2026-09-03 08:36:38','Receptionist'),
(11,'SEMU','JOSHUA','joshua2@gmail.com','0706666666','2026-09-03 08:36:38','DOCTOR'),
(12,'MATOVU','MUSA','musa@gmail.com','0787867876','2026-09-03 08:36:38','DOCTOR'),
(13,'NALUDDE','GLORIA','gloria@gmail.com','078978904','2026-09-03 08:36:38','DOCTOR'),
(14,'NALUBEGA','RUTH','ruth@gmail.com','0787867876','2026-09-03 08:36:38','PATIENT'),
(15,'KASIRYE','JAMES','james2@gmail.com','0789098765','2026-09-03 08:36:38','PATIENT'),
(16,'MUKASA','MATHEW','mathew@gmail.com','0789098765','2026-09-03 08:36:38','PATIENT'),
(17,'ONEN','JUSTIN','justin@gmail.com','0795452314','2026-09-03 08:36:38','PATIENT');

INSERT INTO `patient` (`patient_id`, `person_id`, `date_of_birth`, `gender`) VALUES 
(1,2,'2000-01-01','Male'),
(2,5,'1998-02-03','Female'),
(3,7,'2004-03-04','Female'),
(4,9,'1993-02-01','Female'),
(5,14,'2006-01-02','Female'),
(6,15,'2001-02-01','Male'),
(7,16,'2002-03-03','Male'),
(8,17,'1995-03-01','Male');

INSERT INTO `doctor` (`DOCTOR_ID`, `person_id`, `speciality`, `license_number`, `years_experience`, `created_at`) VALUES 
(11,1,'GENERAL DOCTOR','DOC2001',20,'2026-09-03 09:12:40'),
(2,8,'SURGEON','SUR3001',10,'2026-09-03 09:12:40'),
(3,11,'SURGEON','SUR5001',15,'2026-09-03 09:12:40'),
(4,12,'PEDIATRICS','PED6002',10,'2026-09-03 09:12:40'),
(5,13,'CARDIOLOGIST','CARD0095',12,'2026-09-03 09:12:40');

INSERT INTO `receptionist` (`person_id`, `employee_number`) VALUES 
(6,'REC001'),
(10,'REC002');

INSERT INTO `appointment` (`appointment_id`, `patient_id`, `doctor_id`, `receptionist_id`, `appointment_date`, `appointment_time`, `status`) VALUES 
(21,2,1,6,'2025-09-08','09:00:00','Confirmed'),
(22,9,NULL,6,'2025-09-08','10:00:00','Pending'),
(23,5,NULL,10,'2025-09-09','14:30:00','Confirmed'),
(24,7,1,10,'2025-09-10','11:00:00','Cancelled');

INSERT INTO `availability` (`availability_id`, `doctor_id`, `available_date`, `start_time`, `end_time`, `availability_status`) VALUES 
(16,1,'2025-09-08','08:00:00','12:00:00','Available'),
(17,NULL,'2025-09-09','14:00:00','17:00:00','Available'),
(18,NULL,'2025-09-08','09:00:00','13:00:00','Available'),
(19,NULL,'2025-09-08','08:00:00','16:00:00','Available'),
(20,11,'2025-09-10','10:00:00','15:00:00','Not Available');

INSERT INTO `payment` (`payment_id`, `patient_id`, `appointment_id`, `amount`, `payment_method`, `payment_date`, `insurance_status`) VALUES 
(7,2,21,50000.00,'Cash','2025-09-08','insured'),
(8,7,22,75000.00,'Mobile Money','2025-09-08','Not insured'),
(9,5,23,60000.00,'Cash','2025-09-09','Not insured');

INSERT INTO `confirmation` (`confirmation_id`, `person_id`, `appointment_id`, `payment_id`, `confirmation_type`, `status`, `created_at`) VALUES 
(1,2,21,7,'Appointment Confirmation','Confirmed','2026-09-04 10:46:15'),
(2,7,22,8,'Payment Confirmation','Pending','2026-09-04 10:46:15'),
(3,5,23,9,'Appointment Confirmation','Confirmed','2026-09-04 10:46:15');

-- 3. TRIGGERS FOR DATA INTEGRITY
DELIMITER //

-- Prevent Doctor Double Booking
CREATE TRIGGER `trg_prevent_double_booking`
BEFORE INSERT ON `appointment`
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    IF NEW.doctor_id IS NOT NULL AND NEW.status != 'Cancelled' THEN
        SELECT COUNT(*) INTO v_count
        FROM appointment
        WHERE doctor_id = NEW.doctor_id
          AND appointment_date = NEW.appointment_date
          AND appointment_time = NEW.appointment_time
          AND status != 'Cancelled';
          
        IF v_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Doctor is already booked for this specific time slot.';
        END IF;
    END IF;
END //

-- Prevent Payment for Cancelled Appointments
CREATE TRIGGER `trg_prevent_cancelled_payment`
BEFORE INSERT ON `payment`
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    IF NEW.appointment_id IS NOT NULL THEN
        SELECT status INTO v_status
        FROM appointment
        WHERE appointment_id = NEW.appointment_id;
        
        IF v_status = 'Cancelled' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot record payment for a cancelled appointment.';
        END IF;
    END IF;
END //

DELIMITER ;

-- 4. STORED PROCEDURES
drop procedure sp_book_appointment;
DELIMITER //

-- Atomic Appointment Booking Procedure
CREATE PROCEDURE sp_book_appointment(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_date DATE,
    IN p_time TIME,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_appt_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO appointment (patient_id, doctor_id, appointment_date, appointment_time, status)
    VALUES (p_patient_id, p_doctor_id, p_date, p_time, 'Confirmed');

    SET v_appt_id = LAST_INSERT_ID();

    INSERT INTO payment (patient_id, appointment_id, amount)
    VALUES (p_patient_id, v_appt_id, p_amount);

    COMMIT;
END //

-- Patient Registration Procedure
CREATE PROCEDURE sp_register_patient(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_dob DATE,
    IN p_gender ENUM('Male','Female','Other')
)
BEGIN
    DECLARE v_person_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO person (first_name, last_name, email, phone_number, role)
    VALUES (p_first_name, p_last_name, p_email, p_phone, 'PATIENT');

    SET v_person_id = LAST_INSERT_ID();

    INSERT INTO patient (person_id, date_of_birth, gender)
    VALUES (v_person_id, p_dob, p_gender);

    COMMIT;

    SELECT v_person_id AS new_patient_person_id;
END //

-- Doctor Daily Schedule Query Procedure
CREATE PROCEDURE sp_get_doctor_daily_schedule(
    IN p_doctor_id INT,
    IN p_date DATE
)
BEGIN
    SELECT 
        a.appointment_id,
        a.appointment_time,
        a.status AS appointment_status,
        CONCAT(p_pat.first_name, ' ', p_pat.last_name) AS patient_name,
        p_pat.phone_number AS patient_phone,
        pat.gender,
        pay.amount,
        pay.insurance_status
    FROM appointment a
    JOIN person p_pat ON a.patient_id = p_pat.person_id
    JOIN patient pat ON p_pat.person_id = pat.person_id
    LEFT JOIN payment pay ON a.appointment_id = pay.appointment_id
    WHERE a.doctor_id = p_doctor_id
      AND a.appointment_date = p_date
    ORDER BY a.appointment_time ASC;
END //

-- Financial Revenue Report Procedure Across Doctors
CREATE PROCEDURE sp_get_doctor_financial_report(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        d.DOCTOR_ID,
        CONCAT(p.first_name, ' ', p.last_name) AS doctor_name,
        d.speciality,
        COUNT(DISTINCT a.appointment_id) AS total_appointments,
        SUM(CASE WHEN a.status = 'Confirmed' THEN 1 ELSE 0 END) AS confirmed_appointments,
        SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_appointments,
        COALESCE(SUM(pay.amount), 0.00) AS total_revenue,
        COALESCE(SUM(CASE WHEN pay.insurance_status = 'insured' THEN pay.amount ELSE 0 END), 0.00) AS insured_revenue,
        COALESCE(SUM(CASE WHEN pay.insurance_status = 'Not insured' THEN pay.amount ELSE 0 END), 0.00) AS out_of_pocket_revenue
    FROM doctor d
    JOIN person p ON d.person_id = p.person_id
    LEFT JOIN appointment a ON d.person_id = a.doctor_id 
                            AND a.appointment_date BETWEEN p_start_date AND p_end_date
    LEFT JOIN payment pay ON a.appointment_id = pay.appointment_id
    GROUP BY d.DOCTOR_ID, d.person_id, doctor_name, d.speciality
    ORDER BY total_revenue DESC;
END //

DELIMITER ;

-- 5. REPORTING JOINS & ANALYTICS VIEWS
-- Master Appointment View (Wide Join)
SELECT 
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    a.status AS appointment_status,
    p_pat.first_name AS patient_first_name,
    p_pat.last_name AS patient_last_name,
    pat.gender,
    p_doc.first_name AS doctor_first_name,
    p_doc.last_name AS doctor_last_name,
    doc.speciality,
    p_rec.first_name AS receptionist_first_name,
    p_rec.last_name AS receptionist_last_name
FROM appointment a
LEFT JOIN patient pat ON a.patient_id = pat.person_id
LEFT JOIN person p_pat ON pat.person_id = p_pat.person_id
LEFT JOIN doctor doc ON a.doctor_id = doc.person_id
LEFT JOIN person p_doc ON doc.person_id = p_doc.person_id
LEFT JOIN receptionist rec ON a.receptionist_id = rec.person_id
LEFT JOIN person p_rec ON rec.person_id = p_rec.person_id;

-- Payment Ledger & Patient Contact View
SELECT 
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_date,
    pay.insurance_status,
    a.appointment_date,
    a.status AS appointment_status,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    p.email
FROM payment pay
JOIN appointment a ON pay.appointment_id = a.appointment_id
JOIN patient pat ON pay.patient_id = pat.person_id
JOIN person p ON pat.person_id = p.person_id;

-- Complete Audit Trail View (7-Table Pipeline Join)
SELECT 
    c.confirmation_id,
    c.confirmation_type,
    c.status AS confirmation_status,
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    a.status AS appointment_status,
    p_pat.first_name AS patient_first_name,
    p_pat.last_name AS patient_last_name,
    pat.gender,
    p_doc.first_name AS doctor_first_name,
    p_doc.last_name AS doctor_last_name,
    doc.speciality,
    p_rec.first_name AS receptionist_first_name,
    rec.employee_number,
    pay.amount,
    pay.payment_method,
    pay.insurance_status
FROM confirmation c
JOIN person p_conf ON c.person_id = p_conf.person_id
JOIN appointment a ON c.appointment_id = a.appointment_id
JOIN payment pay ON c.payment_id = pay.payment_id
LEFT JOIN patient pat ON a.patient_id = pat.person_id
LEFT JOIN person p_pat ON pat.person_id = p_pat.person_id
LEFT JOIN doctor doc ON a.doctor_id = doc.person_id
LEFT JOIN person p_doc ON doc.person_id = p_doc.person_id
LEFT JOIN receptionist rec ON a.receptionist_id = rec.person_id
LEFT JOIN person p_rec ON rec.person_id = p_rec.person_id;

call  sp_get_doctor_financial_report('2025-09-01', '2025-09-30');

call sp_get_doctor_daily_schedule(1, '2025-09-08');

call sp_register_patient('John', 'Doe', 'john.doe@example.com', '0786261604', '2025-09-03', 'male');

call sp_book_appointment(2, 1, 6, '2025-09-08', '09:00:00', 50000.00, 'Cash', 'insured');

call sp_
show triggers;
show procedure status;

show triggers;


insert into appointment(`appointment_id`, `patient_id`, `doctor_id`, `receptionist_id`, `appointment_date`, `appointment_time`, `status`) VALUES 
(21,2,1,6,'2025-09-08','09:00:00','Confirmed');

select*from doctor;
call sp_get_doctor_daily_schedule(1, '2025-09-08');
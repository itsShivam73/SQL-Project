-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
CREATE TABLE `patients`(
    `patient_id` INT AUTO_INCREMENT ,
    `name` VARCHAR(40) NOT NULL,
    `age` TINYINT NOT NULL ,
    `gender` ENUM ('male','female','others') NOT NULL,
    `phone` VARCHAR(15) NOT NULL ,
    `address` VARCHAR(128) NOT NULL,
    PRIMARY KEY(`patient_id`)
);

CREATE TABLE `doctors`(
    `doctor_id` INT AUTO_INCREMENT,
    `name` VARCHAR(40),
     specialization ENUM(
        'Cardiologist',
        'Neurologist',
        'Orthopedic',
        'Dermatologist',
        'Pediatrician',
        'Psychiatrist',
        'Gynecologist',
        'Oncologist',
        'General Physician',
        'ENT Specialist'
    ) NOT NULL ,
    `phone` VARCHAR(15),
    PRIMARY KEY (`doctor_id`)
);

CREATE TABLE `staff` (
    `staff_id` INT AUTO_INCREMENT ,
    `name` VARCHAR(40) NOT NULL,
    `role` ENUM(
        'Nurse', 'Technician', 'Receptionist', 'Pharmacist',
        'Lab Technician', 'Janitor', 'Security', 'Administrator'
    ) NOT NULL,
    `department` VARCHAR(50),
    `phone` VARCHAR(15),
    PRIMARY KEY (`staff_id`)
);


CREATE TABLE `appointment`(
    `appointment_id` INT AUTO_INCREMENT ,
    `patient_id` INT ,
    `doctor_id` INT ,
    `date` DATETIME NOT NULL ,
    `status` ENUM('scheduled' , 'completed' , 'cancelled') NOT NULL ,
    PRIMARY KEY (`appointment_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`patient_id`),
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors`(`doctor_id`)
);

CREATE TABLE `treatment` (
    `treatment_id` INT AUTO_INCREMENT ,
    `appointment_id` INT ,
    `description` TEXT NOT NULL ,
    `cost` DECIMAL(7,2) NOT NULL ,
    PRIMARY KEY (`treatment_id`),
    FOREIGN KEY (`appointment_id`) REFERENCES `appointment`(`appointment_id`)
);

CREATE TABLE `medication`(
    `medication_id` INT AUTO_INCREMENT,
    `treatment_id` INT ,
    `medicine_name` TEXT NOT NULL ,
    `dosage` TINYINT NOT NULL ,
    `frequency` ENUM('once daily', 'twice daily', 'thrice daily', 'every 6 hours', 'every 8 hours') NOT NULL,
    `duration` INT NOT NULL COMMENT 'Duration in days',
    PRIMARY KEY (`medication_id`),
    FOREIGN KEY (`treatment_id`) REFERENCES `treatment`(`treatment_id`)
);

CREATE TABLE `rooms`(
    `room_id` INT AUTO_INCREMENT ,
    `patient_id` INT ,
    `admission_date` DATE NOT NULL ,
    `room_type` ENUM (
        'General Ward',
        'Semi Private Room',
        'Private Room',
        'Intensive Care Unit (ICU)',
        'Isolation Room',
        'Surgery Room',
        'Maternity Room',
        'Deluxe or Suite'
    ) NOT NULL ,
    PRIMARY KEY (`room_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`patient_id`)
);


CREATE TABLE `lab_test`(
    `lab_test_id` INT AUTO_INCREMENT,
    `appointment_id` INT ,
    `test_type` ENUM(
        'Blood Test',
        'Urine Test',
        'X-Ray',
        'MRI',
        'CT Scan',
        'Ultrasound',
        'ECG',
        'Biopsy',
        'Allergy Test',
        'PCR Test',
        'COVID-19 Test'
    ) NOT NULL,
    `result` TEXT ,
    `test_date` DATE ,
    PRIMARY KEY(`lab_test_id`) ,
    FOREIGN KEY (`appointment_id`) REFERENCES `appointment`(`appointment_id`)
);

CREATE TABLE `emergency_contact` (
    `contact_id` INT AUTO_INCREMENT ,
    `patient_id` INT ,
    `contact_name` VARCHAR(64) ,
    `relationship` VARCHAR(32),
    `phone` VARCHAR(15),
    PRIMARY KEY (`contact_id`) ,
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`patient_id`)
);

CREATE TABLE `billing` (
    `billing_id` INT AUTO_INCREMENT ,
    `treatment_id` INT ,
    `total_amount` DECIMAL(7,2) NOT NULL ,
    `status` ENUM ('approved' ,'pending') NOT NULL,
    PRIMARY KEY(`billing_id`),
    FOREIGN KEY(`treatment_id`) REFERENCES `treatment`(`treatment_id`)
);



-- Indexes for frequently queried fields
CREATE INDEX idx_appointment_date ON `appointment`(`date`);

CREATE INDEX idx_appointment_patient_doctor ON `appointment`(`patient_id`, `doctor_id`);

CREATE INDEX idx_patient_phone ON `patients`(`phone`);

CREATE INDEX idx_doctor_specialization ON `doctors`(`specialization`);

CREATE INDEX idx_billing_status ON `billing`(`status`);

CREATE INDEX idx_lab_test_date ON `lab_test`(`test_date`);




-- View for patient appointments with doctor details
CREATE VIEW `patient_appointments` AS
SELECT
    a.appointment_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    a.date,
    a.status
FROM `appointment` a
JOIN `patients` p ON a.patient_id = p.patient_id
JOIN `doctors` d ON a.doctor_id = d.doctor_id;

-- View for patient billing summary
CREATE VIEW `patient_billing_summary` AS
SELECT
    p.patient_id,
    p.name AS patient_name,
    t.treatment_id,
    b.total_amount,
    b.status AS billing_status,
    t.cost AS treatment_cost
FROM `patients` p
JOIN `appointment` a ON p.patient_id = a.patient_id
JOIN `treatment` t ON a.appointment_id = t.appointment_id
JOIN `billing` b ON t.treatment_id = b.treatment_id;

-- View for room occupancy
CREATE VIEW `room_occupancy` AS
SELECT
    r.room_id,
    r.room_type,
    p.name AS patient_name,
    r.admission_date
FROM `rooms` r
LEFT JOIN `patients` p ON r.patient_id = p.patient_id;


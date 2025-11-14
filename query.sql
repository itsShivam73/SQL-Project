-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database
-- Hospital Management System - Complete SQL with Sample Data and Queries

-- =============================================
-- 1. FIRST, INSERT SAMPLE DATA
-- =============================================

-- Insert sample patients
INSERT INTO `patients` (`name`, `age`, `gender`, `phone`, `address`) VALUES
('Raj Sharma', 35, 'male', '9876543210', '123 MG Road, Mumbai'),
('Priya Patel', 28, 'female', '9876543211', '456 Park Street, Delhi'),
('Amit Kumar', 45, 'male', '9876543212', '789 Gandhi Nagar, Bangalore'),
('Sneha Singh', 32, 'female', '9876543213', '321 Lake View, Chennai'),
('Rohan Mehta', 60, 'male', '9876543214', '654 Hill Road, Kolkata');

-- Insert sample doctors
INSERT INTO `doctors` (`name`, `specialization`, `phone`) VALUES
('Dr. Michael Brown', 'Cardiologist', '9876543220'),
('Dr. Sarah Wilson', 'Neurologist', '9876543221'),
('Dr. Anjali Mehta', 'Gynecologist', '9876543222'),
('Dr. Robert Davis', 'Orthopedic', '9876543223'),
('Dr. Lisa Anderson', 'Pediatrician', '9876543224');

-- Insert sample staff
INSERT INTO `staff` (`name`, `role`, `department`, `phone`) VALUES
('Nurse Sunita', 'Nurse', 'Cardiology', '9876543230'),
('Receptionist Amit', 'Receptionist', 'Front Desk', '9876543231'),
('Lab Tech Raj', 'Lab Technician', 'Pathology', '9876543232');

-- Insert sample appointments
INSERT INTO `appointment` (`patient_id`, `doctor_id`, `date`, `status`) VALUES
(1, 1, '2024-01-15 10:00:00', 'completed'),
(2, 2, '2024-01-15 11:30:00', 'completed'),
(3, 1, '2024-01-15 14:00:00', 'scheduled'),
(4, 3, '2024-01-16 09:00:00', 'scheduled'),
(1, 4, '2024-01-16 15:30:00', 'cancelled'),
(5, 1, CURDATE(), 'scheduled'),  -- Today's appointment
(2, 2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 'scheduled');  -- Tomorrow's appointment

-- Insert sample treatments
INSERT INTO `treatment` (`appointment_id`, `description`, `cost`) VALUES
(1, 'Cardiac checkup and ECG', 1500.00),
(2, 'Neurological consultation', 1200.00),
(3, 'Blood pressure monitoring', 800.00),
(4, 'Gynecological examination', 2000.00);

-- Insert sample medications
INSERT INTO `medication` (`treatment_id`, `medicine_name`, `dosage`, `frequency`, `duration`) VALUES
(1, 'Aspirin', 1, 'once daily', 30),
(1, 'Atorvastatin', 1, 'once daily', 30),
(2, 'Gabapentin', 1, 'twice daily', 15),
(3, 'Amlodipine', 1, 'once daily', 30);

-- Insert sample rooms
INSERT INTO `rooms` (`patient_id`, `admission_date`, `room_type`) VALUES
(1, '2024-01-14', 'Private Room'),
(2, '2024-01-15', 'Semi Private Room'),
(NULL, '2024-01-10', 'General Ward'),  -- Available room
(5, '2024-01-13', 'ICU');

-- Insert sample lab tests
INSERT INTO `lab_test` (`appointment_id`, `test_type`, `result`, `test_date`) VALUES
(1, 'Blood Test', 'Normal levels', '2024-01-15'),
(2, 'MRI', 'No abnormalities detected', '2024-01-15'),
(3, 'ECG', NULL, CURDATE()),  -- Pending result
(4, 'Ultrasound', NULL, CURDATE());  -- Pending result

-- Insert sample emergency contacts
INSERT INTO `emergency_contact` (`patient_id`, `contact_name`, `relationship`, `phone`) VALUES
(1, 'Anita Sharma', 'Wife', '9876543250'),
(2, 'Rahul Patel', 'Husband', '9876543251'),
(3, 'Neha Kumar', 'Sister', '9876543252');

-- Insert sample billing
INSERT INTO `billing` (`treatment_id`, `total_amount`, `status`) VALUES
(1, 1500.00, 'approved'),
(2, 1200.00, 'pending'),
(3, 800.00, 'pending'),
(4, 2000.00, 'approved');

-- =============================================
-- 2. NOW, EXECUTE ALL THE QUERIES
-- =============================================

-- PATIENT MANAGEMENT QUERIES
-- 1. Search for a patient by name or phone
SELECT * FROM `patients`
WHERE `name` LIKE '%Raj%' OR `phone` LIKE '%9876543210%';

-- 2. View all patients
SELECT * FROM `patients`;

-- APPOINTMENT MANAGEMENT QUERIES
-- 3. View all appointments for today
SELECT * FROM `patient_appointments`
WHERE DATE(`date`) = CURDATE()
ORDER BY `date`;

-- 4. View appointments for a specific doctor
SELECT * FROM `patient_appointments`
WHERE `doctor_name` = 'Dr. Michael Brown';

-- 5. View patient's appointment history
SELECT * FROM `patient_appointments`
WHERE `patient_name` = 'Raj Sharma'
ORDER BY `date` DESC;

-- DOCTOR AND STAFF QUERIES
-- 6. Find doctors by specialization
SELECT * FROM `doctors`
WHERE `specialization` = 'Cardiologist';

-- 7. View doctor's schedule
SELECT * FROM `patient_appointments`
WHERE `doctor_name` = 'Dr. Michael Brown'
AND `date` BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY `date`;

-- TREATMENT AND MEDICATION QUERIES
-- 8. View patient's current medications
SELECT
    `p`.`name` AS `patient_name`,
    `m`.`medicine_name`,
    `m`.`dosage`,
    `m`.`frequency`,
    `m`.`duration`
FROM `patients` `p`
JOIN `appointment` `a` ON `p`.`patient_id` = `a`.`patient_id`
JOIN `treatment` `t` ON `a`.`appointment_id` = `t`.`appointment_id`
JOIN `medication` `m` ON `t`.`treatment_id` = `m`.`treatment_id`
WHERE `p`.`patient_id` = 1;

-- LAB TEST QUERIES
-- 9. View pending lab tests
SELECT
    `p`.`name` AS `patient_name`,
    `lt`.`test_type`,
    `lt`.`test_date`,
    `d`.`name` AS `doctor_name`
FROM `lab_test` `lt`
JOIN `appointment` `a` ON `lt`.`appointment_id` = `a`.`appointment_id`
JOIN `patients` `p` ON `a`.`patient_id` = `p`.`patient_id`
JOIN `doctors` `d` ON `a`.`doctor_id` = `d`.`doctor_id`
WHERE `lt`.`result` IS NULL;

-- ROOM MANAGEMENT QUERIES
-- 10. View current room occupancy
SELECT * FROM `room_occupancy`
WHERE `patient_name` IS NOT NULL;

-- 11. Find available rooms by type
SELECT `room_id`, `room_type`
FROM `rooms`
WHERE `patient_id` IS NULL;

-- BILLING AND FINANCIAL QUERIES
-- 12. View patient's billing summary
SELECT * FROM `patient_billing_summary`
WHERE `patient_id` = 1;

-- 13. Calculate total revenue
SELECT SUM(`total_amount`) AS `total_revenue`
FROM `billing`
WHERE `status` = 'approved';

-- 14. View pending payments
SELECT
    `p`.`name` AS `patient_name`,
    `b`.`total_amount`,
    `b`.`billing_id`
FROM `billing` `b`
JOIN `treatment` `t` ON `b`.`treatment_id` = `t`.`treatment_id`
JOIN `appointment` `a` ON `t`.`appointment_id` = `a`.`appointment_id`
JOIN `patients` `p` ON `a`.`patient_id` = `p`.`patient_id`
WHERE `b`.`status` = 'pending';

-- REPORTING AND ANALYTICS QUERIES
-- 15. Monthly appointment statistics
SELECT
    DATE_FORMAT(`date`, '%Y-%m') AS `month`,
    `status`,
    COUNT(*) AS `appointment_count`
FROM `appointment`
GROUP BY DATE_FORMAT(`date`, '%Y-%m'), `status`
ORDER BY `month` DESC;

-- 16. Doctor performance report
SELECT
    `d`.`name` AS `doctor_name`,
    `d`.`specialization`,
    COUNT(DISTINCT `a`.`patient_id`) AS `unique_patients`,
    COUNT(*) AS `total_appointments`
FROM `doctors` `d`
JOIN `appointment` `a` ON `d`.`doctor_id` = `a`.`doctor_id`
WHERE `a`.`status` = 'completed'
GROUP BY `d`.`doctor_id`
ORDER BY `total_appointments` DESC;

-- 17. Most common treatments
SELECT
    `description` AS `treatment_description`,
    COUNT(*) AS `frequency`,
    AVG(`cost`) AS `average_cost`
FROM `treatment`
GROUP BY `description`
ORDER BY `frequency` DESC;

-- 18. Room utilization report
SELECT
    `room_type`,
    COUNT(*) AS `total_rooms`,
    COUNT(`patient_id`) AS `occupied_rooms`,
    ROUND((COUNT(`patient_id`) / COUNT(*)) * 100, 2) AS `occupancy_rate`
FROM `rooms`
GROUP BY `room_type`;

-- 19. Patient age distribution
SELECT
    CASE
        WHEN `age` < 18 THEN 'Child'
        WHEN `age` BETWEEN 18 AND 35 THEN 'Young Adult'
        WHEN `age` BETWEEN 36 AND 55 THEN 'Middle Age'
        ELSE 'Senior'
    END AS `age_group`,
    COUNT(*) AS `patient_count`
FROM `patients`
GROUP BY `age_group`
ORDER BY `age_group`;

-- SEARCH AND FILTER QUERIES
-- 20. Search patients with multiple criteria
SELECT * FROM `patients`
WHERE (`name` LIKE '%Raj%' OR `phone` LIKE '%9876%')
AND `age` BETWEEN 30 AND 40
AND `gender` = 'male';

-- 21. Find appointments by date range
SELECT * FROM `patient_appointments`
WHERE `date` BETWEEN '2024-01-15' AND '2024-01-17'
ORDER BY `date`;

-- 22. View medication history for a patient
SELECT
    `p`.`name` AS `patient_name`,
    `m`.`medicine_name`,
    `m`.`dosage`,
    `m`.`frequency`,
    `m`.`duration`,
    `a`.`date` AS `prescription_date`
FROM `patients` `p`
JOIN `appointment` `a` ON `p`.`patient_id` = `a`.`patient_id`
JOIN `treatment` `t` ON `a`.`appointment_id` = `t`.`appointment_id`
JOIN `medication` `m` ON `t`.`treatment_id` = `m`.`treatment_id`
WHERE `p`.`patient_id` = 1
ORDER BY `a`.`date` DESC;

-- DATA INTEGRITY QUERIES
-- 23. Find orphan records (appointments without treatments)
SELECT `a`.*
FROM `appointment` `a`
LEFT JOIN `treatment` `t` ON `a`.`appointment_id` = `t`.`appointment_id`
WHERE `t`.`treatment_id` IS NULL
AND `a`.`status` = 'completed';

-- 24. Database health check - count records per table
SELECT
    'patients' AS `table_name`, COUNT(*) AS `record_count` FROM `patients`
UNION ALL
SELECT 'doctors', COUNT(*) FROM `doctors`
UNION ALL
SELECT 'appointment', COUNT(*) FROM `appointment`
UNION ALL
SELECT 'treatment', COUNT(*) FROM `treatment`
UNION ALL
SELECT 'billing', COUNT(*) FROM `billing`
UNION ALL
SELECT 'medication', COUNT(*) FROM `medication`
UNION ALL
SELECT 'rooms', COUNT(*) FROM `rooms`
UNION ALL
SELECT 'lab_test', COUNT(*) FROM `lab_test`
UNION ALL
SELECT 'emergency_contact', COUNT(*) FROM `emergency_contact`
UNION ALL
SELECT 'staff', COUNT(*) FROM `staff`;

-- =============================================
-- 3. TEST SOME SPECIFIC SCENARIOS
-- =============================================

-- Test: Update an appointment status
UPDATE `appointment`
SET `status` = 'completed'
WHERE `appointment_id` = 3;

-- Test: Add lab test result
UPDATE `lab_test`
SET `result` = 'Blood pressure: 120/80 mmHg'
WHERE `lab_test_id` = 3;

-- Test: Approve a pending bill
UPDATE `billing`
SET `status` = 'approved'
WHERE `billing_id` = 2;

-- Verify the updates
SELECT * FROM `patient_appointments` WHERE `appointment_id` = 3;
SELECT * FROM `lab_test` WHERE `lab_test_id` = 3;
SELECT * FROM `billing` WHERE `billing_id` = 2;

-- =============================================
-- 4. QUERIES ON VIEWS
-- =============================================

-- Query 1: View all patient appointments using the view
SELECT * FROM `patient_appointments`;

-- Query 2: Filter appointments by status using the view
SELECT * FROM `patient_appointments`
WHERE `status` = 'scheduled'
ORDER BY `date`;

-- Query 3: Find today's appointments using the view
SELECT * FROM `patient_appointments`
WHERE DATE(`date`) = CURDATE()
ORDER BY `date`;

-- Query 4: View patient billing summary using the view
SELECT * FROM `patient_billing_summary`;

-- Query 5: Filter billing by status using the view
SELECT * FROM `patient_billing_summary`
WHERE `billing_status` = 'pending';

-- Query 6: Find high-value bills using the view
SELECT * FROM `patient_billing_summary`
WHERE `total_amount` > 1000
ORDER BY `total_amount` DESC;

-- Query 7: View room occupancy using the view
SELECT * FROM `room_occupancy`;

-- Query 8: Find occupied rooms only using the view
SELECT * FROM `room_occupancy`
WHERE `patient_name` IS NOT NULL;

-- Query 9: Find available rooms using the view
SELECT * FROM `room_occupancy`
WHERE `patient_name` IS NULL;

-- Query 10: Complex query combining multiple views
SELECT
    `pa`.`patient_name`,
    `pa`.`doctor_name`,
    `pa`.`specialization`,
    `pa`.`date` AS `appointment_date`,
    `pbs`.`total_amount`,
    `pbs`.`billing_status`,
    `ro`.`room_type`
FROM `patient_appointments` `pa`
LEFT JOIN `patient_billing_summary` `pbs` ON `pa`.`appointment_id` = `pbs`.`appointment_id`
LEFT JOIN `room_occupancy` `ro` ON `pa`.`patient_id` = `ro`.`patient_id`
WHERE `pa`.`status` = 'completed'
ORDER BY `pa`.`date` DESC;

-- Query 11: Doctor-wise appointment summary using view
SELECT
    `doctor_name`,
    `specialization`,
    COUNT(*) AS `total_appointments`,
    SUM(CASE WHEN `status` = 'completed' THEN 1 ELSE 0 END) AS `completed_appointments`,
    SUM(CASE WHEN `status` = 'scheduled' THEN 1 ELSE 0 END) AS `scheduled_appointments`
FROM `patient_appointments`
GROUP BY `doctor_name`, `specialization`
ORDER BY `total_appointments` DESC;

-- Query 12: Patient with their billing details using views
SELECT
    `pa`.`patient_name`,
    `pa`.`doctor_name`,
    `pa`.`date`,
    `pbs`.`treatment_description`,
    `pbs`.`total_amount`,
    `pbs`.`billing_status`
FROM `patient_appointments` `pa`
JOIN `patient_billing_summary` `pbs` ON `pa`.`appointment_id` = `pbs`.`appointment_id`
ORDER BY `pa`.`patient_name`, `pa`.`date`;

-- Query 13: Room utilization analysis using view
SELECT
    `room_type`,
    COUNT(*) AS `total_rooms`,
    COUNT(`patient_name`) AS `occupied_rooms`,
    COUNT(*) - COUNT(`patient_name`) AS `available_rooms`,
    ROUND((COUNT(`patient_name`) / COUNT(*)) * 100, 2) AS `occupancy_rate`
FROM `room_occupancy`
GROUP BY `room_type`
ORDER BY `occupancy_rate` DESC;

-- Query 14: Daily appointment summary using view
SELECT
    DATE(`date`) AS `appointment_date`,
    COUNT(*) AS `total_appointments`,
    SUM(CASE WHEN `status` = 'completed' THEN 1 ELSE 0 END) AS `completed`,
    SUM(CASE WHEN `status` = 'scheduled' THEN 1 ELSE 0 END) AS `scheduled`,
    SUM(CASE WHEN `status` = 'cancelled' THEN 1 ELSE 0 END) AS `cancelled`
FROM `patient_appointments`
GROUP BY DATE(`date`)
ORDER BY `appointment_date` DESC;

-- Query 15: Patient summary with multiple views
SELECT
    `p`.`name` AS `patient_name`,
    `p`.`age`,
    `p`.`gender`,
    COUNT(`pa`.`appointment_id`) AS `total_appointments`,
    COUNT(`ro`.`room_id`) AS `times_admitted`,
    COALESCE(SUM(`pbs`.`total_amount`), 0) AS `total_billing_amount`
FROM `patients` `p`
LEFT JOIN `patient_appointments` `pa` ON `p`.`patient_id` = `pa`.`patient_id`
LEFT JOIN `room_occupancy` `ro` ON `p`.`patient_id` = `ro`.`patient_id`
LEFT JOIN `patient_billing_summary` `pbs` ON `p`.`patient_id` = `pbs`.`patient_id`
GROUP BY `p`.`patient_id`, `p`.`name`, `p`.`age`, `p`.`gender`
ORDER BY `total_billing_amount` DESC;
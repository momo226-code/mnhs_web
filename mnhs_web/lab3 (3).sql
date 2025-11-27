-- =========================================
-- CREATE DATABASE + USER
-- =========================================
CREATE DATABASE IF NOT EXISTS lab3;
USE lab3;

-- =========================================
-- TABLE: Hospital
-- =========================================
CREATE TABLE Hospital (
    hospital_id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    address VARCHAR(255)
);

-- =========================================
-- TABLE: Department
-- =========================================
CREATE TABLE Department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    hospital_id INT NOT NULL,

    FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id)
        ON DELETE CASCADE
);

-- =========================================
-- TABLE: Patient
-- =========================================
CREATE TABLE Patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    insurance_type VARCHAR(50)
);

-- =========================================
-- TABLE: Staff
-- =========================================
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(100),
    department_id INT NOT NULL,

    FOREIGN KEY (department_id) REFERENCES Department(department_id)
        ON DELETE SET NULL
);

-- =========================================
-- TABLE: Medication
-- =========================================
CREATE TABLE Medication (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    therapeutic_class VARCHAR(100),
    unit_price DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    hospital_id INT NOT NULL,

    FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id)
        ON DELETE CASCADE
);

-- =========================================
-- TABLE: Appointment
-- =========================================
CREATE TABLE Appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    staff_id INT NOT NULL,
    department_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',

    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
        ON DELETE CASCADE,

    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
        ON DELETE SET NULL,

    FOREIGN KEY (department_id) REFERENCES Department(department_id)
        ON DELETE CASCADE
);

-- =========================================
-- SAMPLE DATA (optional)
-- =========================================

INSERT INTO Hospital (hospital_name, city, address)
VALUES 
('CHU Rabat', 'Rabat', 'Avenue Mohammed V'),
('UM6P Hospital', 'Benguerir', 'Green City'),
('CHU Casablanca', 'Casablanca', 'Centre-ville');

INSERT INTO Department (department_name, hospital_id)
VALUES
('Cardiology', 1),
('Emergency', 1),
('Radiology', 2),
('Surgery', 3);

INSERT INTO Patient (first_name, last_name, date_of_birth, insurance_type)
VALUES
('Ahmed', 'El Mansouri', '1990-05-12', 'CNOPS'),
('Sara', 'Benali', '1985-07-20', 'CNSS'),
('Youssef', 'Hajji', '2000-01-10', 'Private');

INSERT INTO Staff (first_name, last_name, role, department_id)
VALUES
('Imane', 'Khalil', 'Doctor', 1),
('Omar', 'Rami', 'Nurse', 2),
('Samira', 'Loukili', 'Surgeon', 4);

INSERT INTO Medication (name, therapeutic_class, unit_price, stock_quantity, hospital_id)
VALUES
('Amoxicillin', 'Antibiotic', 120, 50, 1),
('Paracetamol', 'Analgesic', 30, 10, 1),
('Ibuprofen', 'Anti-Inflammatory', 45, 80, 2),
('Ceftriaxone', 'Antibiotic', 180, 5, 3);

INSERT INTO Appointment (patient_id, staff_id, department_id, appointment_date, status)
VALUES
(1, 1, 1, '2025-01-20 10:00:00', 'Scheduled'),
(2, 2, 2, '2025-01-22 14:30:00', 'Completed'),
(3, 1, 1, '2025-01-25 09:00:00', 'Scheduled');

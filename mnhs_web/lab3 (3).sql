CREATE DATABASE MNHS;
USE MNHS;

CREATE TABLE Clinical_Activities (
    caid INT PRIMARY KEY AUTO_INCREMENT,
    ca_time TIME,
    ca_date DATE,
    iid INT,
    did INT,
    FOREIGN KEY (iid) REFERENCES Patients(iid),
    FOREIGN KEY (did) REFERENCES Departement(did)
);

CREATE TABLE Appointment (
    caid INT PRIMARY KEY AUTO_INCREMENT,
    reason VARCHAR(50),
    a_status VARCHAR(100),
    FOREIGN KEY (caid) REFERENCES Clinical_Activities(caid)
);

CREATE TABLE Emergency (
    caid INT PRIMARY KEY AUTO_INCREMENT,
    triage_level VARCHAR(100),
    outcome VARCHAR(100),
    FOREIGN KEY (caid) REFERENCES Clinical_Activities(caid)
);

CREATE TABLE Patients (
    iid INT PRIMARY KEY AUTO_INCREMENT,
    cin VARCHAR(50),
    p_name VARCHAR(50),
    sex VARCHAR(10),
    birth DATE,
    blood_group VARCHAR(3),
    phone VARCHAR(15)
);

CREATE TABLE Departement (
    did INT PRIMARY KEY AUTO_INCREMENT,
    d_name VARCHAR(50),
    specialty VARCHAR(50)
);


CREATE TABLE Hospital (
    hid INT PRIMARY KEY AUTO_INCREMENT,
    h_name VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50),
    did INT NOT NULL,
    FOREIGN KEY (did) REFERENCES Departement(did)
);


INSERT INTO Patients (cin, p_name, sex, birth, blood_group, phone) 
VALUES
('CD908479', 'Youssef', 'Male', '2000-05-15', 'A+', '1234567890'),
('AB123456', 'Sara', 'Female', '1995-08-22', 'B-', '0987654321');

INSERT INTO Departement (d_name, specialty) 
VALUES
('Cardiology', 'Heart-related treatments'),
('Neurology', 'Brain and nervous system treatments');

INSERT INTO Clinical_Activities (ca_time, ca_date, iid, did) 
VALUES
('10:00:00', '2023-10-01', 1, 1),
('14:30:00', '2023-10-02', 2, 2);

INSERT INTO Appointment (caid, reason, a_status) 
VALUES
(1, 'Routine checkup', 'Scheduled'),
(2, 'Specialist consultation', 'Completed');

INSERT INTO Emergency (caid, triage_level, outcome) 
VALUES
(1, 'Level 3', 'Admitted'),
(2, 'Level 1', 'Discharged');


INSERT INTO Hospital (h_name, city, region, did) 
VALUES
('UM6P Hospital', 'Benguerir', 'Rehamna', 1),
('Moulay Ismail', 'Meknès', 'Fès-Meknès', 2);

SELECT p_name,
FROM Patients
JOIN Clinical_Activities ON Patients.iid = Clinical_Activities.iid
JOIN Appointment ON Clinical_Activities.caid = Appointment.caid
JOIN Hospital ON Clinical_Activities.did = Hospital.did
WHERE Appointment.a_status = 'Scheduled' AND Hospital.city = 'Benguerir';
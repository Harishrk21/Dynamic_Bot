CREATE TABLE Appointments (
    Client_ID INT,
    Appointment_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT,
    POC_ID INT,
    Appointment_Date DATE,
    Appointment_Time TIME,
    Appointment_Type ENUM('Tele Consultation', 'Direct Consultation', 'Emergency') DEFAULT 'Direct Consultation',  -- New column to store type of appointment
    Status ENUM('Confirmed', 'Rescheduled', 'Cancelled', 'Pending', 'Not_Availed') DEFAULT 'Pending',
    Is_Active BOOLEAN DEFAULT TRUE,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    JSON_DATA JSON,
    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (POC_ID) REFERENCES POC(POC_ID)
);

ALTER TABLE Appointments 
MODIFY Appointment_Type ENUM('Tele Consultation', 'Direct Consultation', 'Emergency', 'Master Health Checkup') DEFAULT 'Direct Consultation';

truncate table appointments;
drop table appointments;
use chatbotdynamic;
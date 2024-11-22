CREATE TABLE Templates (
    TEMPLATE_ID INT AUTO_INCREMENT PRIMARY KEY,
    CLIENT_ID INT NOT NULL,
    TEMPLATE_NAME VARCHAR(255) NOT NULL,
    TEMPLATE_TEXT TEXT NOT NULL,
    FOREIGN KEY (CLIENT_ID) REFERENCES Client(CLIENT_ID)
);

INSERT INTO Templates (CLIENT_ID, TEMPLATE_NAME, TEMPLATE_TEXT)
VALUES
(1, 'CONFIRM', 'Here are your appointment details:\n\nName: [User_Name]\nEmail: [User_Email]\nLocation: [User_Location]\nAppointment Type: [Appointment_Type]\nDepartment: [Department]\nDoctor: [POC]\nAppointment Date: [Appointment_Date]\nAppointment Time: [Appointment_Time]'),
(1, 'FINALIZE', 'Appointment confirmed. Your Appointment ID: [Appointment_ID]');

INSERT INTO Templates (CLIENT_ID, TEMPLATE_NAME, TEMPLATE_TEXT)
VALUES
(1, 'CONFIRM_EMERGENCY', 'Here are your appointment details:\n\nName: [User_Name]\nEmail: [User_Email]\nLocation: [User_Location]\nAppointment Type: [Appointment_Type]\nEmergency Reason: [Emergency_Reason]'),
(1, 'FINALIZE_EMERGENCY', 'Appointment confirmed. We are waiting for your arrival!!!');

INSERT INTO Templates (CLIENT_ID, TEMPLATE_NAME, TEMPLATE_TEXT)
VALUES
(1, 'FINALIZE_TELE', 'Appointment confirmed. Your Appointment ID: [Appointment_ID]\n Your G-meet Link is given below!');

INSERT INTO Templates (CLIENT_ID, TEMPLATE_NAME, TEMPLATE_TEXT)
VALUES
(1, 'Cancel_Appointment_Request', "Your appointment request has been canceled. You can start over if you'd like to make a new appointment");


INSERT INTO Templates (CLIENT_ID, TEMPLATE_NAME, TEMPLATE_TEXT)
VALUES
(1, 'CONFIRM_CHECKUP', 'Here are your appointment details:\n\nName: [User_Name]\nEmail: [User_Email]\nLocation: [User_Location]\nAppointment Type: [Appointment_Type]\nAppointment Date: [Appointment_Date]\nAppointment Time: [Appointment_Time]');

CREATE TABLE Menu (
    Menu_ID INT PRIMARY KEY AUTO_INCREMENT,
    Client_ID INT,
    Language VARCHAR(10),
    Menu_Name VARCHAR(100),
    Display_Order INT,
    Parent_Menu_ID INT DEFAULT 0,
    Action VARCHAR(255),
    Header_Message VARCHAR(200),
    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID) ON DELETE CASCADE
);
INSERT INTO Menu (Menu_ID, Client_ID, Language, Menu_Name, Display_Order, Parent_Menu_ID, Action, Header_Message) VALUES
(1, 1, 'ENG', 'Book Appointment', 1, 0, '', 'Select your preference'),
(2, 1, 'ENG', 'Reschedule', 2, 0, '', ''),
(3, 1, 'ENG', 'Cancel', 3, 0, '', ''),
(4, 1, 'ENG', 'Emergency', 1, 1, '', ''),
(5, 1, 'ENG', 'Tele Consultation', 2, 1, '', ''),
(6, 1, 'ENG', 'Direct Consultation', 3, 1, '', ''),
(7, 1, 'ENG', 'Share Your Location', 1, 4, 'CAPTURE_USER_INPUT', 'Share Your Location'),
(8, 1, 'ENG', 'Enter Name Emergency', 1, 7, 'LIST:EMERGENCY_REASON', 'What is the Emergency'),
(9, 1, 'ENG', 'Confirm Emergency Details', 1, 8, 'CONFIRM', 'Please Confirm Your details'),
(10, 1, 'ENG', 'Finalize Emergency', 1, 9, 'FINALIZE:[MESSAGE TEMPLATE NAME]', 'Waiting for your arrival'),
(11, 1, 'ENG', 'Show Department List', 1, 6, 'LIST:DEPARTMENT', 'Select the Department'),
(12, 1, 'ENG', 'Select Doctor Direct', 1, 11, 'POC:[DEPARTMENT_ID]', 'Select the doctor'),
(13, 1, 'ENG', 'Select Date Direct', 1, 12, 'FETCH_AVAILABLE_DATES_DIRECT', 'Select the date'),
(14, 1, 'ENG', 'Select Time Direct', 1, 13, 'FETCH_AVAILABLE_TIMES_DIRECT', 'Select the time'),
(15, 1, 'ENG', 'Enter Name Direct', 1, 14, 'CAPTURE_USER_INPUT:[NoValidation]', 'Enter Your Name'),
(16, 1, 'ENG', 'Enter Email Direct', 2, 15, 'CAPTURE_USER_INPUT:[emailValidation]', 'Enter Your Email'),
(17, 1, 'ENG', 'Enter Mobile Direct', 3, 16, 'CAPTURE_USER_INPUT:[NumberValidation]', 'Enter Your Phone Number'),
(18, 1, 'ENG', 'Confirm Direct Appointment', 1, 17, 'CONFIRM', 'Please Confirm Your details'),
(19, 1, 'ENG', 'Finalize Direct Appointment', 1, 18, 'FINALIZE:[MESSAGE TEMPLATE NAME]', ''),
(20, 1, 'ENG', 'Select Doctor Tele', 1, 6, '', 'Select a doctor'),
(21, 1, 'ENG', 'Select Date Tele', 1, 20, '', 'Select a date'),
(22, 1, 'ENG', 'Select Time Tele', 1, 21, '', 'Select a time'),
(23, 1, 'ENG', 'Enter Name Tele', 1, 22, '', 'Enter Your Name'),
(24, 1, 'ENG', 'Enter Email Tele', 2, 23, '', 'Enter Your E-Mail'),
(25, 1, 'ENG', 'Enter Mobile Tele', 3, 24, '', 'Enter Your Phone Number'),
(26, 1, 'ENG', 'Enter Location Tele', 1, 25, '', 'Enter Your Location'),
(27, 1, 'ENG', 'Confirm Tele Appointment', 1, 26, '', 'Please Confirm Your details'),
(28, 1, 'ENG', 'Finalize Tele Appointment', 1, 27, '', 'Your gmeet link is given below'),
(29, 1, 'ENG', 'Enter Appointment ID for Reschedule', 1, 3, '', 'Your appointment has been rescheduled'),
(30, 1, 'ENG', 'Enter Appointment ID for Cancel', 1, 4, '', 'Your appointment has been cancelled');



UPDATE `chatbotdynamic`.`menu` SET `Action` = 'FINALIZE:MESSAGE TEMPLATE NAME' WHERE (`Menu_ID` = '10');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'POC:DEPARTMENT_ID' WHERE (`Menu_ID` = '12');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'CAPTURE_USER_INPUT:NoValidation' WHERE (`Menu_ID` = '15');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'CAPTURE_USER_INPUT:emailValidation' WHERE (`Menu_ID` = '16');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'CAPTURE_USER_INPUT:NumberValidation' WHERE (`Menu_ID` = '17');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'FINALIZE:MESSAGE TEMPLATE NAME' WHERE (`Menu_ID` = '19');

DELETE FROM `chatbotdynamic`.`menu` WHERE (`Menu_ID` = '15');
DELETE FROM `chatbotdynamic`.`menu` WHERE (`Menu_ID` = '16');
DELETE FROM `chatbotdynamic`.`menu` WHERE (`Menu_ID` = '17');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '15', `Parent_Menu_ID` = '14' WHERE (`Menu_ID` = '18');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '16', `Parent_Menu_ID` = '15' WHERE (`Menu_ID` = '19');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '17' WHERE (`Menu_ID` = '20');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '18' WHERE (`Menu_ID` = '21');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '19' WHERE (`Menu_ID` = '22');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '20' WHERE (`Menu_ID` = '23');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '21' WHERE (`Menu_ID` = '24');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '22' WHERE (`Menu_ID` = '25');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '23' WHERE (`Menu_ID` = '26');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '24' WHERE (`Menu_ID` = '27');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '25' WHERE (`Menu_ID` = '28');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '26' WHERE (`Menu_ID` = '29');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '27' WHERE (`Menu_ID` = '30');

UPDATE menu
SET CLIENT_ID = 1,
    LANGUAGE = 'ENG',
    MENU_NAME = 'Confirm Direct Appointment',
    DISPLAY_ORDER = 1,
    PARENT_MENU_ID = 14,
    ACTION = 'CONFIRM:APPOINTMENT_DETAILS',
    HEADER_MESSAGE = 'Please confirm your details.'
WHERE MENU_ID = 15;

UPDATE menu
SET CLIENT_ID = 1,
    LANGUAGE = 'ENG',
    MENU_NAME = 'Finalize Direct Appointment',
    DISPLAY_ORDER = 1,
    PARENT_MENU_ID = 15,
    ACTION = 'FINALIZE:UPDATE_STATUS',
    HEADER_MESSAGE = 'Appointment confirmed. ID: {ID}'
WHERE MENU_ID = 16;

UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '17' WHERE (`Menu_ID` = '18');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '18' WHERE (`Menu_ID` = '19');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '19' WHERE (`Menu_ID` = '20');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '20' WHERE (`Menu_ID` = '21');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '21' WHERE (`Menu_ID` = '22');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '22' WHERE (`Menu_ID` = '23');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '23' WHERE (`Menu_ID` = '24');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '24' WHERE (`Menu_ID` = '25');

UPDATE `chatbotdynamic`.`menu` SET `Action` = 'LIST~EMERGENCY_REASON' WHERE (`Menu_ID` = '8');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'FINALIZE~MESSAGE TEMPLATE NAME' WHERE (`Menu_ID` = '10');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Department~LIST~DEPARTMENT' WHERE (`Menu_ID` = '11');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'POC_name~POC~DEPARTMENT_ID' WHERE (`Menu_ID` = '12');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'CONFIRM~APPOINTMENT_DETAILS' WHERE (`Menu_ID` = '15');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'FINALIZE~UPDATE_STATUS' WHERE (`Menu_ID` = '16');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Date~FETCH_AVAILABLE_DATES_DIRECT' WHERE (`Menu_ID` = '13');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Time~FETCH_AVAILABLE_TIMES_DIRECT' WHERE (`Menu_ID` = '14');


UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Appointment_Type~LIST~DEPARTMENT' WHERE (`Menu_ID` = '11');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Department~POC~DEPARTMENT_ID' WHERE (`Menu_ID` = '12');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Poc_name~FETCH_AVAILABLE_DATES_DIRECT' WHERE (`Menu_ID` = '13');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Appointment_Date~FETCH_AVAILABLE_TIMES_DIRECT' WHERE (`Menu_ID` = '14');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Appointment_Time~CONFIRM' WHERE (`Menu_ID` = '15');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Confirm_Status~FINALIZE' WHERE (`Menu_ID` = '16');
UPDATE `chatbotdynamic`.`menu` SET `Header_Message` = 'Appointment confirmed.Your Appointment ID: [Appointment_ID]' WHERE (`Menu_ID` = '16');


UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Show Emergency Reasons List', `Action` = 'Appointment_Type~LIST~EMERGENCY_REASON', `Header_Message` = 'Select the Emergency Reason' WHERE (`Menu_ID` = '7');
DELETE FROM `chatbotdynamic`.`menu` WHERE (`Menu_ID` = '8');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '8', `Parent_Menu_ID` = '7' WHERE (`Menu_ID` = '9');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '9', `Parent_Menu_ID` = '8' WHERE (`Menu_ID` = '10');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '10' WHERE (`Menu_ID` = '11');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '11', `Parent_Menu_ID` = '10' WHERE (`Menu_ID` = '12');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '12', `Parent_Menu_ID` = '11' WHERE (`Menu_ID` = '13');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '13', `Parent_Menu_ID` = '12' WHERE (`Menu_ID` = '14');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '14', `Parent_Menu_ID` = '13' WHERE (`Menu_ID` = '15');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '15', `Parent_Menu_ID` = '14' WHERE (`Menu_ID` = '16');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '16' WHERE (`Menu_ID` = '17');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '17', `Parent_Menu_ID` = '16' WHERE (`Menu_ID` = '18');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '18', `Parent_Menu_ID` = '17' WHERE (`Menu_ID` = '19');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '19', `Parent_Menu_ID` = '18' WHERE (`Menu_ID` = '20');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '20', `Parent_Menu_ID` = '19' WHERE (`Menu_ID` = '21');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '21', `Parent_Menu_ID` = '20' WHERE (`Menu_ID` = '22');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '22', `Parent_Menu_ID` = '21' WHERE (`Menu_ID` = '23');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '23', `Parent_Menu_ID` = '22' WHERE (`Menu_ID` = '24');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '24', `Parent_Menu_ID` = '23' WHERE (`Menu_ID` = '25');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '25', `Parent_Menu_ID` = '2' WHERE (`Menu_ID` = '26');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '26', `Parent_Menu_ID` = '3' WHERE (`Menu_ID` = '27');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Emergency_Reason~CONFIRM_EMERGENCY' WHERE (`Menu_ID` = '8');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Confirm_Status~FINALIZE_EMERGENCY' WHERE (`Menu_ID` = '9');

-- TELE
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Select Department Tele', `Action` = 'Appointment_Type~LIST~DEPARTMENT', `Header_Message` = 'Select a department' WHERE (`Menu_ID` = '16');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Select Doctor Tele', `Action` = 'Department~POC~DEPARTMENT_ID', `Header_Message` = 'Select a doctor' WHERE (`Menu_ID` = '17');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Select Date Tele', `Action` = 'Poc_name~FETCH_AVAILABLE_DATES_DIRECT', `Header_Message` = 'Select a date' WHERE (`Menu_ID` = '18');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Select Time Tele', `Action` = 'Appointment_Date~FETCH_AVAILABLE_TIMES_DIRECT', `Header_Message` = 'Select a time' WHERE (`Menu_ID` = '19');
DELETE FROM `chatbotdynamic`.`menu` WHERE (`Menu_ID` = '20');
DELETE FROM `chatbotdynamic`.`menu` WHERE (`Menu_ID` = '21');
DELETE FROM `chatbotdynamic`.`menu` WHERE (`Menu_ID` = '22');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '20', `Parent_Menu_ID` = '19', `Action` = 'Appointment_Time~CONFIRM' WHERE (`Menu_ID` = '23');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '21', `Parent_Menu_ID` = '20', `Action` = 'Confirm_Status~FINALIZE_TELE' WHERE (`Menu_ID` = '24');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '22' WHERE (`Menu_ID` = '25');
UPDATE `chatbotdynamic`.`menu` SET `Menu_ID` = '23' WHERE (`Menu_ID` = '26');


UPDATE menu
SET Menu_ID = Menu_ID + 20
WHERE Menu_ID >= 8 AND Client_ID = 1;

INSERT INTO menu (Menu_ID, Client_ID, Language, Menu_Name, Display_Order, Parent_Menu_ID, Action, Header_Message) VALUES
(8, 1, 'ENG', 'Master Health Checkup', 4, 1, '', NULL),
(9, 1, 'ENG', 'Select Date Checkup', 1, 8, 'Appointment_Type~FETCH_AVAILABLE_DATES_DIRECT', 'Select a date'),
(10, 1, 'ENG', 'Select Time Checkup', 1, 9, 'Appointment_Date~FETCH_AVAILABLE_TIMES_DIRECT', 'Select a time'),
(11, 1, 'ENG', 'Confirm Checkup Appointment', 1, 10, 'Appointment_Time~CONFIRM_CHECKUP', 'Please Confirm Your details'),
(12, 1, 'ENG', 'Finalize Checkup Appointment', 1, 11, 'Confirm_Status~FINALIZE', 'Appointment is confirmed');

UPDATE menu
SET Menu_ID = Menu_ID - 15
WHERE Menu_ID >= 28 AND Client_ID = 1;

UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Show Emergency Reasons List', `Parent_Menu_ID` = '4', `Action` = 'Appointment_Type~LIST~EMERGENCY_REASON', `Header_Message` = 'Select the Emergency Reason' WHERE (`Menu_ID` = '12');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Master Health Checkup', `Display_Order` = '4', `Parent_Menu_ID` = '1', `Action` = '', `Header_Message` = '' WHERE (`Menu_ID` = '7');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Select Date Checkup', `Display_Order` = '1', `Parent_Menu_ID` = '7', `Action` = 'Appointment_Type~FETCH_AVAILABLE_DATES_DIRECT', `Header_Message` = 'Select a date' WHERE (`Menu_ID` = '8');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Select Time Checkup', `Action` = 'Appointment_Date~FETCH_AVAILABLE_TIMES_DIRECT', `Header_Message` = 'Select a time' WHERE (`Menu_ID` = '9');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Confirm Checkup Appointment', `Action` = 'Appointment_Time~CONFIRM_CHECKUP', `Header_Message` = 'Please Confirm Your details' WHERE (`Menu_ID` = '10');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Finalize Checkup Appointment', `Action` = 'Confirm_Status~FINALIZE', `Header_Message` = 'Appointment is confirmed' WHERE (`Menu_ID` = '11');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '12' WHERE (`Menu_ID` = '13');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '13' WHERE (`Menu_ID` = '14');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '15' WHERE (`Menu_ID` = '16');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '16' WHERE (`Menu_ID` = '17');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '17' WHERE (`Menu_ID` = '18');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '18' WHERE (`Menu_ID` = '19');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '19' WHERE (`Menu_ID` = '20');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '21' WHERE (`Menu_ID` = '22');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '22' WHERE (`Menu_ID` = '23');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '23' WHERE (`Menu_ID` = '24');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '24' WHERE (`Menu_ID` = '25');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '25' WHERE (`Menu_ID` = '26');
UPDATE `chatbotdynamic`.`menu` SET `Action` = 'Appointment_Type~FETCH_AVAILABLE_DATES_CHECKUP' WHERE (`Menu_ID` = '8');


UPDATE `chatbotdynamic`.`menu` SET `Display_Order` = '1' WHERE (`Menu_ID` = '22');
UPDATE `chatbotdynamic`.`menu` SET `Display_Order` = '1' WHERE (`Menu_ID` = '23');
UPDATE `chatbotdynamic`.`menu` SET `Parent_Menu_ID` = '5' WHERE (`Menu_ID` = '21');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Confirm Tele Appointment' WHERE (`Menu_ID` = '25');
INSERT INTO `chatbotdynamic`.`menu` (`Menu_ID`, `Client_ID`, `Language`, `Menu_Name`, `Display_Order`, `Parent_Menu_ID`, `Action`, `Header_Message`) VALUES ('26', '1', 'ENG', 'Finalize Tele Appointment', '1', '25', 'Confirm_Status~FINALIZE_TELE', 'Your gmeet link is given below');
INSERT INTO `chatbotdynamic`.`menu` (`Menu_ID`, `Client_ID`, `Language`, `Menu_Name`, `Display_Order`, `Parent_Menu_ID`, `Header_Message`) VALUES ('27', '1', 'ENG', 'Enter Appointment ID for Reschedule', '1', '2', 'Your appointment has been rescheduled');
INSERT INTO `chatbotdynamic`.`menu` (`Menu_ID`, `Client_ID`, `Language`, `Menu_Name`, `Parent_Menu_ID`, `Header_Message`) VALUES ('28', '1', 'ENG', 'Enter Appointment ID for Cancel', '3', 'Your appointment has been cancelled');


UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Confirm Cancel', `Display_Order` = '1', `Action` = 'Confirm_Status~FINALIZE_CANCEL', `Header_Message` = 'Please Confirm Cancel' WHERE (`Menu_ID` = '28');
DELETE FROM `chatbotdynamic`.`menu` WHERE (`Menu_ID` = '28');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Cancel Appointment', `Action` = '~FETCH_APPOINTMENT_DETAILS', `Header_Message` = 'Cancel you appointment' WHERE (`Menu_ID` = '3');
INSERT INTO `chatbotdynamic`.`menu` (`Menu_ID`, `Client_ID`, `Language`, `Menu_Name`, `Display_Order`, `Parent_Menu_ID`, `Action`, `Header_Message`) VALUES ('29', '1', 'ENG', 'Finalize Cancel', '1', '28', 'Confirm_Status~FINALIZE_CANCEL', 'Appointment cancelled');
UPDATE `chatbotdynamic`.`menu` SET `Action` = '', `Header_Message` = '' WHERE (`Menu_ID` = '3');
UPDATE `chatbotdynamic`.`menu` SET `Menu_Name` = 'Confirm Cancel', `Action` = 'Appointment_Function~FETCH_APPOINTMENT_DETAILS', `Header_Message` = 'Cancel your appointment' WHERE (`Menu_ID` = '28');
UPDATE `chatbotdynamic`.`menu` SET `Header_Message` = 'Please confirm yourappointment details' WHERE (`Menu_ID` = '25');


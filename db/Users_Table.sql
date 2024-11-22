CREATE TABLE Users (
    User_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    User_Name VARCHAR(100),
    User_Contact VARCHAR(20),
    User_Email VARCHAR(100),
    User_Location VARCHAR(500)
);
ALTER TABLE Users ADD UNIQUE (User_Contact);

select * from users;

truncate table users;
SET SQL_SAFE_UPDATES = 0;

delete from users where User_Contact = 919094995418;
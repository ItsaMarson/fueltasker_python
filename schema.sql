-- Active: 1700778018748@@127.0.0.1@3306@fueltaskerpython
CREATE TABLE `vehicleowners` (
  `vo_id` int unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(200) NOT NULL DEFAULT '',
  `lastname` varchar(200) NOT NULL DEFAULT '',
  `phonenumber` varchar(200) NOT NULL DEFAULT '',
  `email` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`vo_id`)
) ENGINE=InnoDB;

CREATE TABLE `users` (
  `userID` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(200) NOT NULL DEFAULT '',
  `password` varchar(200) NOT NULL DEFAULT '',
  `vo_id` int NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB;

DELIMITER $$$
CREATE PROCEDURE create_vehicleowners(
	IN _firstname VARCHAR(200),
    IN _lastname VARCHAR(200),
    IN _email VARCHAR(200),
    IN _phonenumber VARCHAR(200),
    IN _username VARCHAR(200),
    IN _password VARCHAR(200)
)
BEGIN
	DECLARE _vo_id INT;
    DECLARE _userID INT;
    
    INSERT INTO vehicleowners(firstname,lastname,email,phonenumber)
    VALUES (_firstname, _lastname, _email, _phonenumber);
    SET _vo_id = LAST_INSERT_ID();
    
    INSERT INTO users(username,password,vo_id)
    VALUES (_username,_password,_vo_id);
    SET _userID = LAST_INSERT_ID();
    
    SELECT _vo_id, _userID AS VehicleOwners_ID;
END$$$
DELIMITER ;


DELIMITER $$$
CREATE Procedure create_login_vehicleowners(
    IN _firstname VARCHAR(200),
    IN _lastname VARCHAR(200),
    IN _email VARCHAR(200),
    IN _password VARCHAR(200)
)
BEGIN
    DECLARE _vo_id INT;
    DECLARE _userID INT;
    DECLARE email_ VARCHAR(200);
	INSERT INTO vehicleowners (firstname, lastname, email)
    VALUES (_firstname, _lastname, _email);
    SET _vo_id = LAST_INSERT_ID();
    
    SELECT email INTO email_ from vehicleowners where _vo_id = vo_id;
    
    INSERT INTO users (username, password, vo_id)
    VALUES (email_, _password, _vo_id);

    SET _userID = LAST_INSERT_ID();
    SELECT _vo_id, _userID AS vehicle_owners;
END$$$
DELIMITER ;

DELIMITER $$$
CREATE PROCEDURE update_vehicleowners(
	IN _vo_id INT,
	IN _firstname VARCHAR(200),
    IN _lastname VARCHAR(200),
    IN _phonenumber VARCHAR(200),
    IN _email VARCHAR(200)
)
BEGIN
    UPDATE vehicleowners 
		SET firstname = _firstname,
			lastname = _lastname,
            phonenumber = _phonenumber,
            email = _email
		WHERE vo_id = _vo_id;
	SELECT _vo_id AS VehicleIDHasBeenUpdated;
END$$$
DELIMITER ;


DELIMITER $$$
Create procedure delete_vehicleowner(
	IN _vo_id INT
)
BEGIN
	DECLARE vo_id_result INT;
    
	DELETE vehicleowners.* FROM vehicleowners
    INNER JOIN users ON users.vo_id = vehicleowners.vo_id
    WHERE users.userID = _vo_id;
    
    DELETE FROM users 
    WHERE userID = _vo_id;

    SELECT vo_id INTO vo_id_result FROM users
    WHERE vo_id = _vo_id;
END$$$
DELIMITER ;


###

CREATE VIEW vehicle_owners AS
    SELECT vehicleowners.vo_id, vehicleowners.firstname, vehicleowners.lastname, 
            vehicleowners.email,vehicleowners.phonenumber, users.username, users.password FROM vehicleowners
    INNER JOIN users ON users.vo_id = vehicleowners.vo_id;

###
CREATE VIEW login_users AS
	SELECT vehicleowners.vo_id, firstname, lastname, email, users.password FROM vehicleowners
    INNER JOIN users on users.vo_id = vehicleowners.vo_id;


DELIMITER $$$
CREATE TRIGGER after_insert_vehicleowner
AFTER INSERT ON vehicleowners
FOR EACH ROW
BEGIN
    DECLARE email_ VARCHAR(200);
    
    SELECT email INTO email_ FROM vehicleowners WHERE vo_id = NEW.vo_id;
    
    UPDATE users SET username = email_ WHERE vo_id = NEW.vo_id;
END$$$
DELIMITER ;
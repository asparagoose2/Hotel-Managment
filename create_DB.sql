-- To create the Databse rub all of the SQL code
set global log_bin_trust_function_creators = 1;
CREATE database hotel_project;
use hotel_project;

create table room_type (
    room_type_id INT AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    num_of_beds INT not NULL,
    price_per_night FLOAT(5,2) NOT NULL,
    PRIMARY KEY (room_type_id)
);
create table employee_type (
    employee_type_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_type_name VARCHAR(50) NOT NULL
);
CREATE table address (
    address_id int AUTO_INCREMENT,
    address VARCHAR(60) NOT NULL,
    city varchar(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    zip_code int NOT NULL,
    PRIMARY KEY (address_id)
);

CREATE table building(
    building_id int AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    capacity int NOT NULL,
    PRIMARY KEY (building_id)
);

 create table customer (
    customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(20),
    address_id INT,
    FOREIGN KEY (address_id)
    REFERENCES address (address_id),
    PRIMARY KEY(customer_id)  
);

create table room_status (
    room_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name varchar(40) NOT NULL
);

create table room  (
    room_number INT AUTO_INCREMENT,
    room_type INT NOT NULL,
    building_id INT,
    floor INT,
    room_status INT,
    FOREIGN KEY (room_status) REFERENCES room_status (room_status_id),
    FOREIGN KEY (room_type) REFERENCES room_type (room_type_id),
    PRIMARY KEY(room_number)

);

create table employee  (
    employee_id INT AUTO_INCREMENT,
    employee_type INT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    address_id INT,
    FOREIGN KEY (address_id)
    REFERENCES address (address_id),
    FOREIGN KEY (employee_type)
    REFERENCES employee_type (employee_type_id),
    PRIMARY KEY(employee_id) 
        
);

create table room_status_log ( 
    room_number INT,
    employee_id INT,
    new_status int NOT NULL,
    time TIMESTAMP DEFAULT (now()), 
    PRIMARY KEY(room_number, employee_id, time),
    FOREIGN KEY (room_number) REFERENCES room(room_number),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (new_status) REFERENCES room_status(room_status_id)
);

create table clean_log ( 
    room_number INT(8),
    employee_id INT(8),
    time TIMESTAMP DEFAULT (now()), 
    PRIMARY KEY(room_number, employee_id, time),
    FOREIGN KEY (room_number) REFERENCES room(room_number),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);
 

create table orders (
    order_number INT AUTO_INCREMENT NOT NULL,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    check_in TIMESTAMP,
    check_out TIMESTAMP,
    order_time TIMESTAMP DEFAULT (now()),
    PRIMARY KEY(order_number),
    FOREIGN KEY (employee_id)
    REFERENCES employee (employee_id),
    FOREIGN KEY (customer_id)
    REFERENCES customer (customer_id)     
 );

create table order_rooms (
    room_number INT NOT NULL,
    order_number INT NOT NULL,
    FOREIGN KEY (room_number)
    REFERENCES room (room_number),
    FOREIGN KEY (order_number)
    REFERENCES orders (order_number),
    PRIMARY KEY (room_number, order_number) 
);

DELIMITER $$

CREATE PROCEDURE addOrder(
    IN orders_to_add int
)
BEGIN
    DECLARE counter INT DEFAULT 1;    
    REPEAT
        insert into orders (check_in, customer_id, employee_id,  check_out)  select  *,floor(rand()*10+1),floor(rand()*10+1), DATE_ADD(check_in,  INTERVAL floor(rand()*10 +1) DAY) check_out from (SELECT FROM_UNIXTIME(RAND() * (UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2020-01-01')) + UNIX_TIMESTAMP('2020-01-01')) check_in) as f;
        SET counter = counter + 1;
    UNTIL counter >= orders_to_add
    END REPEAT;
END$$

DELIMITER ;

-- change room(s) status by order number
DELIMITER $$
CREATE PROCEDURE change_status(
    IN in_order_number int,
    IN in_emp_id INT,
    IN new_status int
)
BEGIN
    -- Check that new_status is valid
    IF new_status NOT IN (SELECT room_status_id from room_status where room_status_id = new_status) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Illegal "New Status"';
    END IF;
    -- Updates the room(s) status
    UPDATE room 
    SET room_status = new_status 
    where room_number in 
    (select room_number from order_rooms where order_number = in_order_number);
    -- Write changes to log
    INSERT INTO room_status_log (room_number, employee_id, new_status) 
    select room_number,in_emp_id, new_status 
    from order_rooms 
    where order_number = in_order_number;
end $$

DELIMITER ;

-- Updates Clean
DELIMITER $$
CREATE PROCEDURE room_cleaned(
    IN in_room_number INT,
    IN in_emp_id INT
)
BEGIN
    -- Check that employee is a housekeeper
    IF in_emp_id NOT IN (SELECT employee_id from employee where employee_type IN (select employee_type_id from employee_type where employee_type_name = "housekeeping")) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee is not a housekeeper';
    END IF;
    -- Updates the room status
    SET @clean_status = 0;
    SELECT room_status_id INTO @clean_status FROM room_status where status_name = "vacant"; 
    UPDATE room 
    SET room_status = @clean_status 
    where room_number = in_room_number;

    -- Write changes to logs
    INSERT INTO clean_log (room_number, employee_id) 
    VALUES (in_room_number,in_emp_id);
    INSERT INTO room_status_log (room_number, employee_id, new_status) 
    VALUES (in_room_number,in_emp_id, @clean_status);

end $$

DELIMITER ;



-- Add random Rooms:
DELIMITER $$
CREATE PROCEDURE add_rooms(
    IN rooms_count int
)
BEGIN
    SET @my_counter = 0;
 WHILE @my_counter < rooms_count DO
    insert into room (room_type, building_id, floor, room_status) values (floor(rand()*4+1), floor(rand()*3+1), floor(rand()*5+1),floor(rand()*3+1));
    SET @my_counter = @my_counter + 1;
END WHILE;
end $$
DELIMITER ;


use hotel_project;

DELIMITER //
CREATE FUNCTION room_status(in_room_number integer) RETURNS VARCHAR(50)
BEGIN
    declare room_status_res VARCHAR(50);
    select status_name INTO room_status_res
    from room 
    INNER join room_status rs 
    ON room_status = rs.room_status_id
    where room_number = in_room_number;
    return room_status_res;
END; //
DELIMITER ;

-- Check that dates of the order are leagle
delimiter $$
create trigger CHK_date before insert on orders
for each row
begin
	IF NEW.check_in >= NEW.check_out
	THEN
	    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Illegal Dates: check in cannot be after check out!';
	END IF;
	end; $$
delimiter ;


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

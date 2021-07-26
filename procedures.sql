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
    -- Write in log the changes
    INSERT INTO room_status_log (room_number, employee_id, new_status) 
    select room_number,in_emp_id, new_status 
    from order_rooms 
    where order_number = in_order_number;
end $$

DELIMITER ;

-- CALL change_status(10,100,1);


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

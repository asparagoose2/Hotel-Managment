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
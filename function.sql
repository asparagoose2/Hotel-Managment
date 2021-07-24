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

SELECT room_status(15);




-- query 3 all orders in  last 2 weeks  

SELECT *
FROM orders
WHERE order_time  BETWEEN GETDATE()-14 AND GETDATE();


-- query 4 cleaned the most rooms

select e.employee_id, e.first_name, e.last_name, count(*) num_of_room
from emplyoee e
inner join clean_log c
on e.employee_id = c.employee_id


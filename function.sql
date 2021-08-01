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

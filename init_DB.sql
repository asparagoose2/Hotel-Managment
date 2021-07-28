
use hotel_project;

-- Add employee type
insert into employee_type (employee_type_name) values ("housekeeping");
insert into employee_type (employee_type_name) values ("receptionist");

-- Add room status
insert into room_status (room_status_id, status_name) values (1,'vacant');
insert into room_status (room_status_id, status_name) values (2,'occupied');
insert into room_status (room_status_id, status_name) values (3,'waiting to be clean');

-- Add building
insert into building  (building_id, name, capacity) values (1, 'A', 360);
insert into building  (building_id, name, capacity) values (2, 'B', 300);
insert into building  (building_id, name, capacity) values (3, 'C', 280);

use sakila;

-- Add customers and their addresses:
insert into hotel_project.address (address_id, address, city, country, zip_code) select address_id, address, city, country, floor(rand()*100000) zip_code from address a inner join city c on a.city_id = c.city_id inner join country cu on c.country_id = cu.country_id where address_id in (select * from (select address_id from customer limit 10) as g) limit 10;
insert into hotel_project.customer (first_name, last_name, phone, address_id) select first_name, last_name, floor(rand()*10000000000) phone , address_id from customer limit 10;

-- Add employees and their addresses:
insert into hotel_project.address (address_id, address, city, country, zip_code) select address_id, address, city, country, floor(rand()*100000) zip_code from address a inner join city c on a.city_id = c.city_id inner join country cu on c.country_id = cu.country_id where address_id in (select * from (select address_id from customer where customer_id > 30 limit 10) as g) limit 10;
insert into hotel_project.employee (first_name, last_name, phone, address_id, employee_type) select first_name, last_name, floor(rand()*10000000000) phone , address_id, floor(rand()*2 + 1) from customer where customer_id > 30 limit 10;
use hotel_project;

-- Add room types:
insert into room_type (type_name, num_of_beds, price_per_night) values ("suit", 1, 700);
insert into room_type (type_name, num_of_beds, price_per_night) values ("standart", 2, 350);
insert into room_type (type_name, num_of_beds, price_per_night) values ("familly", 4, 525);
insert into room_type (type_name, num_of_beds, price_per_night) values ("delux", 3, 430);

-- Add a random room
-- (REPLACED BY PROCEDURE add_rooms()) insert into room (room_type, building_id, floor, room_status) values (floor(rand()*4+1), floor(rand()*3+1), floor(rand()*5+1),floor(rand()*3+1));
CALL add_rooms(30);

-- Get random check in and check out dates:
select *, DATE_ADD(check_in,  INTERVAL floor(rand()*11 +1) DAY) check_out from (SELECT FROM_UNIXTIME(RAND() * (UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2020-01-01')) + UNIX_TIMESTAMP('2020-01-01')) check_in) as f;

-- Insert random order
CALL addOrder(30);
-- Or one by one
insert into orders (check_in, customer_id, employee_id,  check_out)  select  *,floor(rand()*11+1),floor(rand()*10+1), DATE_ADD(check_in,  INTERVAL floor(rand()*10 +1) DAY) check_out from (SELECT FROM_UNIXTIME(RAND() * (UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2020-01-01')) + UNIX_TIMESTAMP('2020-01-01')) check_in) as f;

--Add status log
insert into room_status_log (room_number, employee_id, new_status) values (floor(rand()*28+1),floor(rand()*10+1) , floor(rand()*3+1));
insert into room_status_log  (time, room_number, employee_id, new_status)  select  *,floor(rand()*11+1),floor(rand()*10+1), floor(rand()*3+1)  from (SELECT FROM_UNIXTIME(RAND() * (UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2020-01-01')) + UNIX_TIMESTAMP('2020-01-01')) ) as f;


-- select  *,floor(rand()*11+1),floor(rand()*10+1), floor(rand()*3+1)  from (SELECT FROM_UNIXTIME(RAND() * (UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2020-01-01')) + UNIX_TIMESTAMP('2020-01-01')) ) as f;


-- insert into order_rooms (room_number, order_number) values (floor(rand()*4+1),floor(rand()*20+1));



-- insert into clean_log  (time, room_number, employee_id)  select  *,floor(rand()*10+1),floor(rand()*10+1))  from (SELECT FROM_UNIXTIME(RAND() * (UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2020-01-01')) + UNIX_TIMESTAMP('2020-01-01'))  as f;

-- Add clean log
insert into clean_log (time, room_number, employee_id)  select  *,floor(rand()*10+1),floor(rand()*10+1) from (SELECT FROM_UNIXTIME(RAND() * (UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2020-01-01')) + UNIX_TIMESTAMP('2020-01-01'))) as f;


-- query 1 
SELECT room_number, status_name
FROM room
inner join  room_status rs
ON room_status = rs.room_status_id;

-- query 2


-- query 3 all orders in  last 2 weeks  

SELECT *
FROM orders
WHERE order_time  BETWEEN DATE_SUB(now(), INTERVAL 14 DAY) AND (NOW());


-- query 4 cleaned the most rooms

select e.employee_id, e.first_name, e.last_name, count(*) num_of_room
from employee e
inner join clean_log c
on e.employee_id = c.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY num_of_room desc limit 1;


-- query 5



-- query 6
select c.customer_id, c.first_name, c.last_name, count(*) num_of_orders
from customer c
inner join orders o
on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING num_of_orders > 1;


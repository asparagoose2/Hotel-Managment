
-- query 1 
SELECT room_number, status_name
FROM room
inner join  room_status rs
ON room_status = rs.room_status_id;

-- query 2
SELECT room_number, COUNT(*) 
FROM order_rooms
GROUP BY room_number
ORDER BY COUNT(*) DESC limit 10;


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

-- query 7: display incomes by month

select DATE_FORMAT(check_in, "%b %y") date, SUM(datediff(check_out ,check_in)*price_per_night) total from order_rooms  ro
inner join room r
on r.room_number = ro.room_number
inner join room_type rt
on rt.room_type_id = r.room_type
inner join orders o
on ro.order_number = o.order_number
group by month(check_in), year(check_in)
order by  year(check_in), month(check_in)
use sakila;
insert into hotel_project.address (address_id, address, city, country, zip_code) select address_id, address, city, country, floor(rand()*100000) zip_code from address a inner join city c on a.city_id = c.city_id inner join country cu on c.country_id = cu.country_id where address_id in (select * from (select address_id from customer limit 10) as g) limit 10;

insert into hotel_project.customer (first_name, last_name, phone, address_id) select first_name, last_name, floor(rand()*10000000000) phone , address_id from customer limit 10;

use hotel_project;
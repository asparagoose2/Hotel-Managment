CREATE database hotel_project;

create table room_type (
    room_type_id int AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    num_of_beds INT not NULL,
    price_per_night FLOAT(5,2) NOT NULL,
    PRIMARY KEY (room_type_id)
);

CREATE table address (
    address_id int AUTO_INCREMENT,
    address VARCHAR(60) NOT NULL,
    city varchar(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    zip_code int NOT NULL,
    PRIMARY KEY (address_id)
);

 create table customer (
     customer_id INT(8) AUTO_INCREMENT,
     first_name VARCHAR(20) NO NULL,
     last_name VARCHAR(20) NO NULL,
     phone VARCHAR(10) NO NULL,
     adderss_id INT(8),
     FOREIGN KEY (adderss_id)
     REFERENCES address (address_id)
     PRIMARY KEY(customer_id)  
     
 )

  create table room  (
     room_number INT(8) AUTO_INCREMENT,
     room_type VARCHAR(20) NO NULL,
     building_id INT(8),
     floor INT(8),
     status VARCHAR(20),
     PRIMARY KEY(room_number)     
 );

   create table employee  (
     employee_id INT(8) AUTO_INCREMENT,
     employee_type VARCHAR(20) NO NULL,
     phone VARCHAR(11),
     first_name VARCHAR(20),
     last_name VARCHAR(20),
     address_id VARCHAR(20),
     FOREIGN KEY (employee_type)
     REFERENCES address (address_id)
     PRIMARY KEY(employee_ID)     
 );
 
    create table status_log (
     room_number INT(8) AUTO_INCREMENT,
     employee_id INT(8) AUTO_INCREMENT,
     time TIMESTAMP DEFAULT (now()), 
     PRIMARY KEY(room_number)     
 );
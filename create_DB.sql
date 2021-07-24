CREATE database hotel_project;
use hotel_project;

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

CREATE table building(
    building_id int AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    capacity int NOT NULL,
    PRIMARY KEY (building_id)
);

 create table customer (
    customer_id INT(8) AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(10) NOT NULL,
    adderss_id INT(8),
    FOREIGN KEY (adderss_id)
    REFERENCES address (address_id),
    PRIMARY KEY(customer_id)  
     
);

create table room  (
    room_number INT(8) AUTO_INCREMENT,
    room_type VARCHAR(20) NOT NULL,
    building_id INT(8),
    floor INT(8),
    status VARCHAR(20),
    PRIMARY KEY(room_number)   
);

create table employee  (
    employee_id INT(8),
    employee_type VARCHAR(20) NOT NULL,
    phone VARCHAR(11),
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    address_id INT,
    FOREIGN KEY (address_id)
    REFERENCES address (address_id),
    PRIMARY KEY(employee_id)     
);

create table room_log ( 
    room_number INT(8),
    employee_id INT(8),
    action VARCHAR(30) NOT NULL,
    time TIMESTAMP DEFAULT (now()), 
    PRIMARY KEY(room_number, employee_id),
    FOREIGN KEY (room_number) REFERENCES room(room_number),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    CONSTRAINT CHK_Action CHECK (action IN ("clean", "status change"))
);
 

create table orders (
    order_number INT AUTO_INCREMENT NOT NULL,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    check_in TIMESTAMP,
    check_out TIMESTAMP,
    order_time TIMESTAMP DEFAULT (now()),
    PRIMARY KEY(order_number),
    FOREIGN KEY (employee_id)
    REFERENCES employee (employee_id),
    FOREIGN KEY (customer_id)
    REFERENCES customer (customer_id)     
 );

create table order_rooms (
    employee_id INT NOT NULL,
    order_number INT NOT NULL,
    FOREIGN KEY (employee_id)
    REFERENCES employee (employee_id),
    FOREIGN KEY (order_number)
    REFERENCES orders (order_number),
    PRIMARY KEY(employee_id, order_number) 
);



 
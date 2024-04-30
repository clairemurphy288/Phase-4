-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST

-- Team 82
-- Pragna Veeravelli (pveeravelli6)
-- Claire Murphy (cmurphy88)
-- Preity Chavan (pchavan6)
-- Kirti Bharadwaj (kbharadwaj9)
-- Avalyn Mullikin (amullikin6)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
drop procedure if exists add_customer;
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	declare counter INTEGER;
    declare employee INTEGER;
    declare customer INTEGER;
    declare fname varchar(100);
    declare lname varchar(100);
 	if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null or ip_birthdate is null or ip_rating is null or ip_credit is null
		then leave sp_main;
	end if;  
    select count(*) into counter from users where uname = ip_uname;
    select count(*) into employee from employees where uname = ip_uname;
    select count(*) into customer from customers where uname = ip_uname;
    
    IF counter = 0 then 
    insert into users (uname, first_name, last_name, address, birthdate)
    values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    
    insert into customers (uname, rating, credit) values (ip_uname, ip_rating, ip_credit);
	end if;
    
    IF counter = 1 then
		select first_name into fname from users where uname = ip_uname; 
        select last_name into lname from users where uname = ip_uname; 
        
		IF employee = 1 and customer = 0 and fname = ip_first_name and lname = ip_last_name  then
		
			insert into customers (uname, rating, credit) values (ip_uname, ip_rating, ip_credit);
			end if;
    
		IF employee = 0 and customer = 0 and fname = ip_first_name and lname = ip_last_name then
			insert into customers (uname, rating, credit) values (ip_uname, ip_rating, ip_credit);
			end if;
     end if;       
            
end //
delimiter ;




-- add drone pilot
drop procedure if exists add_drone_pilot;
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
    DECLARE username_exists INT;
    DECLARE taxID_exists INT;
    DECLARE licenseID_exists INT;
  	if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null or ip_birthdate is null or ip_taxID is null or ip_service 
    is null or ip_salary is null or ip_licenseID is null or ip_experience is null
		then leave sp_main;
	end if;     
    SELECT COUNT(*) INTO username_exists
    FROM users
    WHERE uname = ip_uname;

    SELECT COUNT(*) INTO taxID_exists
    FROM employees
    WHERE taxID = ip_taxID;

    SELECT COUNT(*) INTO licenseID_exists
    FROM drone_pilots
    WHERE licenseID = ip_licenseID;
    
    IF username_exists = 0 AND taxID_exists = 0 AND licenseID_exists = 0 THEN
	INSERT INTO users (uname, first_name, last_name, address, birthdate)
	VALUES (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    
	INSERT INTO employees (uname, taxID, service, salary)
	VALUES (ip_uname, ip_taxID, ip_service, ip_salary); 
    
	INSERT INTO drone_pilots (uname, licenseID, experience)
	VALUES (ip_uname, ip_licenseID, ip_experience);   
    
    end if;
end //
delimiter ;

-- add product
drop procedure if exists add_product;
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
    DECLARE counter INTEGER;
 	if ip_barcode is null or ip_pname is null or ip_weight is null
		then leave sp_main;
	end if;
    SELECT COUNT(*) INTO counter FROM products WHERE barcode = ip_barcode;
    
    IF counter = 0 THEN
        INSERT INTO products (barcode, pname, weight)
        VALUES (ip_barcode, ip_pname, ip_weight);
    END IF;
end //
delimiter ;

-- add drone
drop procedure if exists add_drone;
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
	DECLARE valid_store INT;
    DECLARE counter INT;
    DECLARE pilot_controlled INT;
    DECLARE pilot_exists INT;
 	if ip_storeID is null or ip_droneTag is null or ip_capacity is null or ip_remaining_trips is null or ip_pilot is null
		then leave sp_main;
	end if;      
    SELECT COUNT(*) INTO valid_store
    FROM stores
    WHERE storeID = ip_storeID;

    SELECT COUNT(*) INTO counter
    FROM drones
    WHERE storeID = ip_storeID AND droneTag = ip_droneTag;

    SELECT COUNT(*) INTO pilot_controlled
    FROM drones
    WHERE pilot = ip_pilot;
    
    SELECT count(*) into pilot_exists from drone_pilots
    where uname = ip_pilot;
    
    if valid_store = 1 and counter = 0 and pilot_controlled = 0 and pilot_exists = 1 then
    insert into drones (storeID, droneTag, capacity, remaining_trips, pilot)
    values (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
    end if;
    
end //
delimiter ;

-- increase customer credits
drop procedure if exists increase_customer_credits;
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	DECLARE cur_credit INT;
 	if ip_uname is null or ip_money is null
		then leave sp_main;
	end if;
    IF ip_money >= 0 THEN
        UPDATE customers
        SET credit = credit + ip_money
        WHERE uname = ip_uname;
    END IF;
end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin

	DECLARE i_pilot INT;
    DECLARE o_pilot INT;
    DECLARE i_pilot_drone INT;
    DECLARE out_pilot_drone INT;
 	if ip_incoming_pilot is null or ip_outgoing_pilot is null
		then leave sp_main;
	end if;
    
    -- checking if incoming pilot exists
    SELECT COUNT(*) INTO i_pilot
    FROM drone_pilots
    WHERE uname = ip_incoming_pilot;

    SELECT COUNT(*) INTO i_pilot_drone
    FROM drones
    WHERE pilot = ip_incoming_pilot;

    SELECT COUNT(*) INTO out_pilot_drone
    FROM drones
    WHERE pilot = ip_outgoing_pilot;
    
    -- checking if outgoing pilot exists
    select count(*) INTO o_pilot
    FROM drone_pilots
    WHERE uname = ip_outgoing_pilot;
    

    
    IF i_pilot = 1 AND o_pilot = 1 AND i_pilot_drone = 0 AND out_pilot_drone = 1 THEN
        -- Update the drone's pilot from outgoing to incoming pilot
        UPDATE drones
        SET pilot = ip_incoming_pilot
        WHERE pilot = ip_outgoing_pilot;
    END IF;  
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
	-- place your solution here
    DECLARE current_trips INT;
 	if ip_drone_store is null or ip_drone_tag is null or ip_refueled_trips is null
		then leave sp_main;
	end if;    
    ##add the amount of remaining trips into current_trips variable
    SELECT remaining_trips INTO current_trips
    FROM drones
    WHERE storeID = ip_drone_store AND droneTag = ip_drone_tag;
    
    ##Check if the proposed change in the number of trips is non-negative
    IF ip_refueled_trips >= 0 THEN
		##update drone
        UPDATE drones
        SET remaining_trips = remaining_trips + ip_refueled_trips
        WHERE storeID = ip_drone_store AND droneTag = ip_drone_tag;
    END IF;
end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	DECLARE customer_credit INT;
    DECLARE drone_capacity INT;
    DECLARE drone_exists INT;
	DECLARE product_weight INT;
	DECLARE total_weight INT;
	DECLARE remaining_trips INT;
    
    -- verifying remaining trips is not zero
	select remaining_trips into remaining_trips from drones WHERE
	storeID = ip_carrier_store AND droneTag = ip_carrier_tag;
    
    IF remaining_trips = 0 then 
    leave sp_main; end if;
    
    -- making sure orderID is not in use
    IF EXISTS (SELECT 1 FROM orders WHERE orderID = ip_orderID) THEN
		leave sp_main; end if;
    --  verifying product exists   
    IF NOT EXISTS (SELECT 1 FROM products WHERE barcode = ip_barcode) THEN 
		leave sp_main; end if; 
        
    IF NOT EXISTS (SELECT 1 FROM customers WHERE uname = ip_purchased_by) THEN 
		leave sp_main; end if;     

    -- Check if the customer exists and retrieve their credit
    SELECT current_credit INTO customer_credit 
    FROM customer_credit_check
    WHERE customer_name = ip_purchased_by;
    
    
    
    -- Check if the order ID, drone, and product barcode are all valid
    IF ip_orderID IS NULL OR ip_sold_on IS NULL OR ip_purchased_by IS NULL OR ip_carrier_store IS NULL OR ip_carrier_tag IS NULL OR
       ip_barcode IS NULL THEN
        LEAVE sp_main;
    END IF;
	-- subtract credit already allocated
    set customer_credit = customer_credit - (select credit_already_allocated from customer_credit_check WHERE customer_name = ip_purchased_by);

    -- Check if the drone exists
    SELECT COUNT(*) INTO drone_exists 
    FROM drones 
    WHERE storeID = ip_carrier_store AND droneTag = ip_carrier_tag;
    
    
    IF drone_exists = 0 THEN
        LEAVE sp_main;
    END IF;

    -- Check if the price is non-negative and the quantity is positive
    IF ip_price < 0 OR ip_quantity <= 0 THEN
        LEAVE sp_main;
    END IF;

    -- Check if the customer has enough credits to purchase the initial products being ordered
    IF customer_credit < ip_price * ip_quantity THEN
        LEAVE sp_main;
    END IF;

    -- Check if the drone has enough lifting capacity to carry the initial products
    -- SELECT capacity INTO drone_capacity 
--     FROM drones 
--     WHERE storeID = ip_carrier_store AND droneTag = ip_carrier_tag;
    
    select total_weight_allowed - current_weight into drone_capacity from drone_traffic_control 
	where drone_serves_store = ip_carrier_store AND drone_tag = ip_carrier_tag;

    -- Retrieve the weight of the product

    SELECT weight INTO product_weight 
    FROM products 
    WHERE barcode = ip_barcode;
    
    SET total_weight = product_weight * ip_quantity;
    

    IF drone_capacity < total_weight THEN
        LEAVE sp_main;
    END IF;

    -- Proceed with the order
    INSERT INTO orders (orderID, sold_on, purchased_by, carrier_store, carrier_tag)
    VALUES (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);

    -- Insert the order line into the order_lines table
    INSERT INTO order_lines (orderID, barcode, price, quantity)
    VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);
END //
delimiter ;


    





-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	-- place your solution here
    DECLARE customer_credit INT;
    DECLARE drone_capacity INT;
    DECLARE existing_quantity INT;
 	if ip_orderID is null or ip_barcode is null or ip_price is null or ip_quantity is null
		then leave sp_main;
	end if;    
    ##Check if the customer has enough credit
    SELECT current_credit - credit_already_allocated INTO customer_credit
    FROM customer_credit_check
    WHERE customer_name = (
        SELECT purchased_by
        FROM orders
        WHERE orderID = ip_orderID
    );
    

    
    ##Check if the product being added is not already part of the order
    SELECT quantity INTO existing_quantity
    FROM order_lines
    WHERE orderID = ip_orderID AND barcode = ip_barcode;
    
    ##Check if the drone has enough capacity
    SELECT capacity INTO drone_capacity
    FROM drones
    WHERE storeID = (
        SELECT carrier_store
        FROM orders
        WHERE orderID = ip_orderID
    ) AND droneTag = (
        SELECT carrier_tag
        FROM orders
        WHERE orderID = ip_orderID
    );
    
	#select quantity * weight from order_lines natural join products where orderID = ip_orderID;
    ##condition checks
    IF customer_credit >= ip_price * ip_quantity AND existing_quantity IS NULL AND 
    drone_capacity >= (select payload from orders_in_progress where orderID = ip_orderID) + ip_quantity * (select weight from products where barcode = ip_barcode)
    AND ip_price >= 0 AND ip_quantity > 0 THEN
        ##Add the order line
        INSERT INTO order_lines (orderID, barcode, price, quantity)
        VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);
    END IF;
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
    declare order_cost int;
    declare order_rating int;
    declare is_high_cost_order boolean;
    declare remaining_trips int;
 	if ip_orderID is null
		then leave sp_main;
	end if;    
    ##Check if the order ID is valid and retrieve the remaining trips of the drone
    select d.remaining_trips into remaining_trips
    from orders o
    inner join drones d on o.carrier_store = d.storeID and o.carrier_tag = d.droneTag
    where o.orderID = ip_orderID;
    
    ## Conditional logic to check if the order ID is valid and the drone has enough trips
    if remaining_trips is not null and remaining_trips > 0 then
    
        ##Calculate the cost of the order
        select sum(ol.price * ol.quantity) into order_cost
        from order_lines ol
        where ol.orderID = ip_orderID;
        
        ##Check if the order is more than $25 and insert it into boolean variable
        set is_high_cost_order = (order_cost > 25);
        
        ##Decrease customer's credit by the cost of the order
        update customers c
        inner join orders o on c.uname = o.purchased_by
        set c.credit = c.credit - order_cost
        where o.orderID = ip_orderID;
        
        ##Increase store's revenue by the cost of the order
        update stores s
        inner join orders o on s.storeID = o.carrier_store
        set s.revenue = s.revenue + order_cost
        where o.orderID = ip_orderID;
        
        ##Reduce the drone's number of remaining trips by one
        update drones d
        inner join orders o on d.storeID = o.carrier_store and d.droneTag = o.carrier_tag
        set d.remaining_trips = d.remaining_trips - 1
        where o.orderID = ip_orderID;
        
        ##Increase the pilot's experience level by one
        update drone_pilots dp
        inner join drones d on dp.uname = d.pilot
        inner join orders o on d.storeID = o.carrier_store and d.droneTag = o.carrier_tag
        set dp.experience = dp.experience + 1
        where o.orderID = ip_orderID;
        
        ##Increase customer's rating by one if the order is more than $25
        if is_high_cost_order then
            update customers c
            inner join orders o on c.uname = o.purchased_by
            set c.rating = c.rating + 1
            where o.orderID = ip_orderID and c.rating < 5;
        end if;
        
        ##Remove all records of the order
        delete from orders where orderID = ip_orderID;
        delete from order_lines where orderID = ip_orderID;
        
    end if;
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
 	if ip_orderID is null
		then leave sp_main;
	end if;    
    ##Check if the order ID is valid
    IF EXISTS (SELECT 1 FROM orders WHERE orderID = ip_orderID) THEN
        ##Decrease customer's rating by one if permitted
        UPDATE customers
        SET rating = GREATEST(1, rating - 1) ##makes sure rating doesn't go below one
        WHERE uname = (SELECT purchased_by FROM orders WHERE orderID = ip_orderID);
        
        ##Remove all records of the order
        DELETE FROM order_lines WHERE orderID = ip_orderID;
        DELETE FROM orders WHERE orderID = ip_orderID;
        
    END IF;
end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution (category, total) as
SELECT 'users' AS category, COUNT(*) AS total FROM users
UNION
SELECT 'customers' AS category, COUNT(*) AS total FROM customers
UNION
SELECT 'employees' AS category, COUNT(*) AS total FROM employees
UNION
SELECT 'customer_employer_overlap' AS category, COUNT(*) AS total FROM customers WHERE uname IN (SELECT uname FROM employees)
UNION
SELECT 'drone_pilots' AS category, COUNT(*) AS total FROM drone_pilots
UNION
SELECT 'store_workers' AS category, COUNT(*) AS total FROM store_workers
UNION
SELECT 'other_employee_roles' AS category, 
  (SELECT COUNT(*) FROM employees) - 
  (SELECT COUNT(*) FROM drone_pilots) - 
  (SELECT COUNT(*) FROM store_workers) AS total;
SELECT * FROM role_distribution;


-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
SELECT 
  c.uname AS customer_name,
  c.rating,
  c.credit AS current_credit,
  COALESCE(
    (
      SELECT SUM(ol.price * ol.quantity) 
      FROM orders o 
      LEFT JOIN order_lines ol ON o.orderID = ol.orderID 
      WHERE o.purchased_by = c.uname 
    ),
    0
  ) AS credit_already_allocated
FROM customers c;
SELECT * FROM customer_credit_check;


-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
select 
    d.storeid as drone_serves_store,
    d.dronetag as drone_tag,
    d.pilot,
    d.capacity as total_weight_allowed,
    coalesce(
        (
            select sum(p.weight * ol.quantity)
            from orders o
            join order_lines ol on o.orderid = ol.orderid
            join products p on ol.barcode = p.barcode
            where o.carrier_store = d.storeid 
            and o.carrier_tag = d.dronetag
            -- include additional conditions for 'in progress' orders, e.g., o.status = 'in_progress'
        ), 
        0
    ) as current_weight,
    d.remaining_trips as deliveries_allowed,
    (
        select count(*)
        from orders o
        where o.carrier_store = d.storeid 
        and o.carrier_tag = d.dronetag
        -- include additional conditions for 'in progress' orders
    ) as deliveries_in_progress
from drones d
group by d.storeid, d.dronetag, d.pilot, d.capacity, d.remaining_trips;
SELECT * FROM drone_traffic_control;

-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
select p.barcode, p.pname as product_name, p.weight, min(ol.price) as lowest_price, max(ol.price) as highest_price, ifnull(min(ol.quantity), 0) as lowest_quantity, ifnull(max(ol.quantity), 0) as highest_quantity, ifnull(sum(ol.quantity), 0) as total_quantity
from products p
left join order_lines ol on p.barcode = ol.barcode
group by p.barcode, p.pname, p.weight;
select * from most_popular_products;

-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
select 
  dp.uname as pilot,
  dp.licenseID,
  d.storeID as drone_serves_store,
  d.droneTag,
  dp.experience as successful_deliveries,
  coalesce((
    select count(*)
    from orders o
    where o.carrier_store = d.storeID and o.carrier_tag = d.droneTag
  ), 0) as pending_deliveries
from drone_pilots dp
left join drones d on dp.uname = d.pilot;

select * from drone_pilot_roster;

-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
select 
    s.storeID as store_id,
    s.sname,
    s.manager,
    s.revenue,
    coalesce(sum(ol.price * ol.quantity), 0) as incoming_revenue,
    count(distinct o.orderID) as incoming_orders
from stores s
left join orders o on s.storeID = o.carrier_store and o.sold_on > current_date
left join order_lines ol on o.orderID = ol.orderID
group by s.storeID;
select * from store_sales_overview;

-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
SELECT 
    o.orderID,
    SUM(ol.price * ol.quantity) AS cost,
    COUNT(ol.barcode) AS num_products,
    SUM(p.weight * ol.quantity) AS payload,
    GROUP_CONCAT(p.pname ORDER BY p.pname ASC SEPARATOR ', ') AS contents
FROM orders o
JOIN order_lines ol ON o.orderID = ol.orderID
JOIN products p ON ol.barcode = p.barcode
GROUP BY o.orderID;
SELECT * FROM orders_in_progress;

-- remove customer
drop procedure if exists remove_customer;
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
	DECLARE pending_orders INT;
    DECLARE employee INT;
 	if ip_uname is null
		then leave sp_main;
	end if;    
    SELECT COUNT(*) INTO pending_orders
    FROM orders 
    WHERE purchased_by = ip_uname;
    
    SELECT COUNT(*) INTO employee 
    FROM employees 
    WHERE uname = ip_uname;
    
    -- If the customer does not have pending orders and is not an employee, remove them
    IF pending_orders = 0 AND employee = 0 THEN
        DELETE FROM customers WHERE uname = ip_uname;
        DELETE FROM users WHERE uname = ip_uname;
        
	
	END IF;    
	IF pending_orders = 0 AND employee = 1 THEN
		DELETE FROM customers WHERE uname = ip_uname;

    END IF ;
end //
delimiter ;

-- remove drone pilot
drop procedure if exists remove_drone_pilot;
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	-- place your solution here
    DECLARE pilot_controlled INT;
	DECLARE is_customer INT;
 	if ip_uname is null
		then leave sp_main;
	end if;    
    SELECT COUNT(*) INTO pilot_controlled
    FROM drones
    WHERE pilot = ip_uname;
    

    select count(*) into is_customer 
    from customers where uname = ip_uname;

    IF pilot_controlled = 0 and is_customer = 0 THEN
        DELETE FROM drone_pilots
        WHERE uname = ip_uname;
		
        UPDATE drones
        SET pilot = NULL
        WHERE pilot = ip_uname;
        
        DELETE FROM employees
        WHERE uname = ip_uname;
        DELETE FROM users
        WHERE uname = ip_uname;
    END IF;
    
    IF pilot_controlled = 0 and is_customer = 1 then 
		DELETE FROM drone_pilots
        WHERE uname = ip_uname;
		
        UPDATE drones
        SET pilot = NULL
        WHERE pilot = ip_uname;
        
        DELETE FROM employees
        WHERE uname = ip_uname;
    
	END IF;	
end //
delimiter ;

-- remove product
drop procedure if exists remove_product;
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	DECLARE counter INT;
 	if ip_barcode is null
		then leave sp_main;
	end if;
    SELECT COUNT(*)
    INTO counter
    FROM order_lines
    WHERE barcode = ip_barcode;

    IF counter = 0 THEN
        DELETE FROM products WHERE barcode = ip_barcode;
    END IF;
end //
delimiter ;

-- remove drone
drop procedure if exists remove_drone;
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	-- place your solution here
    DECLARE counter INT;
 	if ip_storeID is null or ip_droneTag is null
		then leave sp_main;
	end if;    
    select COUNT(*) into counter from orders where carrier_store = ip_storeID and carrier_tag = ip_droneTag;
    
    if counter = 0 then
    delete from drones where storeID = ip_storeID and droneTag = ip_droneTag;
    
    end if;
end //
delimiter ;

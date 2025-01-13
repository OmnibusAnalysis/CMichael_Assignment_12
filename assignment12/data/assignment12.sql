create database `pizza_place`;

create table `customers` (
	`customer_id` int not null,
	`customer_name` varchar (45),
    `phone_number` varchar (9),
    primary key (customer_id)
);

create table `orders` (
	`order_id` int not null,
    `order_date` DATETIME,
    primary key (order_id)
);

create table `pizzas` (
	`pizza_id` int not null,
    `pizza_name` varchar (45),
    `price` decimal (10, 2),
	primary key (pizza_id)
);

create table `pizza_orders` (
	`order_id` int not null,
    `pizza_id` int not null,
    `quantity` int not null,
    foreign key (order_id) references `orders` (order_id),
    foreign key (pizza_id) references `pizzas` (pizza_id)
);

insert into pizza_place.customers (customer_id, `customer_name`, `phone_number`)
values (1, 'Trevor Page', '226-555-4982');

insert into pizza_place.customers (customer_id, `customer_name`, `phone_number`)
values (2, 'John Doe', 555-555-9498);

insert into `orders` (order_id, order_date)
values (1, '2023-09-10 09:47:00');

insert into `orders` (order_id, order_date)
values (2, '2023-09-10 13:20:00');

insert into `orders` (order_id, order_date)
values (3, '2023-09-10 09:47:00');

insert into `orders` (order_id, order_date)
values (4, '2023-10-10 10:37:00');

insert into `pizzas` (pizza_id, pizza_name, price)
values (1, 'Pepperoni & Cheese', 7.99);

insert into `pizzas` (pizza_id, pizza_name, price)
values (2, 'Vegetarian', 9.99);

insert into `pizzas` (pizza_id, pizza_name, price)
values (3, 'Meat Lovers', 14.99);

insert into `pizzas` (pizza_id, pizza_name, price)
values (4, 'Hawaiian', 12.99);

insert into `pizza_orders` (order_id, pizza_id, quantity)
values (1, 1, 1);

insert into `pizza_orders` (order_id, pizza_id, quantity)
values (1, 2, 1);

insert into `pizza_orders` (order_id, pizza_id, quantity)
values (2, 2, 1);

insert into `pizza_orders` (order_id, pizza_id, quantity)
values (2, 3, 2);

insert into `pizza_orders` (order_id, pizza_id, quantity)
values (3, 3, 1);

insert into `pizza_orders` (order_id, pizza_id, quantity)
values (3, 4, 1);

insert into `pizza_orders` (order_id, pizza_id, quantity)
values (4, 2, 3);

insert into `pizza_orders` (order_id, pizza_id, quantity)
values (4, 4, 1);

-- Add customer_id column to orders table
ALTER TABLE `orders`
    ADD COLUMN `customer_id` INT,
    ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Update existing orders with customer_id
UPDATE `orders` SET `customer_id` = 1 WHERE `order_id` IN (1, 2);
UPDATE `orders` SET `customer_id` = 2 WHERE `order_id` IN (3, 4);


-- Q4 how much did each customer spend
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(p.price * po.quantity), 0) AS total_spent
FROM
    customers c
        LEFT JOIN orders o ON c.customer_id = o.customer_id
        LEFT JOIN pizza_orders po ON o.order_id = po.order_id
        LEFT JOIN pizzas p ON po.pizza_id = p.pizza_id
GROUP BY
    c.customer_id, c.customer_name
ORDER BY
    total_spent DESC;

-- Query to show how much money each customer spent on each date
SELECT
    c.customer_id,
    c.customer_name,
    DATE(o.order_date) AS order_date,
    COALESCE(SUM(p.price * po.quantity), 0) AS total_spent
FROM
    customers c
        LEFT JOIN orders o ON c.customer_id = o.customer_id
        LEFT JOIN pizza_orders po ON o.order_id = po.order_id
        LEFT JOIN pizzas p ON po.pizza_id = p.pizza_id
GROUP BY
    c.customer_id, c.customer_name, DATE(o.order_date)
ORDER BY
    c.customer_id, order_date, total_spent DESC;

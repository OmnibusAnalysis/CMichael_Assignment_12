create database `pizza_place`;

create table `customers` (
	`customer_id` int not null,
	`first_name` varchar (45),
    `contact` varchar (9),
    primary key `customer_id` (customer_id)
);

create table `orders` (
	`order_id` int not null,
    `order_date` DATETIME,
    primary key `order_id` (order_id)
);

create table `customer_order` (
	`customer_id` int not null,
    `order_id` int not null,
	foreign key (customer_id) references `customers` (customer_id),
    foreign key (order_id) references `orders` (order_id)
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

alter table `customers`
drop column `contact`;

alter table `customers`
add `last_name` varchar (45);

alter table `customers`
add `contact` varchar (9);

alter table `customers`
drop column `contact`;

alter table `customers`
add `contact` varchar (12);

alter table `orders`
drop column `order_date`;

alter table `orders`
add `order_date` datetime;

insert into pizza_place.customers (customer_id, first_name, last_name, contact)
values (1, 'Trevor', 'Page', '226-555-4982');

insert into pizza_place.customers (customer_id, first_name, last_name, contact)
values (2, 'John', 'Doe', '555-555-9498');

insert into `orders` (order_id, order_date)
values (1, '2023-09-10 09:47:00');

insert into `orders` (order_id, order_date)
values (2, '2023-09-10 13:20:00');

insert into `orders` (order_id, order_date)
values (3, '09-10-23 09:47:00');

insert into `orders` (order_id, order_date)
values (4, '10-10-23 10:37:00');

insert into `pizzas` (pizza_id, pizza_name, price)
values (1, 'Pepperoni & Cheese', 7.99);

insert into `pizzas` (pizza_id, pizza_name, price)
values (2, 'Vegetarian', 9.99);

insert into `pizzas` (pizza_id, pizza_name, price)
values (3, 'Meat Lovers', 14.99);

insert into `pizzas` (pizza_id, pizza_name, price)
values (4, 'Hawaiian', 12.99);

insert into `customer_order` (customer_id, order_id)
values (1, 1);

insert into `customer_order` (customer_id, order_id)
values (2, 2);

insert into `customer_order` (customer_id, order_id)
values (1, 3);

insert into `customer_order` (customer_id, order_id)
values (2, 4);

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

-- Q4
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.price * po.quantity) AS total_spent
FROM
    customers c
        JOIN
    customer_order co ON c.customer_id = co.customer_id
        JOIN
    orders o ON co.order_id = o.order_id
        JOIN
    pizza_orders po ON o.order_id = po.order_id
        JOIN
    pizzas p ON po.pizza_id = p.pizza_id
GROUP BY
    c.customer_id, c.first_name, c.last_name
ORDER BY
    total_spent DESC;

-- Query to show how much money each customer spent on each date
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    DATE(o.order_date) AS order_date,
    SUM(p.price * po.quantity) AS total_spent
FROM
    customers c
        JOIN customer_order co ON c.customer_id = co.customer_id
        JOIN orders o ON co.order_id = o.order_id
        JOIN pizza_orders po ON o.order_id = po.order_id
        JOIN pizzas p ON po.pizza_id = p.pizza_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, DATE(o.order_date)
ORDER BY
    c.customer_id, order_date;


-- CREATE THE DATABASE
CREATE DATABASE food_waste_management;

USE food_waste_management;

-- IF NEED TO DELETE DATABASE AND RE-RUN UNCOMMENT BELOW AND RUN
-- DROP DATABASE food_waste_management; 

CREATE TABLE food_doners (
	doner_id INT NOT NULL,
    name VARCHAR(50),
    phone_no VARCHAR(50),
    email VARCHAR(100)
    );    

ALTER TABLE food_doners 
	ADD CONSTRAINT pk_doner_id PRIMARY KEY (doner_id);


CREATE TABLE food (
	food_id INT NOT NULL,
    doner_id INT NOT NULL,
    box_id INT NOT NULL,
    food_type VARCHAR(50) NOT NULL,
    expiry_date DATE, 
    quantity INT,
    weight DECIMAL,
    temp_controlled VARCHAR(3) NOT NULL,
    PRIMARY KEY (food_id),
	FOREIGN KEY (doner_id) REFERENCES food_doners(doner_id)
    );
    
    
 CREATE TABLE customers (
	customer_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    account_type VARCHAR(50),
    PRIMARY KEY (customer_id)
    );
 
 
CREATE TABLE addresses (
	location_id INT NOT NULL,
    doner_id INT NOT NULL,
    customer_id INT NOT NULL,
    street_building VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    PRIMARY KEY (location_id),
    FOREIGN KEY (doner_id) REFERENCES food_doners(doner_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    );
  
CREATE TABLE boxes (
	box_id INT NOT NULL PRIMARY KEY,
    box_type VARCHAR(50)
	);
    
    
CREATE TABLE orders (
	order_no INT NOT NULL AUTO_INCREMENT,
    customer_id INT NOT NULL,
    box_id INT,
    PRIMARY KEY (order_no),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (box_id) REFERENCES boxes(box_id)
    );
 
 
CREATE TABLE subscriptions (
	subscription_id INT NOT NULL,
    box_id INT,
    frequency VARCHAR(50) NOT NULL, 
    customer_id INT NOT NULL,
    PRIMARY KEY (subscription_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (box_id) REFERENCES boxes(box_id)
    );


 CREATE TABLE feedback (
	feedback_id INT NOT NULL,
    customer_id INT NOT NULL,
    box_id INT NOT NULL,
    order_no INT,
    subscription_id INT,
    feedback_message VARCHAR(250),
    rating INT NOT NULL,
    PRIMARY KEY (feedback_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (box_id) REFERENCES boxes(box_id),
    FOREIGN KEY (order_no) REFERENCES orders(order_no),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
    );
    
    
CREATE TABLE delivery (
	courier_id INT NOT NULL,
    food_id INT NOT NULL,
    order_no INT NOT NULL,
    collection_date TIMESTAMP,
    delivery_date TIMESTAMP,
    temp_controlled VARCHAR(50) NOT NULL,
    PRIMARY KEY (courier_id)
    );

-- EDITS MADE TO MODIFY TABLES AFTER THEY WERE CREATED IN ORDER FOR 
-- MY DATABASE TO WORK BETTER WITH MY SCENARIO 
ALTER TABLE orders AUTO_INCREMENT=501;
ALTER TABLE orders ADD order_date DATE NOT NULL;
ALTER TABLE orders CHANGE order_date delivery_date DATE NOT NULL;

-- ALTER TABLE boxes
-- 	ADD CONSTRAINT fk_order_no FOREIGN KEY (order_no) REFERENCES orders(order_no),
--     ADD CONSTRAINT fk_subscription_id FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id);

ALTER TABLE subscriptions ADD order_date DATE NOT NULL;
ALTER TABLE subscriptions CHANGE order_date delivery_date DATE NOT NULL;
ALTER TABLE subscriptions MODIFY COLUMN delivery_date DATE;
ALTER TABLE subscriptions ADD skip_applied VARCHAR(3);

ALTER TABLE food RENAME COLUMN weight TO weight_kg;
ALTER TABLE food MODIFY COLUMN weight_kg DECIMAL(4,2); 
ALTER TABLE food 
	ADD CONSTRAINT fk_box_id FOREIGN KEY (box_id) REFERENCES boxes(box_id);

ALTER TABLE addresses MODIFY COLUMN doner_id INT;
ALTER TABLE addresses MODIFY COLUMN customer_id INT;

CREATE INDEX last_name_idx ON customers(last_name);

-- DATA TO INSERT INTO TABLES 

INSERT INTO customers 
(customer_id, first_name, last_name, email, account_type)
VALUES
(301, 'Recbecca','Blake', 'r.blake@hotmail.com', 'Subscriber'),
(302, 'April','Gillford', 'a.gillford@hotmail.com', 'Subscriber'),
(303, 'Nadia','Reed', 'n.reed@hotmail.com', 'Subscriber'),
(304, 'Adam','James', 'a.james@hotmail.com', 'Subscriber'),
(305, 'Michelle','Cole', 'm.cole@hotmail.com', 'Subscriber'),
(306, 'Oonough','Miller', 'oo.miller@hotmail.com', 'Subscriber'),
(307, 'Noah','Seccombe', 'n.seccombe@hotmail.com', 'Subscriber'),
(308, 'Oliver','Jenson', 'o.jenson@hotmail.com', 'Subscriber'),
(309, 'Claire','Jennings', 'c.jennings@hotmail.com', 'Subscriber'),
(310, 'Jude','Mcflarren', 'j.mcflarren@hotmail.com', 'Order'),
(311, 'Ruby','Jackson', 'r.jackson@hotmail.com', 'Order'),
(312, 'Grace','Jackson', 'gjson@hotmail.com', 'Order');

INSERT INTO food_doners
(doner_id, name, phone_no, email)
VALUES
(101, NULL, '01225723333', 'hello@riversidefarm.co.uk'),
(102, 'Darios', '01568613156', 'hello@packfarm.co.uk'),
(103, 'Charles', '01568613425', 'hello@stonegatefarm.co.uk'),
(104, 'Michelle', '01622765400', NULL),
(105, 'Grace', '01732810378', 'hello@enchmarsh.co.uk'), 
(106, 'Arthur', '01474879190', 'hello@actonpigott.co.uk'), 
(107, NULL, '01452813216', 'enquiries@brinton.co.uk'),
(108, 'Stephen', '01225723333', 'enquiries@limpley.co.uk');

INSERT INTO addresses
(location_id, doner_id, customer_id, street_building, city, postcode)
VALUES
(401, 101, NULL, 'Riverside Farm Winsley Street', 'Canterbury', 'CT4 7DT'),
(402, 102, NULL, 'Pack Farm Bow Lane', 'Faversham', 'ME13 0PF'),
(403, 103, NULL, 'Stonegate Bardown Road', 'Wadhurst', 'TN5 7ED'),
(404, 104, NULL, 'Barelands Farm Bells Yew Road', 'Tunbridge Wells', 'TN3 9BD'),
(405, 105, NULL, 'Enchmarsh Church Street', 'Shropshire', 'TF13 6LH'),
(406, 106, NULL, 'Acton Pigott Cound Lane', 'Shrewsbury', 'SY5 7PH'),
(407, 107, NULL, 'Brinton Hotel Brinton Lane', 'Leominster', 'HR6 0AW'),
(408, 108, NULL, 'Limpley Hotel Woods Hill', 'Bath', 'BA2 7FZ'),
(409, NULL, 301, '50 Gilespy Road', 'London', 'E17 5BT'),
(410, NULL, 302, '10 Parkhill Road', 'London', 'E4 7ED'),
(411, NULL, 303, '15 Manor Way', 'Brighton', 'BR1 8PT'),
(412, NULL, 304, '2 Lausanne Road', 'Manchester', 'M20 7PQ'),
(413, NULL, 305, '15 Rippingham Road', 'Manchester', 'M20 8LP'),
(414, NULL, 306, '12 Calstock Road', 'Nottingham', 'NG5 4FH'),
(415, NULL, 307, '33 Plough Lane', 'Nottingham', 'NG13 7AT'),
(416, NULL, 308, '59 Hawthorne Close', 'London', 'N1 4AW'),
(417, NULL, 309, '37A Avennell Road', 'London', 'N5 6EY'),
(418, NULL, 310, '41 Pickhurst Park', 'Kent', 'BR2 0PY'),
(419, NULL, 311, '21C Kings Road', 'London', 'SW1 9BU'),
(420, NULL, 312, '29A Acton Road', 'London', 'SW7 8DF');


INSERT INTO boxes 
(box_id, box_type)
VALUES
(701, 'small_fruit_box'),
(702, 'small_veg_box'),
(703, 'small_fruit_veg_box'),
(704, 'Medium_fruit_veg_box'),
(705, 'large_fruit_veg_box'),
(706, 'large_mixed_box');

-- FOOD IS PACKAGED IN BUNDLES, UNIT QUANTITIES REFERS TO THE NUMBER OF BUNDLES
-- BUNDLE POTATOES IS 1KG, EGGS COME IN 6, BREAD IN LOAVES, MILK IN 2PINTS
INSERT INTO food
(food_id, doner_id, box_id, food_type, expiry_date, quantity, weight_kg, temp_controlled)
VALUES
(201, 106, 702, 'Potatoes', '2025-03-15', 20, 1.00, 'No'),
(202, 106, 702, 'Carrots', '2025-03-15', 10, 0.50, 'No'),
(203, 106, 702, 'Kale', '2025-02-27', 10, 0.40, 'Yes'),
(204, 104, 701, 'Strawberries', '2025-03-15', 7, 0.20, 'Yes'),
(205, 104, 701, 'Blackberries', '2025-03-15', 7, 0.20, 'Yes'),
(206, 101, 701, 'Apples', '2025-03-15', 12, 0.75, 'No'),
(207, 101, 703, 'Pears', '2025-03-15', 12, 0.75, 'No'),
(208, 101, 705, 'Kiwi', '2025-03-15', 10, 0.55, 'No'),
(209, 102, 705, 'Oranges', '2025-03-15', 10, 0.75, 'No'),
(210, 102, 704, 'Rhubarb', '2025-03-15', 10, 0.75, 'No'),
(211, 102, 704, 'Plumbs', '2025-03-15', 10, 0.55, 'No'),
(212, 103, 706, 'Peach', '2025-03-15', 10, 0.55, 'No'),
(213, 102, 703, 'Tomatoes', '2025-03-15', 8, 0.15, 'Yes'),
(214, 103, 703, 'Cabbage', '2025-03-15', 8, 0.30, 'No'),
(215, 103, 705, 'Broccoli', '2025-03-15', 10, 0.35, 'No'),
(216, 104, 705, 'Asparagus', '2025-03-07', 10, 0.15, 'No'),
(217, 105, 704, 'Broad Beans', '2025-03-07', 10, 0.15, 'No'),
(218, 105, 704, 'Sweetcorn', '2025-03-07', 10, 0.15, 'No'),
(219, 106, 706, 'Cauliflower', '2025-03-07', 10, 0.15, 'No'),
(220, 106, 706, 'Courgette', '2025-03-07', 10, 0.15, 'No'),
(221, 105, 705, 'Peas', '2025-03-07', 10, 0.15, 'No'),
(222, 108, 706, 'Bread', '2025-03-07', 7, NULL, 'No'),
(223, 107, 706, 'Chicken', '2025-02-27', 3, 0.50, 'Yes'),
(224, 107, 706, 'Eggs', '2025-03-15', 3, 0.30, 'No'),
(225, 108, 706, 'Milk', '2025-02-26', 3, NULL, 'Yes');


INSERT INTO orders
(customer_id, box_id, delivery_date)
VALUES
(307, 701, '2025-02-23'),
(309, 702, '2025-02-23'),
(310, 703, '2025-02-23'),
(310, 704, '2025-02-23'),
(302, 705, '2025-02-23'),
(304, 706, '2025-02-23'),
(311, 701, '2025-02-23'),
(311, 702, '2025-02-23'),
(311, 703, '2025-02-23'),
(312, 704, '2025-02-23');


INSERT INTO subscriptions
(subscription_id, box_id, frequency, customer_id, delivery_date, skip_applied)
VALUES
(601, 701, 'Weekly', 301, '2025-02-23', 'Yes'),
(602, 701, 'Weekly', 302, '2025-02-23', NULL),
(603, 703, 'Weekly', 303, '2025-02-23', NULL),
(604, 704, 'Weekly', 304, '2025-02-23', NULL),
(605, 702, 'Weekly', 305, '2025-02-23', NULL),
(606, 702, 'Weekly', 306, '2025-02-23', 'Yes'),
(607, 705, 'Fortnightly', 307, '2025-02-23', NULL),
(608, 702, 'Weekly', 308, '2025-02-23', 'Yes'),
(609, 706, 'Fortnightly', 309, '2025-02-23', NULL);

INSERT INTO feedback 
(feedback_id, customer_id, box_id, order_no, subscription_id, feedback_message, rating)
VAlUES
(801, 304, 704, NULL, 604, 'Great fruit and veg box, perfect for our weekly intake', 5),
(802, 303, 703, NULL, 603, 'Love our box and saving food is even better!', 5),
(803, 309, 706, NULL, 609, 'Good mix of food, sometimes the milk is close to expiry date', 3),
(804, 301, 701, NULL, 601, 'Perfect for us', 4),
(805, 302, 701, NULL, 602, 'Great produce', 5),
(806, 306, 702, NULL, 606, 'Amazing!', 5),
(807, 308, 702, NULL, 608, 'Great food, sometimes we need to skip as we cannot get through it all', 4),
(808, 309, 702, 502, NULL, 'Amazing box, I ordered as extra box', 5),
(809, 304, 706, 506, NULL, 'Ordered as extra essentials and was pleased', 4);

INSERT INTO delivery 
(courier_id, food_id, order_no, collection_date, delivery_date, temp_controlled)
VALUES
(901, 201, 501, '2025-02-23-10-01-01', '2025-02-23-12-01-01', 'No'),
(902, 202, 502, '2025-02-23-10-01-01', '2025-02-23-12-01-01', 'No');

-- DELETE ROW FROM DELIVERY 
DELETE FROM delivery WHERE order_no = 502;

-- DROP TABLE DELIVERY AS NOT NEEDED 
DROP TABLE delivery; 

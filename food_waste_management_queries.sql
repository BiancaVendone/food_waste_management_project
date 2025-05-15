-- JOIN TABLE BOXES AND FOOD TO LIST FOOD TYPES IN EACH BOX
SELECT b.box_id, b.box_type, f.food_id, f.food_type
FROM boxes b 
JOIN food f
ON b.box_id = f.box_id
ORDER BY b.box_id;

-- JOIN TO SELECT ORDERS WITH FOOD ITEMS THAT NEED TO BE STORED AND TANSPORTED IN 
-- TEMPERATURE CONTROLLED ENVIRONMENTS 
SELECT b.box_id, o.order_no, f.temp_controlled
FROM boxes b 
JOIN orders o ON b.box_id = o.box_id
JOIN food f ON o.box_id = f.box_id
WHERE temp_controlled = 'Yes'
GROUP BY box_id, order_no
ORDER BY box_id;


-- NESTED QUERY TO RETURN CUSTOMER FULL NAME & ID OF SUBSCRIPTION CUSTOMERS WHO HAVE PLACED 
-- ADDITIONAL ORDERS ON TOP OF SUBSCRIPTIONS FOR COMPANY TO OFFER 5% DISCOUNT ON NEXT BOX        
SELECT 
	c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name
FROM customers c
WHERE c.customer_id IN (SELECT 
					s.customer_id
				FROM subscriptions s
				WHERE s.customer_id IN (SELECT
								o.customer_id
							FROM orders o
							WHERE o.customer_id = s.customer_id
                            ORDER BY c.customer_id DESC));
                            

-- SAME AS ABOVE IN A STORED PROCEDURE WITH A JOIN INSTEAD OF NESTED QUERY 
-- TO SELECT CUSTOMER ID, FIRST AND LAST NAME (WITHOUT STRING CONCATINATION) 
-- AND NUMBER OF ADDITIONAL ORDERS PLACED BY SUBSCRIPTION CUSTOMERS 
DELIMITER //
CREATE PROCEDURE subscription_customer_additional_orders()
BEGIN    
    SELECT 
		c.customer_id, 
        c.first_name, 
        c.last_name, 
        COUNT(o.order_no) AS number_additional_orders
	FROM customers c 
    JOIN orders o
    ON c.customer_id = o.customer_id
	JOIN subscriptions s
	ON c.customer_id = s.customer_id
	GROUP BY c.customer_id
    ORDER BY c.customer_id;
    
END //
DELIMITER ;

CALL subscription_customer_additional_orders();

-- IF NEED TO DROP UNCOMMENT AND RUN BELOW 
-- DROP PROCEDURE subscription_customer_additional_orders;


-- TOTAL NUMBER OF BOXES SOLD GROUPED BY BOX TYPE IN DESC ORDER
SELECT b.box_type, COUNT(b.box_id) AS total_boxes_sold
FROM boxes b
JOIN subscriptions s
ON b.box_id = s.box_id
JOIN orders o
ON b.box_id = o.box_id
GROUP BY b.box_type
ORDER BY total_boxes_sold DESC;
-- REMOVE SEMI COLON AFTER DESC ABOVE AND UNCOMMENT BELOW IF YOU ONLY WANT TO SEE TOP 2 SELLING BOXES
-- LIMIT 2;

-- BOXES SOLD CREATED AS VIEW
CREATE VIEW vw_boxes_sold
AS
SELECT b.box_type, COUNT(b.box_id) AS total_boxes_sold
FROM boxes b
JOIN subscriptions s
ON b.box_id = s.box_id
JOIN orders o
ON b.box_id = o.box_id
GROUP BY b.box_type
ORDER BY total_boxes_sold DESC;


-- TOTAL FOOD WEIGHT OF EACH BOX TYPE 
-- CODE WORKS
SELECT b.box_id, b.box_type, SUM(f.weight_kg) AS box_weight_kg
FROM boxes b
JOIN food f ON b.box_id = f.box_id
GROUP BY b.box_id, b.box_type
ORDER BY b.box_id; 

-- BOX WEIGHT CREATED AS VIEW 
CREATE VIEW vw_box_weight
AS
SELECT b.box_id, b.box_type, SUM(f.weight_kg) AS box_weight_kg
FROM boxes b
JOIN food f ON b.box_id = f.box_id
GROUP BY b.box_id, b.box_type
ORDER BY b.box_id; 


-- QUERY TO GET THE TOTAL WEIGHT OF FOOD SAVED FROM ORDERS AND SUBSCRIPTIONS 
-- FROM VIEW TABLES 
SELECT 
	bw.box_id, 
    bs.box_type, 
    bs.total_boxes_sold * bw.box_weight_kg AS total_food_saved_kg
FROM vw_boxes_sold bs
JOIN vw_box_weight bw ON bs.box_type = bw.box_type
ORDER BY total_food_saved_kg DESC;

-- TRYING TO CALCULATE TOTAL FOOD WEIGHT SOLD, GENERATES TABLE BUT RESULTS ARE NOT CORRECT
-- I THINK THIS IS DUE TO HOW TABLES ARE SET UP, I HAD TO LIST EACH FOOD ITEM ON A SINGLE ROW 
-- SO BOX IDS ARE SHOWN ON MORE THAN ONE ROW 
-- I CREATED VIEW TABLES IN ORDER TO CALCULATE WEIGHT INSTEAD
SELECT
	b.box_id, 
    COUNT(b.box_type) AS total_boxes_sold,
    SUM(f.weight_kg) AS box_weight_kg
FROM boxes b
JOIN subscriptions s ON b.box_id = s.box_id
JOIN orders o ON b.box_id = o.box_id
JOIN food f ON b.box_id = f.box_id
GROUP BY b.box_id 
ORDER BY total_boxes_sold DESC;    

-- INCORRECT RESULTS 
SELECT
	b.box_id, 
    COUNT(b.box_type) AS total_boxes_sold,
    SUM(f.weight_kg) AS box_weight_kg
FROM boxes b
JOIN subscriptions s 
JOIN orders o 
JOIN food f 
WHERE b.box_id = s.box_id
AND b.box_id = o.box_id
AND b.box_id = f.box_id
GROUP BY b.box_id 
ORDER BY total_boxes_sold DESC; 

-- RETURNS A TABLE BUT NO RESULTS 
SELECT
	b.box_id, 
    b.box_type,
    COUNT(b.box_type) AS total_boxes_sold,
    SUM(f.weight_kg) AS box_weight_kg
FROM boxes b
JOIN subscriptions s 
JOIN orders o 
JOIN food f 
WHERE b.box_id IN (SELECT
	SUM(f.weight_kg) AS box_weight_kg 
    FROM food 
    GROUP BY b.box_type)
AND b.box_id = s.box_id
AND s.box_id = o.box_id 
GROUP BY b.box_id
ORDER BY total_boxes_sold DESC;  



-- STORED PROCEDURE TO CHECK FOOD ITEMS WHERE EXPIRY DATE IS WITHIN 3 DAYS 
-- FROM DELIVERY DATE FOR SUBSCRIPTIONS AND ORDERS  
-- CODE WORKS  
DELIMITER //

CREATE PROCEDURE check_expiry_date()
BEGIN
	SELECT 
		f.food_id, 
		f.food_type, 
		f.expiry_date, 
		s.delivery_date AS subscription_delivery_date, 
		o.delivery_date AS order_delivery_date
	FROM food f
	JOIN subscriptions s ON f.box_id = s.box_id
	JOIN orders o ON f.box_id = o.box_id
	WHERE DATE_SUB(f.expiry_date, INTERVAL 3 DAY) <= s.delivery_date 
	AND DATE_SUB(f.expiry_date, INTERVAL 3 DAY) <= o.delivery_date;

END //

DELIMITER ;

CALL check_expiry_date();

-- IF NEED TO DROP UNCOMMENT AND RUN BELOW 
-- DROP PROCEDURE check_expiry_date;
 
    
-- REPLACE NULL VALUES TO SUBSCRIPTION TABLE SKIP_APPLIED COLUMN WITH NO 
UPDATE subscriptions SET skip_applied='No' WHERE skip_applied IS NULL; 


-- CUSTOMERS WHO HAVE NOT APPLIED SKIPS TO DELIVERIES WHO COULD BE ELIGABLE FOR A DISCOUNT
SELECT c.customer_id, c.first_name, s.skip_applied
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
WHERE s.skip_applied != 'Yes';
						

-- VIEW TO ANALYSE FEEDBACK ON BOX TYPES 
CREATE VIEW vw_box_rating_analysis
AS
SELECT 
	b.box_id,
    b.box_type,
    f.feedback_id,
    f.rating
FROM boxes b
JOIN feedback f ON b.box_id = f.box_id;

-- IF NEED TO DROP UNCOMMENT AND RUN BELOW 
-- DROP VIEW vw_box_rating_analysis;


-- QUERY TO RETURN REVIEWS FROM VIEW WITH SCORE OF 4+
SELECT DISTINCT box_id, box_type, MAX(rating) AS max_box_rating
FROM vw_box_rating_analysis
WHERE Rating >= 4
GROUP BY box_id, box_type;

-- QUERY TO RETURN AVERAGE REVIEW RATING FROM VIEW ROUND TO 2 DECIMAL PLACES
SELECT DISTINCT box_id, box_type, ROUND(AVG(rating),2) AS average_box_rating
FROM vw_box_rating_analysis
WHERE Rating >= 4
GROUP BY box_id, box_type;

-- CREATE FUNCTION TO CALCULATE NUMBER OF BOXES SOLD BY BOX WEIGHT
DELIMITER //
CREATE FUNCTION total_weight_calculator_kg(N INT, NU DECIMAL(4,2))
RETURNS DECIMAL(4,2)
DETERMINISTIC
BEGIN
	RETURN N * NU;
END //
DELIMITER ;

-- UNCOMMENT BELOW AND RUN IF NEED TO DROP
-- DROP FUNCTION total_weight_calculator_kg;

SELECT total_weight_calculator_kg(6, 1.90); -- UNITS OF SMALL VEG BOX MULTIPLIED BY BOX WEIGHT
-- A collection of reports I wrote to pull from the database I created in the Hotel Database Creation file. I generated example data and populated the database with it.

-- Report 1: Provides a report of items and services. This joins the orders, items/services per order, and suppliers tables to see the amount in stock along with where the item/service is purchased from, when the item/service was last ordered, and whether it needs to be restocked/ordered again. 

SELECT DISTINCT i_s.items_services_id, items_services_name, s.supplier_name, 
amt_stock, reorder_amt, reorder_yn,
  	(SELECT MAX(order_date) 
 	FROM is_per_order AS ipo2 
  	JOIN orders AS o2 
  	ON ipo2.order_id = o2.order_id
  	WHERE ipo2.items_services_id = i_s.items_services_id) AS last_ordered
FROM items_services AS i_s
JOIN is_per_order AS ipo
     ON i_s.items_services_id = ipo.items_services_id
JOIN orders AS o
     ON ipo.order_id = o.order_id
JOIN suppliers AS s
	ON o.supplier_id = s.supplier_id
ORDER BY i_s.items_services_id;

-- Report 2: Provides information about employee performance. A reader can see how much employees make, if they are full-time or part-time, and if they are specifically mentioned in reviews, along with a performance score. An employee with a high score who was mentioned in reviews has stood out and may have earned a raise or promotion. An employee with a low score who was mentioned in reviews will probably need to be spoken to.

SELECT e.employee_id, emp_first_name, emp_last_name, title, hotel_name, ROUND(salary,0) AS salary, status, 
   (SELECT COUNT(DISTINCT r2.employee_id)
    FROM reviews AS r2
    WHERE r2.employee_id = e.employee_id) AS number_reviews_mentioned, performance_score,
    (CASE WHEN performance_score <7 THEN 'Y' ELSE '' END )AS reach_out_yn
FROM employees AS e
JOIN hotels AS h
	ON e.hotel_id = h.hotel_id
ORDER BY e.employee_id;


-- Report 3: Provides summary of hotel reservations by joining the hotels and reservations tables. The viewer can see how popular each hotel is and how long people stay there, how many extra expenses (ex. hotel bar, room service, extra amenities) are charged, and how many people cancel their reservations. 

SELECT r.hotel_id, hotel_name, COUNT(res_id) AS num_res, COUNT(DISTINCT cust_id) AS unique_cust_num,
	ROUND(AVG(check_out_date - check_in_date), 0) AS avg_stay_days,
	COUNT(extra_expenses) AS extra_charges_num,
	SUM(CASE WHEN cancelled_yn = 'Y' THEN 1 ELSE 0 END) AS num_cancels
FROM reservations AS r
JOIN hotels AS h 
	ON r.hotel_id = h.hotel_id
GROUP BY r.hotel_id, hotel_name
ORDER BY r.hotel_id;

-- Report 4: Provides summary of overall hotel ratings by joining the hotels table with the reviews table. When a hotel's rating is too low (overall_rating), it is marked as urgent. If there are reviews that have not been resolved yet, someone from customer service will reach out to the unhappy customer. 

SELECT r.hotel_id, hotel_name,  COUNT(*) AS number_reviews,
	ROUND(AVG(overall_rating), 1) AS avg_overall_rating,
	MAX(overall_rating) AS max_overall_rating,
	MIN(overall_rating) AS min_overall_rating,
	COUNT(CASE WHEN resolve_yn = 'Y' THEN 1 END) AS reviews_to_resolve,
	COUNT (CASE WHEN resolved_yn = 'Y' THEN 1 END) AS resolved_reviews,
	CASE WHEN AVG(overall_rating) < 4 THEN 'Y' ELSE 'N' END AS urgent_yn
FROM reviews AS r
JOIN hotels AS h ON r.hotel_id = h.hotel_id
GROUP BY r.hotel_id, hotel_name
ORDER BY r.hotel_id;

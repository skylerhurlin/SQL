-- Provides a report of items and services.

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

-- Provides information about employee performance.

SELECT e.employee_id, emp_first_name, emp_last_name, title, hotel_name, ROUND(salary,0) AS salary, status, 
   (SELECT COUNT(DISTINCT r2.employee_id)
    FROM reviews AS r2
    WHERE r2.employee_id = e.employee_id) AS number_reviews_mentioned, performance_score,
    (CASE WHEN performance_score <7 THEN 'Y' ELSE '' END )AS reach_out_yn
FROM employees AS e
JOIN hotels AS h
	ON e.hotel_id = h.hotel_id
ORDER BY e.employee_id;


-- Provides summary of hotel reservations.

SELECT r.hotel_id, hotel_name, COUNT(res_id) AS num_res, COUNT(DISTINCT cust_id) AS unique_cust_num,
	ROUND(AVG(check_out_date - check_in_date), 0) AS avg_stay_days,
	COUNT(extra_expenses) AS extra_charges_num,
	SUM(CASE WHEN cancelled_yn = 'Y' THEN 1 ELSE 0 END) AS num_cancels
FROM reservations AS r
JOIN hotels AS h 
	ON r.hotel_id = h.hotel_id
GROUP BY r.hotel_id, hotel_name
ORDER BY r.hotel_id;

-- Provides summary of overall ratings.

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

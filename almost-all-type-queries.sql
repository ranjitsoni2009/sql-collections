/* AGGREGATE FUNCTIONS */
SELECT customer_id, AVG(amount) as avg_amount, SUM(amount) as total_amount, MIN(amount) as min_amount, MAX(amount) as max_amount, COUNT(amount) as total_amt_count 
FROM payment
GROUP BY customer_id HAVING count(*) > 10
ORDER BY total_amt_count;

/* STRING FUNCTIONS */
SELECT title, UPPER(title) as Upper_Title, LOWER(title) as Lower_Title, LENGTH(title) as title_length,  SUBSTRING(title, 2, 3) as title_substring_from_start, SUBSTRING(title, -4, 3) as title_substring_from_end, 
CONCAT(title, '-',release_year) as concat_title_year, TRIM(title) as trim_title,LTRIM(title) as ltrim_title, RTRIM(title) as rtrim_title, REPLACE(title, 'AF', 'Z') as replace_title, 
LEFT(title, 2) as left_title, RIGHT(title, 4) as right_title
FROM film limit 5 OFFSET 3;

/* NUMERIC FUNCTIONS */
SELECT payment_id, amount, ROUND(amount*amount, 3) as rounded_amt, CEIL(amount) as ceil_amount, FLOOR(amount) as floor_amount, ABS(amount) as abs_amount, MOD(amount, 2) as mod_amout
, POWER(amount, 2) as power_amount, SQRT(amount) as sqrt_amt
FROM payment LIMIT 10 OFFSET 2;
 

/* DATE & TIME FUNCTIONS */
select  NOW() , current_date, current_timestamp, DATE('2020-11-04'), YEAR('2020-11-04'), MONTH('2020-11-04'), DAY('2020-11-04'), 
datediff('2020-11-04', '2020-11-01'), DATE_ADD('2020-11-04', INTERVAL 5 year), DATE_SUB('2020-11-04', INTERVAL 5 day), DATE_SUB(current_date, INTERVAL 12 month) as twelve_passed_month_date;

/* Conditional Functions */
SELECT amount, 
		CASE 
			WHEN amount> 2 THEN 'Hgh Amount'
            ELSE 'Low'
		END AS Category
	FROM payment
    LIMIT 50 OFFSET 2;
    
SELECT IF(amount>2, 'High Value', 'Low Value') as Amount_Category FROM payment LIMIT 10 OFFSET 5;

SELECT coalesce(password, 'Not Available') FROM staff limit 100;

/* WINDOW FUNCTIONS - ROW_NUMBER(), RANK(), DENSE_RANK(), LAG(), LEAD() -- Aggregate function can be used with OVER() without passing anything inside it or or WITH passing PARTION BY*/
select name, marks, 
		ROW_NUMBER() OVER(ORDER BY marks DESC) AS row_number_1, 
        RANK() OVER(ORDER BY marks DESC) AS rank_number2,
        DENSE_RANK() OVER(ORDER BY marks DESC) AS desnse_rank_number1,
        LAG(marks) OVER(ORDER BY marks DESC) AS prev_std_marks,
        LEAD(marks) OVER(ORDER BY marks DESC) AS prev_std_marks,
        MIN(marks) OVER() AS MIN_MARKS,
        MAX(marks) OVER() AS MAX_MARKS,
        SUM(marks) OVER(PARTITION BY marks) AS TOTAL_CLASS_MARKS,
        AVG(marks) OVER(PARTITION BY marks) AS AVG_CLASS_MARKS
FROM student
ORDER BY marks DESC;

/* CONVERSION FUNCTION - CAST(), CONVERT() */
SELECT * FROM payment where CAST(amount AS CHAR) = '8.97'  limit 10; /* WRONG APPROACH, IF amount field is indexed, will imapct performance, instead apply CAST on value instead of column */
SELECT * FROM payment where amount = CAST('8.97' AS DECIMAL(5,2))  limit 10;
SELECT payment_id, amount, CAST(amount AS UNSIGNED) AS casted_amount, CONVERT(amount, UNSIGNED) AS converted_amount FROM payment limit 100;
SELECT special_features, CONVERT(special_features using eucjpms) AS converted_special_feature FROM film LIMIT 10;

/* LOGICAL OPERATORS - IN, BETWEEN, LIKE< EXISTS, ANY, ALL */
SELECT * FROM film WHERE rating IN ('PG', 'NC-17') LIMIT 100;
SELECT min(rental_rate) as min_rental_rate, max(rental_rate) as max_rental_rate FROM film WHERE rating = 'NC-17';
SELECT * FROM film WHERE rental_rate > ANY (SELECT rental_rate FROM film WHERE rating = 'NC-17');
SELECT * FROM film WHERE rental_rate > ALL (SELECT rental_rate FROM film WHERE rating = 'NC-17');
SELECT * FROM film WHERE rental_rate > (SELECT min(rental_rate) AS MAX_RENTAL_RATE FROM film WHERE rating = 'PG');
SELECT * FROM film f1 where EXISTS (SELECT 1 FROM film f2 where rating = 'PG' and rental_rate = 4.99 and f1.film_id = f2.film_id);
SELECT * FROM film where length between 100 and 150;

/* Misc Useful Functions - DISTINCT, GREATEST(), LEAST() 
DISTINCT → Removes duplicate rows based on the selected columns (product, highest_quarter_sales, lowest_quarter_sales).
GREATEST() → Returns the maximum value among the given columns for each row. 
	For Ex:- Table contain sales_value for difference reagion for each pro, duct then col would be Product, SALES_VALUE_ASIA, SALES_VALUE_AFRICA, SALES_VALUE_N_AMERICA
		then Apply like GREATEST(SALES_VALUE_ASIA, SALES_VALUE_AFRICA, SALES_VALUE_N_AMERICA), it will return max sales value among different region
LEAST() → Returns the minimum value among the given columns for each row.
	For Ex:- Table contain sales_value for difference reagion for each pro, duct then col would be Product, SALES_VALUE_ASIA, SALES_VALUE_AFRICA, SALES_VALUE_N_AMERICA
		then Apply like LEAST(SALES_VALUE_ASIA, SALES_VALUE_AFRICA, SALES_VALUE_N_AMERICA), it will return min sales value among different region
*/

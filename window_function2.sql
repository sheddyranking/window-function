SELECT  *
	FROM public.product;
	
-- FIRST_VALUE 
--Display the most expensive productS in each product category

  SELECT *,
	FIRST_VALUE(product_name) Over(partition by product_category order by price desc) as expensive_product
 FROM public.product
 
-- ths returns only the most expensive.
SELECT *
	FROM (
	  SELECT *,
		FIRST_VALUE(product_name) OVER (PARTITION BY product_category ORDER BY price DESC) AS expensive_product
	  FROM public.product
	) x
WHERE x.product_name = x.expensive_product;

-- LAST_VALUE 
--Display the least expensive productS in each product category
SELECT *,
  LAST_VALUE(product_name) OVER (
    PARTITION BY product_category 
    ORDER BY price DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS least_product
FROM public.product;


-- Alternative way of writting a window function
SELECT*,
	FIRST_VALUE(product_name) OVER w AS most_expensive,
	LAST_VALUE(product_name) OVER w AS Least_expensive
FROM public.product
	WINDOW w AS (Partition by product_category order by price DESC
				ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING );
	
	
--- return only the most and least expensive product

SELECT * FROM (
	SELECT*,
	FIRST_VALUE(product_name) OVER w AS most_expensive,
	LAST_VALUE(product_name) OVER w AS Least_expensive
	FROM public.product
	WINDOW w AS (Partition by product_category order by price DESC
				ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )
	) x
WHERE x.product_name = x.most_expensive OR x.product_name =  x.least_expensive;
	
-- NTH_VALUE 
-- Display the second most expensive product according to each category.
SELECT *,
	FIRST_VALUE(product_name) OVER w as most_expensive,
	NTH_VALUE(product_name,2) OVER w as second_expensive
FROM public.product
WINDOW w AS (PARTITION BY product_category ORDER BY price DESC
			  ROWS BETWEEN UNBOUNDED PRECEDING AND  UNBOUNDED FOLLOWING);
			  
			  
--NTILE
--group a product into expensive,mid_price and cheaper category

SELECT 
	product_name, 
	Price,
	CASE WHEN x.price_category = 1 THEN 'Expensive'
		WHEN x.price_category = 2 THEN 'Mide_Price'
		WHEN x.price_category = 3 THEN 'Cheaper'
		END AS Product_price_category
FROM(
	SELECT *,
		NTILE(3) OVER(ORDER BY price DESC) as Price_category
	FROM public.product
	WHERE product_category = 'Phone'
)x;
 
--- CUM_DIST (current_row = current_row/total_rows)

SELECT *,
	CUME_DIST() OVER(ORDER BY price) AS cumulative_distribution
 FROM public.product;
 
--select 30% of the data
SELECT product_name,(cumulative_dist_percent || '%' ) as cumulative_dist_percent FROM (
	SELECT *,
	CUME_DIST() OVER(ORDER BY price) AS cumulative_distribution,
	ROUND(CUME_DIST() OVER(ORDER BY price)::NUMERIC*100,2) AS cumulative_dist_percent
 FROM public.product
) x
WHERE x.cumulative_dist_percent <=30;

--percent_rank() (current_row = -1/total_row)
SELECT *,
	PERCENT_RANK() OVER(ORDER BY PRICE) AS per_rank
FROM public.product;

--find the percent of 'Galaxy Z Fold 3' compare to other products
SELECT product_name, per_rank FROM (
		SELECT *,
			ROUND(PERCENT_RANK() OVER(ORDER BY PRICE)::NUMERIC*100,2) AS per_rank
		FROM public.product
	)x
WHERE x.product_name = 'Galaxy Z Fold 3';




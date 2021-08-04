/* count table rows */

 */SELECT
    COUNT(*) as total_rows
  FROM `bigquery-public-data.iowa_liquor_sales`


--shows years
SELECT
  DISTINCT(FORMAT_DATE('%Y', date)) AS years,
  FROM `bigquery-public-data.iowa_liquor_sales`
  ORDER BY
    years DESC
LIMIT 1;


/* top 5 sales by date */

SELECT
    date,
    FORMAT_DATE('%A', date) AS day_name,
    ROUND(SUM(sale_dollars),2) AS total_sales,
FROM
    `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    date
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by weekday name */

SELECT
    FORMAT_DATE('%A', date) AS day_name,
    ROUND(SUM(sale_dollars),2) AS total_sales,
FROM
    `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    day_name
ORDER BY
    total_sales DESC
Limit 5;


/*  top 5 sales by month name */

SELECT
    FORMAT_DATE('%B', date) AS month,
    ROUND(SUM(sale_dollars),2) AS total_sales,
FROM
    `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    month
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by month (December) */

SELECT
    EXTRACT(DAY FROM date) AS the_day,
    ROUND(SUM(sale_dollars),2) AS total_sales,
FROM
     `bigquery-public-data.iowa_liquor_sales`
WHERE
    FORMAT_DATE('%B', date) = 'December'
GROUP BY
    the_day
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by month (June) */

SELECT
    EXTRACT(DAY FROM date) AS the_day,
    ROUND(SUM(sale_dollars),2) AS total_sales,
FROM
     `bigquery-public-data.iowa_liquor_sales`
WHERE
    FORMAT_DATE('%B', date) = 'June'
GROUP BY
    the_day
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by city */

SELECT
    LOWER(city) AS city,
    ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales,
FROM
     `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    city
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by county */

SELECT
    LOWER(county) AS county,
    ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales,
FROM
     `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    county
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by vendor */

SELECT
    LOWER(vendor_name) AS vendor,
    ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales
FROM
    `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    vendor
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by item */

SELECT
    LOWER(item_description) AS item,
    ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales
FROM
    `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    item
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by item & category */

SELECT
    LOWER(item_description) AS item,
    LOWER(category_name) AS category,
    ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales
FROM
    `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    item,category
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by item & category for 2020 */

SELECT
    FORMAT_DATE('%Y', date) AS year,
    LOWER(item_description) AS item,
    LOWER(category_name) AS category,
    ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales
FROM
    `bigquery-public-data.iowa_liquor_sales`
WHERE
    FORMAT_DATE('%Y', date) LIKE ('%2020%')
GROUP BY
    item,
    category,
    year
ORDER BY
    total_sales DESC
Limit 5;


/* top 5 sales by item & category for past 10 years */
SELECT
    FORMAT_DATE('%Y', date) AS year,
    LOWER(item_description) AS item,
    LOWER(category_name) AS category,
    ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales
FROM
    `bigquery-public-data.iowa_liquor_sales`
GROUP BY
    item,
    category,
    year
ORDER BY
    total_sales DESC
Limit 5;


/* create new table of items sales grouped by item,category, year */

CREATE TABLE
  `brilliant-era-321603.wbie.sale_items_by_year` AS
SELECT
  FORMAT_DATE('%Y', date) AS year,
  LOWER(item_description) AS item,
  LOWER(category_name) AS category,
  ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales
FROM
    `bigquery-public-data.iowa_liquor_sales`
GROUP BY
  item,
  category,
  year;


/* top 5 items by year (over 10 years) */
SELECT
  year,
  ARRAY_AGG(STRUCT(item,
      total_sales)
  ORDER BY
    total_sales DESC
  LIMIT
    5) AS top_sales
FROM `brilliant-era-321603.wbie.sale_items_by_year`
GROUP BY
  year
ORDER BY
  year DESC
Limit 5;



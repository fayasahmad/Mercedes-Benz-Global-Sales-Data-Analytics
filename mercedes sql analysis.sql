select top 5 * from Sales
order by Base_price asc


--1. What is our total revenue and total units sold across all years
-- Calculate total revenue and sales volume
SELECT 
    COUNT(*) AS total_transactions,
    SUM(sales_volume) AS total_units_sold,
    SUM(base_price * sales_volume) AS total_revenue,
    AVG(base_price) AS avg_price_per_unit,
    AVG(sales_volume) AS avg_units_per_transaction
FROM Sales;

--2. How have our sales performed year-over-year from 2020 to 2025?
-- Sales trend analysis by year
select
   distinct year,
  Sum(sales_volume) as Yoy_Sales,
  SUM(base_price * sales_volume) AS YOY_total_revenue
From Sales
Group by year
Order by year asc

-- Add year-over-year growth calculation
SELECT 
    [year],
    total_units,
    LAG(total_units) OVER (ORDER BY [year]) AS prev_year_units,
    total_units - LAG(total_units) OVER (ORDER BY [year]) AS unit_change,
    Concat(
        ROUND(
            (total_units - LAG(total_units) OVER (ORDER BY [year])) * 100.0 / 
            NULLIF(LAG(total_units) OVER (ORDER BY [year]), 0)
        ,2)
    ,'%'
    ) AS yoy_growth_pct
FROM (
    SELECT 
        [year],
        SUM(sales_volume) AS total_units
    FROM Sales
    GROUP BY [year]
) yearly_sales
ORDER BY [year];

--3. Which are our top 10 best-selling models by total units sold?
-- Top 10 models by sales volume
SELECT TOP 10
    model,
    SUM(sales_volume) AS total_units_sold,
    SUM(base_price * sales_volume) AS total_revenue,
    AVG(base_price) AS avg_price,
    COUNT(*) AS number_of_transactions,
    MIN(year) AS first_year_sold,
    MAX(year) AS last_year_sold
FROM Sales
GROUP BY model
ORDER BY total_units_sold DESC;

-- Bottom 10 models (potential discontinuation candidates)
SELECT TOP 10
    model,
    SUM(sales_volume) AS total_units_sold,
    SUM(base_price * sales_volume) AS total_revenue,
    AVG(base_price) AS avg_price,
    COUNT(*) AS number_of_transactions,
    MIN(year) AS first_year_sold,
    MAX(year) AS last_year_sold
FROM Sales
GROUP BY model
ORDER BY total_units_sold asc;

--4. What is the current distribution of sales by fuel type?

-- Fuel type sales distribution
SELECT 
    fuel_type,
    SUM(sales_volume) AS total_units,
    ROUND(
        SUM(sales_volume) * 100.0 / 
        (SELECT SUM(sales_volume) FROM Sales), 
        2
    ) AS market_share_pct,
    SUM(base_price * sales_volume) AS total_revenue,
    AVG(base_price) AS avg_price,
    COUNT(*) AS transactions
FROM Sales
GROUP BY fuel_type
ORDER BY total_units DESC;


--5. Which models are growing vs.declining year-over-year?
-- YoY growth analysis by model
WITH yearly_model_sales AS (
    SELECT 
        model,
        year,
        SUM(sales_volume) AS yearly_units,
        SUM(base_price * sales_volume) AS yearly_revenue
    FROM Sales
    GROUP BY model, year
)
SELECT 
    model,
    year,
    yearly_units,
    LAG(yearly_units) OVER (PARTITION BY model ORDER BY year) AS prev_year_units,
    yearly_units - LAG(yearly_units) OVER (PARTITION BY model ORDER BY year) AS unit_change,
    CASE 
        WHEN LAG(yearly_units) OVER (PARTITION BY model ORDER BY year) IS NULL THEN NULL
        ELSE cast(
            (yearly_units - LAG(yearly_units) OVER (PARTITION BY model ORDER BY year)) * 100.0 / 
            LAG(yearly_units) OVER (PARTITION BY model ORDER BY year)as decimal (10,2)    
        )
    END AS yoy_growth_pct
FROM yearly_model_sales
ORDER BY model, year;


--6. How do different price segments perform in terms of volume and revenue?
-- Price segment analysis
SELECT 
    price_category,
    COUNT(*) AS transactions,
    SUM(sales_volume) AS total_units,
    SUM(base_price * sales_volume) AS total_revenue,
    ROUND(AVG(base_price), 2) AS avg_price,
    ROUND(AVG(sales_volume), 2) AS avg_units_per_transaction,
    -- Market share metrics
    Cast(
        SUM(sales_volume) * 100.0 / (SELECT SUM(sales_volume) FROM Sales)
        as decimal (10,2) 
    ) AS volume_share_pct,
    Cast(
        SUM(base_price * sales_volume) * 100.0 / (SELECT SUM(base_price * sales_volume) FROM Sales)
        as decimal (10,2) 
    ) AS revenue_share_pct
FROM Sales
GROUP BY price_category
ORDER BY total_revenue DESC;

--7. How has the average selling price changed over time? Are cars getting more expensive? 
-- Average price trend with year-over-year comparison

WITH yearly_price AS (
    SELECT 
        year,
        AVG(base_price) AS avg_price,
        MIN(base_price) AS min_price,
        MAX(base_price) AS max_price,
        COUNT(*) AS transactions
    FROM Sales
    GROUP BY year
)
SELECT 
    year,
    ROUND(avg_price, 2) AS avg_price,
    ROUND(min_price, 2) AS min_price,
    ROUND(max_price, 2) AS max_price,
    LAG(avg_price) OVER (ORDER BY year) AS prev_year_avg,
    ROUND(avg_price - LAG(avg_price) OVER (ORDER BY year), 2) AS price_change,
    CASE 
        WHEN LAG(avg_price) OVER (ORDER BY year) IS NULL THEN NULL
        ELSE ROUND(
            (avg_price - LAG(avg_price) OVER (ORDER BY year)) * 100.0 / 
            LAG(avg_price) OVER (ORDER BY year), 
            2
        )
    END AS price_inflation_pct,
    transactions
FROM yearly_price
ORDER BY year;

--8. Is the turbo feature becoming more popular? What's the adoption trend?
-- Turbo adoption trend analysis
WITH turbo_analysis AS (
    SELECT 
        year,
        SUM(CASE WHEN turbo = 'yes' THEN sales_volume ELSE 0 END) AS turbo_units,
        SUM(CASE WHEN turbo = 'no' THEN sales_volume ELSE 0 END) AS non_turbo_units,
        SUM(sales_volume) AS total_units,
        AVG(CASE WHEN turbo = 'yes' THEN base_price END) AS avg_turbo_price,
        AVG(CASE WHEN turbo = 'no'  THEN base_price END) AS avg_non_turbo_price
    FROM Sales
    GROUP BY year
)
SELECT 
    year,
    turbo_units,
    non_turbo_units,
    total_units,
    cast(turbo_units * 100.0 / total_units as decimal(10,2)) AS turbo_adoption_pct,
    ROUND(avg_turbo_price, 2) AS avg_turbo_price,
    ROUND(avg_non_turbo_price, 2) AS avg_non_turbo_price,
    ROUND(avg_turbo_price - avg_non_turbo_price, 2) AS turbo_premium,
    cast((avg_turbo_price - avg_non_turbo_price) * 100.0 / avg_non_turbo_price as decimal(10,2)) AS premium_pct
FROM turbo_analysis
ORDER BY year;

--9. Do 20% of our models generate 80% of our revenue? (Pareto Principle)
-- Pareto analysis: Revenue concentration by model
WITH model_revenue AS (
    SELECT 
        model,
        SUM(base_price * sales_volume) AS total_revenue,
        SUM(sales_volume) AS total_units
    FROM Sales
    GROUP BY model
),
ranked_models AS (
    SELECT 
        model,
        total_revenue,
        total_units,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        COUNT(*) OVER () AS total_models,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS grand_total_revenue
    FROM model_revenue
)
SELECT 
    model,
    ROUND(total_revenue, 2) AS total_revenue,
    total_units,
    revenue_rank,
    ROUND(total_revenue * 100.0 / grand_total_revenue, 2) AS revenue_share_pct,
    ROUND(cumulative_revenue * 100.0 / grand_total_revenue, 2) AS cumulative_revenue_pct,
    ROUND(revenue_rank * 100.0 / total_models, 2) AS model_pct
FROM ranked_models
ORDER BY revenue_rank;

--9. Which models have consistent sales vs. volatile/unpredictable sales?
-- Sales volatility analysis (coefficient of variation)
WITH yearly_model_sales AS (
    SELECT 
        model,
        year,
        SUM(sales_volume) AS yearly_units
    FROM Sales
    GROUP BY model, year
),
volatility_calc AS (
    SELECT 
        model,
        AVG(yearly_units) AS avg_yearly_sales,
        STDEV(yearly_units) AS std_dev_sales,
        MIN(yearly_units) AS min_yearly_sales,
        MAX(yearly_units) AS max_yearly_sales,
        COUNT(*) AS years_available
    FROM yearly_model_sales
    GROUP BY model
)
SELECT 
    model,
    ROUND(avg_yearly_sales, 2) AS avg_yearly_sales,
    ROUND(std_dev_sales, 2) AS std_dev_sales,
    -- Coefficient of Variation (CV): Lower = More Consistent
    ROUND(std_dev_sales / NULLIF(avg_yearly_sales, 0) * 100, 2) AS coefficient_of_variation,
    min_yearly_sales,
    max_yearly_sales,
    max_yearly_sales - min_yearly_sales AS sales_range,
    years_available,
    CASE 
        WHEN std_dev_sales / NULLIF(avg_yearly_sales, 0) < 0.2 THEN 'Very Stable'
        WHEN std_dev_sales / NULLIF(avg_yearly_sales, 0) < 0.4 THEN 'Stable'
        WHEN std_dev_sales / NULLIF(avg_yearly_sales, 0) < 0.6 THEN 'Moderate'
        ELSE 'Volatile'
    END AS stability_category
FROM volatility_calc
WHERE years_available >= 5  -- Only models sold consistently
ORDER BY coefficient_of_variation ASC;  -- Most stable first

-- Are expensive models underperforming?
WITH model_stats AS (
    SELECT 
        model,
        AVG(base_price) AS avg_price,
        SUM(sales_volume) AS total_sales,
        NTILE(4) OVER (ORDER BY AVG(base_price) DESC) AS price_quartile,
        NTILE(4) OVER (ORDER BY SUM(sales_volume) ASC) AS sales_quartile
    FROM sales
    GROUP BY model
)
SELECT *
FROM model_stats
WHERE price_quartile = 1  -- top 25% price
  AND sales_quartile = 1; -- bottom 25% sales

-- efficiency_gap CALCULATION 

  WITH revenue_calc AS (
    SELECT 
        model,
        SUM(base_price * sales_volume) AS estimated_revenue,
        SUM(sales_volume) AS total_sales
    FROM sales
    GROUP BY model
),
ranked AS (
    SELECT 
        model,
        estimated_revenue,
        total_sales,
        DENSE_RANK() OVER (ORDER BY estimated_revenue DESC) AS revenue_rank,
        DENSE_RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
    FROM revenue_calc
)
SELECT *,
       (sales_rank - revenue_rank) AS efficiency_gap
FROM ranked
ORDER BY efficiency_gap DESC;


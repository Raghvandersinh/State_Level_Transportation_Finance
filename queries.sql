
DESCRIBE State_Level_Transportation_Finance.transportation_state_finanace;

-- Select COUNT(*) FROM State_Level_Transportation_Finance.transportation_state_finanace;
-- SELECT mode, COUNT(*) 
-- FROM State_Level_Transportation_Finance.transportation_state_finanace
-- GROUP BY mode;

-- SELECT DISTINCT mode, year
-- FROM State_Level_Transportation_Finance.transportation_state_finanace
-- where mode = 'Air';

-- /*Get total expenditure by state 2024(post covid)*/
-- Select year, cash_flow, mode, state, state_code, 
-- SUM(chained_per_pop) as total_expenditure_per_state,
-- DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
-- from State_Level_Transportation_Finance.transportation_state_finanace
-- Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,024'
-- and gov_level = 'State and Local'
-- GROUP BY 1,2,3,4,5
-- ORDER BY total_spend_rank;

-- /*Get total expenditure by state 2020(Start covid)*/
-- Select year, cash_flow, mode, state, state_code, 
-- SUM(chained_per_pop) as total_expenditure_per_state,
-- DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
-- from State_Level_Transportation_Finance.transportation_state_finanace
-- Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,020'
-- and gov_level = 'State and Local'
-- GROUP BY 1,2,3,4,5
-- ORDER BY total_spend_rank;

-- /*Get total expenditure by state 2022(Mid covid)*/
-- Select year, cash_flow, mode, state, state_code, 
-- SUM(chained_per_pop) as total_expenditure_per_state,
-- DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
-- from State_Level_Transportation_Finance.transportation_state_finanace
-- Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,022'
-- and gov_level = 'State and Local'
-- GROUP BY 1,2,3,4,5
-- ORDER BY total_spend_rank;


-- /*Get total expenditure by state 2022(Post covid)*/

-- Select year, cash_flow, mode, state, state_code, 
-- SUM(chained_per_pop) as total_expenditure_per_state,
-- DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
-- from State_Level_Transportation_Finance.transportation_state_finanace
-- Where cash_flow = 'Revenue' and mode = 'Air' and year = '2,024'
-- and gov_level = 'State and Local'
-- GROUP BY 1,2,3,4,5
-- ORDER BY total_spend_rank;

-- /*Get total expenditure by state 2022(Mid covid)*/

-- Select year, cash_flow, mode, state, state_code, 
-- SUM(chained_per_pop) as total_expenditure_per_state,
-- DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
-- from State_Level_Transportation_Finance.transportation_state_finanace
-- Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,022'
-- and gov_level = 'State and Local'
-- GROUP BY 1,2,3,4,5
-- ORDER BY total_spend_rank;

-- /*Get total expenditure by state 2022(Start covid)*/
-- Select year, cash_flow, mode, state, state_code, 
-- SUM(chained_per_pop) as total_expenditure_per_state,
-- DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
-- from State_Level_Transportation_Finance.transportation_state_finanace
-- Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,020'
-- and gov_level = 'State and Local'
-- GROUP BY 1,2,3,4,5
-- ORDER BY total_spend_rank;

-- Select year, cash_flow, mode, state, state_code, 
-- SUM(chained) OVER(PARTITION BY state, year) as total_expenditure,
-- DENSE_RANK() OVER(ORDER BY SUM(chained)) as ranked_total_expenditure,
-- CASE
--     WHEN year = '2,020' THEN 'Start of Covid'
--     When year = '2,022' THEN  'Midsts of Covid'
--     Else 'Post Covid'
-- END as covid_period
-- FROM State_Level_Transportation_Finance.transportation_state_finanace
-- Where cash_flow = 'Revenue' and mode = 'Air' and year in ('2,020', '2,022', '2,024');

/*Total Expenditure by State in Covid Periods */
COPY(
WITH get_total_expenditure AS (
    Select year, cash_flow, mode, state, state_code, 
    SUM(ROUND(CAST(REPLACE(chained,',','') AS DECIMAL),2)) OVER(PARTITION BY state, year) as total_expenditure_year,
    SUM(ROUND(CAST(REPLACE(chained,',','') AS DECIMAL),2)) OVER(PARTITION BY state) as total_expenditure_state,
    CASE
        WHEN year = '2,020' THEN 'Start of Covid'
        When year = '2,022' THEN  'Midsts of Covid'
        Else 'Post Covid'
    END AS covid_period
    FROM State_Level_Transportation_Finance.transportation_state_finanace
    Where cash_flow = 'Expenditure' and mode = 'Air' and year in ('2,020', '2,022', '2,024')
)
SELECT DISTINCT *,
DENSE_RANK() OVER(ORDER BY total_expenditure_state DESC) as ranked_total_expenditure
FROM get_total_expenditure
ORDER BY state
) TO 'total_expenditure_covid_period.csv' (HEADER, DELIMITER ',');

/*Total Revenue by State in Covid Periods */
COPY(
WITH get_total_revenue AS (
    Select year, cash_flow, mode, state, state_code, 
    SUM(ROUND(CAST(REPLACE(chained,',','') AS DECIMAL),2)) OVER(PARTITION BY state, year) as total_revenue_year,
    SUM(ROUND(CAST(REPLACE(chained,',','') AS DECIMAL),2)) OVER(PARTITION BY state) as total_revenue_state,
    CASE
        WHEN year = '2,020' THEN 'Start of Covid'
        When year = '2,022' THEN  'Midsts of Covid'
        Else 'Post Covid'
    END AS covid_period
    FROM State_Level_Transportation_Finance.transportation_state_finanace
    Where cash_flow = 'Revenue' and mode = 'Air' and year in ('2,020', '2,022', '2,024')
)
SELECT DISTINCT *,
DENSE_RANK() OVER(ORDER BY total_revenue_state DESC) as ranked_total_revenue
FROM get_total_revenue
ORDER BY state
) TO 'total_revenue_covid_period.csv' (HEADER, DELIMITER ',');

/*Total Expenditure per capita by State in Covid Periods */
Copy(
WITH get_expenditure_per_capita AS (
    Select year, cash_flow, mode, state, state_code, 
    SUM(ROUND(CAST(chained_per_pop AS DECIMAL),2)) OVER(PARTITION BY state, year)as total_expenditure_year,
    SUM(ROUND(CAST(chained_per_pop AS DECIMAL),2)) OVER(PARTITION BY state)as total_expenditure_state,
    CASE
        WHEN year = '2,020' THEN 'Start of Covid'
        When year = '2,022' THEN  'Midsts of Covid'
        Else 'Post Covid'
    END AS covid_period
    from State_Level_Transportation_Finance.transportation_state_finanace
    Where cash_flow = 'Expenditure' and mode = 'Air' and year IN('2,020', '2,022','2,024')
    and gov_level = 'State and Local'
)
SELECT DISTINCT *,
DENSE_RANK() OVER(ORDER BY total_expenditure_state DESC) as ranked_expenditure_per_capita
FROM get_expenditure_per_capita
ORDER BY state
) TO 'per_capita_expenditure_covid_period.csv' (HEADER, DELIMITER ',');

/*Total Revenue per capita by State in Covid Periods */
COPY(
WITH get_revenue_per_capita AS (
    Select year, cash_flow, mode, state, state_code, 
    SUM(ROUND(CAST(chained_per_pop AS DECIMAL),2)) OVER(PARTITION BY state, year)as total_revenue_year,
    SUM(ROUND(CAST(chained_per_pop AS DECIMAL),2)) OVER(PARTITION BY state)as total_revenue_state,
    CASE
        WHEN year = '2,020' THEN 'Start of Covid'
        When year = '2,022' THEN  'Midsts of Covid'
        Else 'Post Covid'
    END AS covid_period
    from State_Level_Transportation_Finance.transportation_state_finanace
    Where cash_flow = 'Revenue' and mode = 'Air' and year IN('2,020', '2,022','2,024')
    and gov_level = 'State and Local'
)
SELECT DISTINCT *,
DENSE_RANK() OVER(ORDER BY total_revenue_state DESC) as ranked_revenue_per_capita
FROM get_revenue_per_capita
ORDER BY state
) TO 'per_capita_revenue_covid_period.csv' (HEADER, DELIMITER ',');
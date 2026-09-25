Select COUNT(*) FROM State_Level_Transportation_Finance.transportation_state_finanace;
SELECT mode, COUNT(*) 
FROM State_Level_Transportation_Finance.transportation_state_finanace
GROUP BY mode;

SELECT DISTINCT mode, year
FROM State_Level_Transportation_Finance.transportation_state_finanace
where mode = 'Air';

/*Get total expenditure by state 2024(post covid)*/
Select year, cash_flow, mode, state, state_code, 
SUM(chained_per_pop) as total_expenditure_per_state,
DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
from State_Level_Transportation_Finance.transportation_state_finanace
Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,024'
and gov_level = 'State and Local'
GROUP BY 1,2,3,4,5
ORDER BY total_spend_rank;

/*Get total expenditure by state 2020(Start covid)*/
Select year, cash_flow, mode, state, state_code, 
SUM(chained_per_pop) as total_expenditure_per_state,
DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
from State_Level_Transportation_Finance.transportation_state_finanace
Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,020'
and gov_level = 'State and Local'
GROUP BY 1,2,3,4,5
ORDER BY total_spend_rank;

/*Get total expenditure by state 2022(Prime covid)*/
Select year, cash_flow, mode, state, state_code, 
SUM(chained_per_pop) as total_expenditure_per_state,
DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
from State_Level_Transportation_Finance.transportation_state_finanace
Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,022'
and gov_level = 'State and Local'
GROUP BY 1,2,3,4,5
ORDER BY total_spend_rank;

-- Test

Select *
-- DENSE_RANK() OVER(ORDER BY SUM(chained_per_pop) DESC) as total_spend_rank
from State_Level_Transportation_Finance.transportation_state_finanace
Where cash_flow = 'Expenditure' and mode = 'Air' and year = '2,024'
and gov_level = 'State and Local';
-- GROUP BY 1,2,3,4,5;
-- ORDER BY total_spend_rank;
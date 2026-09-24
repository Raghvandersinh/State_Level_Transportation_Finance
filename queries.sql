Select COUNT(*) FROM State_Level_Transportation_Finance.transportation_state_finanace;
SELECT mode, COUNT(*) 
FROM State_Level_Transportation_Finance.transportation_state_finanace
GROUP BY mode;

SELECT DISTINCT mode, year
FROM State_Level_Transportation_Finance.transportation_state_finanace
where mode = 'Air'
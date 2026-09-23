Drop table if exists dwh.dim_date CASCADE;
Create table dwh.dim_date (
    date_key INTEGER generated always as identity primary key,
    full_date DATE NOT NULL,
    month INTEGER NOT NULL,
    day_of_week VARCHAR(100) NOT NULL
);


INSERT INTO dwh.dim_date (full_date, month, day_of_week)
SELECT DISTINCT TO_DATE(game_date, 'MM/DD/YYYY'), EXTRACT(MONTH FROM CAST(game_date AS DATE)) AS month, TO_CHAR(CAST(game_date AS DATE), 'FMDay') AS day_of_week
FROM staging.games
ORDER BY TO_DATE(game_date, 'MM/DD/YYYY');

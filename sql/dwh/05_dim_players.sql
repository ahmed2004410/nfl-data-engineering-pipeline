Drop table if exists dwh.dim_players CASCADE;
Create table dwh.dim_players (
    player_key INTEGER generated always as identity primary key,
    nfl_id INTEGER  NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    height INTEGER  NOT NULL,
    weight INTEGER NOT NULL,
    birth_date DATE NOT NULL,
    college_name VARCHAR(100) NOT NULL
);

INSERT INTO dwh.dim_players (nfl_id, display_name, position, height, weight, birth_date, college_name)
SELECT DISTINCT 
nfl_id, 
display_name, 
position, 
CASE
        WHEN height LIKE '%-%' THEN
            (split_part(height, '-', 1)::INTEGER * 12) + split_part(height, '-', 2)::INTEGER
        ELSE
            height::INTEGER
    END AS height, 
weight::INTEGER, 
birth_date::Date, 
college_name
FROM staging.players
ORDER BY nfl_id;


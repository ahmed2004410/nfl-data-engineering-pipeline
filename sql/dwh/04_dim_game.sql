Drop table if exists dwh.dim_games ;
Create table dwh.dim_games (
    game_key INTEGER generated always as identity primary key,
    game_id INTEGER NOT NULL,
    week INTEGER NOT NULL,
    home_team_key VARCHAR(100) NOT NULL,
    visitor_team_key VARCHAR(100) NOT NULL
);

INSERT INTO dwh.dim_games (game_id, week, home_team_key, visitor_team_key)
SELECT DISTINCT 
game_id, 
week, 
home_team_abbr  as home_team_key, 
visitor_team_abbr as visitor_team_key
FROM staging.games
ORDER BY game_id;
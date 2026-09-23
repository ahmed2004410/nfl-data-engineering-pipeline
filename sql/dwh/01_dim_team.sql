Drop table if exists dwh.dim_team CASCADE;
Create table dwh.dim_team (
    team_key INTEGER generated always as identity primary key,
    team_abbr VARCHAR(100) NOT NULL
);


INSERT INTO dwh.dim_team (team_abbr)
SELECT team_abbr
FROM (
    SELECT home_team_abbr AS team_abbr FROM staging.games
    UNION
    SELECT visitor_team_abbr FROM staging.games
    UNION
    SELECT possession_team FROM staging.plays WHERE possession_team IS NOT NULL
) AS all_teams
ORDER BY team_abbr;
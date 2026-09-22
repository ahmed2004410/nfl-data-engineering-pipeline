SELECT 'games' AS tbl, COUNT(*) FROM staging.games
UNION ALL
SELECT 'plays', COUNT(*) FROM staging.plays
UNION ALL
SELECT 'fact_plays', COUNT(*) FROM dwh.fact_plays;
----------------------------------------------------------------------
SELECT COUNT(*) FROM dwh.fact_plays WHERE game_key IS NULL OR date_key IS NULL;
----------------------------------------------------------------------
SELECT COUNT(*) FROM dwh.fact_plays WHERE formation_key IS NULL;
----------------------------------------------------------------------
SELECT COUNT(DISTINCT game_id) AS games,
       COUNT(DISTINCT (game_id, play_id)) AS plays
FROM dwh.fact_tracking;


git commit -m "quality checks"
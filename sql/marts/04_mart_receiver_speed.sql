DROP VIEW IF EXISTS marts.mart_receiver_speed;

create view marts.mart_receiver_speed as 
SELECT
    p.display_name,
    p.position,
    ft.route,
    ROUND(AVG(ft.s), 2) AS avg_speed,
    COUNT(DISTINCT (ft.game_id, ft.play_id)) AS times_run
FROM dwh.fact_tracking ft
JOIN dwh.dim_players p ON p.player_key = ft.player_key
WHERE ft.route IS NOT NULL
GROUP BY p.display_name, p.position, ft.route
ORDER BY times_run DESC, avg_speed DESC;
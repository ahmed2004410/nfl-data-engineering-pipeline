DROP VIEW IF EXISTS marts.mart_situational;

CREATE VIEW marts.mart_situational AS
SELECT
    down,
    CASE
        WHEN yards_to_go <= 3  THEN 'Short (1-3)'
        WHEN yards_to_go <= 7  THEN 'Medium (4-7)'
        WHEN yards_to_go <= 10 THEN 'Long (8-10)'
        ELSE 'Very Long (10+)'
    END AS distance_category,
    COUNT(*) AS play_count,
    ROUND(AVG(epa), 2) AS avg_epa,
    ROUND(
        (COUNT(*) FILTER (WHERE epa > 0))::numeric / COUNT(*) * 100
    , 2) AS success_rate_pct
FROM dwh.fact_plays
GROUP BY down, distance_category
ORDER BY down, distance_category;
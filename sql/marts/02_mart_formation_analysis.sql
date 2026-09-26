
DROP VIEW IF EXISTS marts.mart_formation_analysis;

CREATE VIEW marts.mart_formation_analysis AS
SELECT
    f.offense_formation,
    COUNT(*)                                    AS times_used,
    COUNT(*) FILTER (WHERE epa > 0)             AS times_successful,
    round(
        (COUNT(*) FILTER (WHERE epa > 0))::numeric / COUNT(*) 
    , 2) as success_rate,
    (SELECT COUNT(*) FROM dwh.fact_plays)       AS total_plays_all,
    round(
        COUNT(*)::numeric / (SELECT COUNT(*) FROM dwh.fact_plays) 
    , 2)  as usage_share,
    ROUND(AVG(p.epa)::numeric, 3)                                    AS avg_epa
FROM dwh.fact_plays p
join dwh.dim_formation f 
on f.formation_key = p.formation_key
GROUP BY offense_formation
ORDER BY times_used DESC;
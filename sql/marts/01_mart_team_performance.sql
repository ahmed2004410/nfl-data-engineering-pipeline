
DROP VIEW IF EXISTS marts.mart_team_performance;

CREATE VIEW marts.mart_team_performance AS
SELECT
    t.team_abbr,
    COUNT(*)                                                          AS total_plays,
    ROUND(AVG(fp.epa)::numeric, 3)                                    AS avg_epa,
    ROUND(AVG(fp.offense_play_result)::numeric, 2)                    AS avg_yards_per_play,
    COUNT(*) FILTER (WHERE fp.pass_result = 'C')                      AS completions,
    COUNT(*) FILTER (WHERE fp.pass_result IN ('C','I','IN'))          AS pass_attempts,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE fp.pass_result = 'C')
        / NULLIF(COUNT(*) FILTER (WHERE fp.pass_result IN ('C','I','IN')), 0)
    , 1)                                                               AS completion_pct
FROM dwh.fact_plays fp
JOIN dwh.dim_team t ON t.team_key = fp.offense_team_key
GROUP BY t.team_abbr
ORDER BY avg_epa DESC;

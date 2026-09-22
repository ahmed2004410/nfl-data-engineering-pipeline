
DROP TABLE IF EXISTS dwh.fact_plays;
CREATE TABLE dwh.fact_plays (
    game_id                   INTEGER NOT NULL,
    play_id                   INTEGER NOT NULL,
    game_key                  INTEGER REFERENCES dwh.dim_games(game_key),
    date_key                  INTEGER REFERENCES dwh.dim_date(date_key),
    offense_team_key          INTEGER REFERENCES dwh.dim_team(team_key),
    defense_team_key          INTEGER REFERENCES dwh.dim_team(team_key),
    formation_key             INTEGER REFERENCES dwh.dim_formation(formation_key),
    quarter                   INTEGER NOT NULL,
    down                      INTEGER NOT NULL,
    yards_to_go               INTEGER NOT NULL,
    play_type                 VARCHAR(100),
    pass_result               VARCHAR(100),
    absolute_yardline_number  INTEGER,
    defenders_in_the_box      INTEGER,
    number_of_pass_rushers    INTEGER,
    offense_play_result       INTEGER NOT NULL,
    epa                       NUMERIC,
    PRIMARY KEY (game_id, play_id)
);

INSERT INTO dwh.fact_plays (
   game_id, play_id, game_key, date_key, offense_team_key, defense_team_key,
   formation_key, quarter, down, yards_to_go, play_type, pass_result,
   absolute_yardline_number, defenders_in_the_box, number_of_pass_rushers,
   offense_play_result, epa)
SELECT
    p.game_id,
    p.play_id,
    g.game_key,
    d.date_key,
    ot.team_key AS offense_team_key,
    dt.team_key AS defense_team_key,
    COALESCE(
        f.formation_key,
        (SELECT formation_key FROM dwh.dim_formation WHERE offense_formation = 'UNKNOWN')
    ) AS formation_key,
    p.quarter,
    p.down,
    p.yards_to_go,
    p.play_type,
    p.passresult,
    p.absolute_yardline_number,
    p.defenders_in_the_box,
    p.number_of_pass_rushers,
    p.offenseplayresult as offense_play_result,
    p.epa
FROM staging.plays p
JOIN staging.games sg   ON sg.game_id = p.game_id
JOIN dwh.dim_games  g    ON g.game_id  = p.game_id
JOIN dwh.dim_date  d    ON d.full_date = CAST(sg.game_date AS DATE)
JOIN dwh.dim_team  ot   ON ot.team_abbr = p.possession_team
JOIN dwh.dim_team  dt   ON dt.team_abbr =
    CASE WHEN p.possession_team = sg.home_team_abbr THEN sg.visitor_team_abbr
         ELSE sg.home_team_abbr END
LEFT JOIN dwh.dim_formation f
    ON f.offense_formation = p.offense_formation
   AND f.rb_count = COALESCE(substring(p.personnel_o from '(\d+)\s*RB')::INTEGER, 0)
   AND f.te_count = COALESCE(substring(p.personnel_o from '(\d+)\s*TE')::INTEGER, 0)
   AND f.wr_count = COALESCE(substring(p.personnel_o from '(\d+)\s*WR')::INTEGER, 0)
   AND f.dl_count = COALESCE(substring(p.personnel_d from '(\d+)\s*DL')::INTEGER, 0)
   AND f.lb_count = COALESCE(substring(p.personnel_d from '(\d+)\s*LB')::INTEGER, 0)
   AND f.db_count = COALESCE(substring(p.personnel_d from '(\d+)\s*DB')::INTEGER, 0);
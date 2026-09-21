DROP TABLE IF EXISTS staging.games;
CREATE TABLE staging.games (
    game_id            INTEGER,
    game_date          TEXT,
    game_time_eastern  TEXT,
    home_team_abbr     TEXT,
    visitor_team_abbr  TEXT,
    week               INTEGER
);

DROP TABLE IF EXISTS staging.players;
CREATE TABLE staging.players (
    nfl_id          INTEGER,
    height        TEXT,
    weight        TEXT,
    birth_date     TEXT,
    college_name   TEXT,
    position      TEXT,
    display_name   TEXT
);

DROP TABLE IF EXISTS staging.plays;
CREATE TABLE staging.plays (
    game_id            INTEGER,
    play_id            INTEGER,
    play_description   TEXT,
    quarter            INTEGER,
    down               INTEGER,
    yards_to_go        INTEGER,
    possession_team    TEXT,
    play_type          TEXT,
    yardline_side      TEXT,
    yardline_number    INTEGER,
    offense_formation  TEXT,
    personnel_o        TEXT,
    defenders_in_the_box INTEGER,
    number_of_pass_rushers INTEGER,
    personnel_d        TEXT,
    type_dropback      TEXT,
    pre_snap_visitor_score INTEGER,
    pre_snap_home_score  INTEGER,
    game_clock         TEXT,
    absolute_yardline_number INTEGER,
    penalty_codes      TEXT,
    penalty_jersey_numbers TEXT,
    passResult        TEXT,
    offensePlayResult INTEGER,
    playResult        INTEGER,
    epa               REAL,
    isDefensivePI     BOOLEAN
);
 
DROP TABLE IF EXISTS staging.week_data;
CREATE TABLE staging.week_data (
    time            TEXT,
    x               NUMERIC,
    y               NUMERIC,
    s               NUMERIC,
    a               NUMERIC,
    dis             NUMERIC,
    o               NUMERIC,
    dir             NUMERIC,
    event           TEXT,
    nfl_id          INTEGER,
    display_name    TEXT,
    jersey_number   INTEGER,
    position        TEXT,
    frame_id        INTEGER,
    team            TEXT,
    game_id         INTEGER,
    play_id         INTEGER,
    play_direction  TEXT,
    route           TEXT
);
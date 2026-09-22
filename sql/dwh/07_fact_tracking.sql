Drop table if exists dwh.fact_tracking ;
Create table dwh.fact_tracking (
    tracking_key INTEGER generated always as identity primary key,
	game_id 	 INTEGER NOT null,
	game_key     INTEGER references dwh.dim_games(game_key),
    play_id      INTEGER NOT null,
    date_key     INTEGER references dwh.dim_date(date_key), 
    player_key   INTEGER references dwh.dim_players(player_key),
	frame_id     INTEGER NOT null,
    x numeric NOT NULL,
    y numeric NOT NULL,
    s numeric NOT NULL,
    a numeric NOT NULL,
    event     		VARCHAR(100) ,
    team_side 		VARCHAR(100) NOT NULL,
    route  		    VARCHAR(100) ,
	play_direction  VARCHAR(100) NOT NULL
);

INSERT INTO dwh.fact_tracking (
    game_id,
    play_id,
    game_key,
    date_key,
    player_key,
    frame_id,
    x,
    y,
    s,
    a,
    event,
    team_side,
    route,
    play_direction
	)

SELECT
    wd.game_id,
    wd.play_id,
    g.game_key,
    d.date_key,
    pl.player_key,
    wd.frame_id,
    wd.x,
    wd.y,
    wd.s,
    wd.a,
    NULLIF(wd.event, 'None')  AS event,
    wd.team                    AS team_side,
    wd.route,
    wd.play_direction
FROM staging.week_data wd
JOIN staging.games sg ON sg.game_id = wd.game_id
JOIN dwh.dim_games  g  ON g.game_id  = wd.game_id
JOIN dwh.dim_date  d  ON d.full_date = CAST(sg.game_date AS DATE)
LEFT JOIN dwh.dim_players pl ON pl.nfl_id = wd.nfl_id;


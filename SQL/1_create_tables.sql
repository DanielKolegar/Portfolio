-- ============================================
-- NHL Statistics Database
-- Script: 1_create_tables.sql
-- Description: Creates all tables in nhl schema
-- Schema: nhl | Database: nhl_db
-- ============================================


-- --------------------------------------------
-- Reference tables
-- --------------------------------------------

CREATE TABLE nhl.teams_reference (
    team         VARCHAR(50) NOT NULL,
    abbreviation VARCHAR(3)  NOT NULL PRIMARY KEY,
    conference   VARCHAR(10) NOT NULL,
    division     VARCHAR(20) NOT NULL
);

CREATE TABLE nhl.skaters_reference (
    player_id     SERIAL PRIMARY KEY,
    player_name   VARCHAR(100) NOT NULL,
    dob           DATE         NOT NULL,    -- date of birth
    birth_city    VARCHAR(100),
    birth_sp      CHAR(2),                  -- birth state (USA) or province (CAN)
    country       CHAR(3),
    nationality   CHAR(3),
    height        SMALLINT,                 -- in inches
    weight        SMALLINT,                 -- in pounds
    shoots        CHAR(1),                  -- L or R
    draft_year    SMALLINT,
    draft_round   SMALLINT,
    draft_overall SMALLINT,
    first_season  INTEGER,
    hof           BOOLEAN DEFAULT FALSE,    -- Hall of Fame
    CONSTRAINT uq_skater UNIQUE (player_name, dob) -- unique combination of name and date of birth to identify players
);

CREATE TABLE nhl.goalies_reference (
    player_id     SERIAL PRIMARY KEY,
    player_name   VARCHAR(100) NOT NULL,
    dob           DATE         NOT NULL,    -- date of birth
    birth_city    VARCHAR(100),
    birth_sp      CHAR(2),                  -- birth state (USA) or province (CAN)
    country       CHAR(3),
    nationality   CHAR(3),
    height        SMALLINT,                 -- in inches
    weight        SMALLINT,                 -- in pounds
    catches       CHAR(1),                  -- L or R
    draft_year    SMALLINT,
    draft_round   SMALLINT,
    draft_overall SMALLINT,
    first_season  INTEGER,
    hof           BOOLEAN DEFAULT FALSE,    -- Hall of Fame
    CONSTRAINT uq_goalie UNIQUE (player_name, dob) -- unique combination of name and date of birth to identify players
);


-- --------------------------------------------
-- Skater stats tables
-- --------------------------------------------

CREATE TABLE nhl.skaters_regular (
    id            SERIAL PRIMARY KEY,
    player_id     INTEGER     NOT NULL REFERENCES nhl.skaters_reference(player_id),
    season        INTEGER     NOT NULL,
    primary_team  VARCHAR(3)  NOT NULL REFERENCES nhl.teams_reference(abbreviation), -- last team of the season
    position      VARCHAR(2)  NOT NULL,   -- C, LW, RW, D
    gp            SMALLINT,               -- games played
    goals         SMALLINT,
    assists       SMALLINT,
    points        SMALLINT,
    plus_minus    SMALLINT,
    pim           SMALLINT,               -- penalty minutes
    p_per_gp      NUMERIC(4,2),           -- points per game
    evg           SMALLINT,               -- even strength goals
    evp           SMALLINT,               -- even strength points
    ppg           SMALLINT,               -- power play goals
    ppp           SMALLINT,               -- power play points
    shg           SMALLINT,               -- shorthanded goals
    shp           SMALLINT,               -- shorthanded points
    otg           SMALLINT,               -- overtime goals
    gwg           SMALLINT,               -- game winning goals
    shots         SMALLINT,
    shot_pct      NUMERIC(4,1),           -- shooting percentage
    toi_per_gp    VARCHAR(8),             -- time on ice per game (mm:ss)
    fow_pct       NUMERIC(4,1),           -- faceoff win percentage
    CONSTRAINT uq_skater_regular UNIQUE (player_id, season, primary_team)
);

CREATE TABLE nhl.skaters_playoffs (
    id            SERIAL PRIMARY KEY,
    player_id     INTEGER     NOT NULL REFERENCES nhl.skaters_reference(player_id),
    season        INTEGER     NOT NULL,
    team          VARCHAR(3)  NOT NULL REFERENCES nhl.teams_reference(abbreviation),
    position      VARCHAR(2)  NOT NULL,   -- C, LW, RW, D
    gp            SMALLINT,               -- games played
    goals         SMALLINT,
    assists       SMALLINT,
    points        SMALLINT,
    plus_minus    SMALLINT,
    pim           SMALLINT,               -- penalty minutes
    p_per_gp      NUMERIC(4,2),           -- points per game
    evg           SMALLINT,               -- even strength goals
    evp           SMALLINT,               -- even strength points
    ppg           SMALLINT,               -- power play goals
    ppp           SMALLINT,               -- power play points
    shg           SMALLINT,               -- shorthanded goals
    shp           SMALLINT,               -- shorthanded points
    otg           SMALLINT,               -- overtime goals
    gwg           SMALLINT,               -- game winning goals
    shots         SMALLINT,
    shot_pct      NUMERIC(4,1),           -- shooting percentage
    toi_per_gp    VARCHAR(8),             -- time on ice per game (mm:ss)
    fow_pct       NUMERIC(4,1),           -- faceoff win percentage
    CONSTRAINT uq_skater_playoffs UNIQUE (player_id, season, team)
);


-- --------------------------------------------
-- Goalie stats tables
-- --------------------------------------------

CREATE TABLE nhl.goalies_regular (
    id            SERIAL PRIMARY KEY,
    player_id     INTEGER     NOT NULL REFERENCES nhl.goalies_reference(player_id),
    season        INTEGER     NOT NULL,
    primary_team  VARCHAR(3)  NOT NULL REFERENCES nhl.teams_reference(abbreviation), -- last team of the season
    gp            SMALLINT,               -- games played
    gs            SMALLINT,               -- games started
    wins          SMALLINT,
    losses        SMALLINT,
    ot            SMALLINT,               -- overtime losses
    sa            INTEGER,                -- shots against
    svs           INTEGER,                -- saves
    ga            SMALLINT,               -- goals against
    sv_pct        NUMERIC(5,3),           -- save percentage (e.g. 0.921)
    gaa           NUMERIC(4,2),           -- goals against average
    toi           VARCHAR(10),            -- total time on ice (mm:ss)
    shutouts      SMALLINT,
    goals         SMALLINT,
    assists       SMALLINT,
    points        SMALLINT,
    pim           SMALLINT,               -- penalty minutes
    CONSTRAINT uq_goalie_regular UNIQUE (player_id, season, primary_team)
);

CREATE TABLE nhl.goalies_playoffs (
    id            SERIAL PRIMARY KEY,
    player_id     INTEGER     NOT NULL REFERENCES nhl.goalies_reference(player_id),
    season        INTEGER     NOT NULL,
    team          VARCHAR(3)  NOT NULL REFERENCES nhl.teams_reference(abbreviation),
    gp            SMALLINT,               -- games played
    gs            SMALLINT,               -- games started
    wins          SMALLINT,
    losses        SMALLINT,
    sa            INTEGER,                -- shots against
    svs           INTEGER,                -- saves
    ga            SMALLINT,               -- goals against
    sv_pct        NUMERIC(5,3),           -- save percentage (e.g. 0.921)
    gaa           NUMERIC(4,2),           -- goals against average
    toi           VARCHAR(10),            -- total time on ice (mm:ss)
    shutouts      SMALLINT,
    goals         SMALLINT,
    assists       SMALLINT,
    points        SMALLINT,
    pim           SMALLINT,               -- penalty minutes
    CONSTRAINT uq_goalie_playoffs UNIQUE (player_id, season, team)
);


-- --------------------------------------------
-- Team stats tables
-- --------------------------------------------

CREATE TABLE nhl.teams_regular (
    id            SERIAL PRIMARY KEY,
    team          VARCHAR(3)   NOT NULL REFERENCES nhl.teams_reference(abbreviation),
    season        INTEGER      NOT NULL,
    gp            SMALLINT,               -- games played
    wins          SMALLINT,
    losses        SMALLINT,
    ot            SMALLINT,               -- overtime losses
    points        SMALLINT,
    point_pct     NUMERIC(4,3),           -- points percentage
    rw            SMALLINT,               -- regulation wins
    row           SMALLINT,               -- regulation + overtime wins
    so_wins       SMALLINT,               -- shootout wins
    gf            SMALLINT,               -- goals for
    ga            SMALLINT,               -- goals against
    gf_per_gp     NUMERIC(4,2),           -- goals for per game
    ga_per_gp     NUMERIC(4,2),           -- goals against per game
    pp_pct        NUMERIC(4,1),           -- power play percentage
    pk_pct        NUMERIC(4,1),           -- penalty kill percentage
    net_pp_pct    NUMERIC(4,1),           -- power play net percentage
    net_pk_pct    NUMERIC(4,1),           -- penalty kill net percentage
    shots_per_gp  NUMERIC(4,1),           -- shots per game
    sa_per_gp     NUMERIC(4,1),           -- shots against per game
    fow_pct       NUMERIC(4,1),           -- faceoff win percentage
    CONSTRAINT uq_team_regular UNIQUE (team, season)
);

CREATE TABLE nhl.teams_playoffs (
    id            SERIAL PRIMARY KEY,
    team          VARCHAR(3)   NOT NULL REFERENCES nhl.teams_reference(abbreviation),
    season        INTEGER      NOT NULL,
    gp            SMALLINT,               -- games played
    wins          SMALLINT,
    losses        SMALLINT,
    points        SMALLINT,
    point_pct     NUMERIC(4,3),           -- points percentage
    rw            SMALLINT,               -- regulation wins
    row           SMALLINT,               -- regulation + overtime wins
    so_wins       SMALLINT,               -- shootout wins
    gf            SMALLINT,               -- goals for
    ga            SMALLINT,               -- goals against
    gf_per_gp     NUMERIC(4,2),           -- goals for per game
    ga_per_gp     NUMERIC(4,2),           -- goals against per game
    pp_pct        NUMERIC(4,1),           -- power play percentage
    pk_pct        NUMERIC(4,1),           -- penalty kill percentage
    net_pp_pct    NUMERIC(4,1),           -- power play net percentage
    net_pk_pct    NUMERIC(4,1),           -- penalty kill net percentage
    shots_per_gp  NUMERIC(4,1),           -- shots per game
    sa_per_gp     NUMERIC(4,1),           -- shots against per game
    fow_pct       NUMERIC(4,1),           -- faceoff win percentage
    CONSTRAINT uq_team_playoffs UNIQUE (team, season)
);
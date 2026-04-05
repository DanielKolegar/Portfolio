-- ============================================
-- NHL Statistics Database
-- Script: 2_import_data.sql
-- Description: Imports data from CSV files into nhl schema
-- Schema: nhl | Database: nhl_db
-- Note: CSV files must be stored in C:/csv/ before running
-- Note: Run this script in a single session without disconnecting
-- ============================================


-- --------------------------------------------
-- Teams reference: CSV import
-- --------------------------------------------

COPY nhl.teams_reference
FROM 'C:\csv\teams_reference.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);


-- --------------------------------------------
-- Skaters: temporary table and CSV import
-- --------------------------------------------

CREATE TEMPORARY TABLE temp_skaters (
    player        VARCHAR(100),
    season        INTEGER,
    team          VARCHAR(20),    -- may contain multiple teams, e.g. "SEA,WPG"
    shoots        CHAR(1),        -- S/C column
    position      VARCHAR(2),
    gp            SMALLINT,       -- games played
    goals         SMALLINT,
    assists       SMALLINT,
    points        SMALLINT,
    plus_minus    SMALLINT,
    pim           SMALLINT,       -- penalty minutes
    p_per_gp      NUMERIC(4,2),   -- points per game
    evg           SMALLINT,       -- even strength goals
    evp           SMALLINT,       -- even strength points
    ppg           SMALLINT,       -- power play goals
    ppp           SMALLINT,       -- power play points
    shg           SMALLINT,       -- shorthanded goals
    shp           SMALLINT,       -- shorthanded points
    otg           SMALLINT,       -- overtime goals
    gwg           SMALLINT,       -- game winning goals
    shots         SMALLINT,
    shot_pct      VARCHAR(10),    -- VARCHAR due to possible empty values
    toi_per_gp    VARCHAR(8),     -- time on ice per game (mm:ss)
    fow_pct       VARCHAR(10),    -- VARCHAR due to possible empty values
    dob           DATE,           -- date of birth
    birth_city    VARCHAR(100),
    birth_sp      CHAR(2),        -- birth state (USA) or province (CAN)
    country       CHAR(3),
    nationality   CHAR(3),
    height        SMALLINT,       -- in inches
    weight        SMALLINT,       -- in pounds
    draft_year    VARCHAR(10),    -- VARCHAR due to possible empty values
    draft_round   VARCHAR(10),    -- VARCHAR due to possible empty values
    draft_overall VARCHAR(10),    -- VARCHAR due to possible empty values
    first_season  INTEGER,
    hof           VARCHAR(1),     -- Y or N
    game_type     VARCHAR(20)
);

COPY temp_skaters FROM 'C:\csv\2021_2022_regular_skaters.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_skaters FROM 'C:\csv\2021_2022_playoffs_skaters.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_skaters FROM 'C:\csv\2022_2023_regular_skaters.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_skaters FROM 'C:\csv\2022_2023_playoffs_skaters.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_skaters FROM 'C:\csv\2023_2024_regular_skaters.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_skaters FROM 'C:\csv\2023_2024_playoffs_skaters.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_skaters FROM 'C:\csv\2024_2025_regular_skaters.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_skaters FROM 'C:\csv\2024_2025_playoffs_skaters.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');


-- --------------------------------------------
-- Skaters: insert unique players into skaters_reference
-- DISTINCT ON ensures one row per player (most recent season takes priority)
-- --------------------------------------------

INSERT INTO nhl.skaters_reference (
    player_name, dob, birth_city, birth_sp,
    country, nationality, height, weight,
    shoots, draft_year, draft_round, draft_overall,
    first_season, hof
)
SELECT DISTINCT ON (player, dob)
    player,
    dob,
    birth_city,
    birth_sp,
    country,
    nationality,
    height,
    weight,
    shoots,
    NULLIF(NULLIF(draft_year, ''), '--')::SMALLINT,
    NULLIF(NULLIF(draft_round, ''), '--')::SMALLINT,
    NULLIF(NULLIF(draft_overall, ''), '--')::SMALLINT,
    first_season,
    CASE WHEN hof = 'Y' THEN TRUE ELSE FALSE END
FROM temp_skaters
ORDER BY player, dob, season DESC;


-- --------------------------------------------
-- Goalies: temporary tables and CSV import
-- Regular season and playoffs have different column structure (OT column)
-- so two separate temp tables are needed
-- --------------------------------------------

CREATE TEMPORARY TABLE temp_goalies (
    player        VARCHAR(100),
    season        INTEGER,
    team          VARCHAR(20),    -- may contain multiple teams
    catches       CHAR(1),        -- S/C column
    gp            SMALLINT,       -- games played
    gs            SMALLINT,       -- games started
    wins          SMALLINT,
    losses        SMALLINT,
    t             VARCHAR(5),     -- ties (always empty in modern NHL)
    ot            VARCHAR(10),    -- overtime losses, VARCHAR due to possible empty values
    sa            VARCHAR(10),    -- shots against, VARCHAR due to possible empty values
    svs           VARCHAR(10),    -- saves, VARCHAR due to possible empty values
    ga            SMALLINT,       -- goals against
    sv_pct        VARCHAR(10),    -- VARCHAR due to possible empty values
    gaa           NUMERIC(4,2),   -- goals against average
    toi           VARCHAR(10),    -- total time on ice (mm:ss)
    shutouts      SMALLINT,
    goals         SMALLINT,
    assists       SMALLINT,
    points        SMALLINT,
    pim           SMALLINT,       -- penalty minutes
    dob           DATE,           -- date of birth
    birth_city    VARCHAR(100),
    birth_sp      CHAR(2),        -- birth state (USA) or province (CAN)
    country       CHAR(3),
    nationality   CHAR(3),
    height        SMALLINT,       -- in inches
    weight        SMALLINT,       -- in pounds
    draft_year    VARCHAR(10),    -- VARCHAR due to possible empty values
    draft_round   VARCHAR(10),    -- VARCHAR due to possible empty values
    draft_overall VARCHAR(10),    -- VARCHAR due to possible empty values
    first_season  INTEGER,
    hof           VARCHAR(1),     -- Y or N
    game_type     VARCHAR(20)
);

COPY temp_goalies FROM 'C:\csv\2021_2022_regular_goalies.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_goalies FROM 'C:\csv\2022_2023_regular_goalies.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_goalies FROM 'C:\csv\2023_2024_regular_goalies.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_goalies FROM 'C:\csv\2024_2025_regular_goalies.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- playoffs goalies CSV does not have OT column
CREATE TEMPORARY TABLE temp_goalies_playoffs (
    player        VARCHAR(100),
    season        INTEGER,
    team          VARCHAR(20),
    catches       CHAR(1),
    gp            SMALLINT,
    gs            SMALLINT,
    wins          SMALLINT,
    losses        SMALLINT,
    t             VARCHAR(5),     -- ties (always empty in modern NHL)
    sa            VARCHAR(10),    -- VARCHAR due to possible empty values
    svs           VARCHAR(10),    -- VARCHAR due to possible empty values
    ga            SMALLINT,
    sv_pct        VARCHAR(10),    -- VARCHAR due to possible empty values
    gaa           NUMERIC(4,2),
    toi           VARCHAR(10),
    shutouts      SMALLINT,
    goals         SMALLINT,
    assists       SMALLINT,
    points        SMALLINT,
    pim           SMALLINT,
    dob           DATE,
    birth_city    VARCHAR(100),
    birth_sp      CHAR(2),
    country       CHAR(3),
    nationality   CHAR(3),
    height        SMALLINT,
    weight        SMALLINT,
    draft_year    VARCHAR(10),
    draft_round   VARCHAR(10),
    draft_overall VARCHAR(10),
    first_season  INTEGER,
    hof           VARCHAR(1),
    game_type     VARCHAR(20)
);

COPY temp_goalies_playoffs FROM 'C:\csv\2021_2022_playoffs_goalies.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_goalies_playoffs FROM 'C:\csv\2022_2023_playoffs_goalies.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_goalies_playoffs FROM 'C:\csv\2023_2024_playoffs_goalies.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_goalies_playoffs FROM 'C:\csv\2024_2025_playoffs_goalies.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- merge playoffs data into temp_goalies
INSERT INTO temp_goalies (
    player, season, team, catches, gp, gs, wins, losses,
    sa, svs, ga, sv_pct, gaa, toi, shutouts,
    goals, assists, points, pim, dob, birth_city, birth_sp,
    country, nationality, height, weight,
    draft_year, draft_round, draft_overall, first_season, hof, game_type
)
SELECT
    player, season, team, catches, gp, gs, wins, losses,
    sa, svs, ga, sv_pct, gaa, toi, shutouts,
    goals, assists, points, pim, dob, birth_city, birth_sp,
    country, nationality, height, weight,
    draft_year, draft_round, draft_overall, first_season, hof, game_type
FROM temp_goalies_playoffs;


-- --------------------------------------------
-- Goalies: insert unique players into goalies_reference
-- --------------------------------------------

INSERT INTO nhl.goalies_reference (
    player_name, dob, birth_city, birth_sp,
    country, nationality, height, weight,
    catches, draft_year, draft_round, draft_overall,
    first_season, hof
)
SELECT DISTINCT ON (player, dob)
    player,
    dob,
    birth_city,
    birth_sp,
    country,
    nationality,
    height,
    weight,
    catches,
    NULLIF(NULLIF(draft_year, ''), '--')::SMALLINT,
    NULLIF(NULLIF(draft_round, ''), '--')::SMALLINT,
    NULLIF(NULLIF(draft_overall, ''), '--')::SMALLINT,
    first_season,
    CASE WHEN hof = 'Y' THEN TRUE ELSE FALSE END
FROM temp_goalies
ORDER BY player, dob, season DESC;


-- --------------------------------------------
-- Skaters: insert stats into skaters_regular and skaters_playoffs
-- SPLIT_PART extracts last team from e.g. "SEA,WPG" → "WPG"
-- --------------------------------------------

INSERT INTO nhl.skaters_regular (
    player_id, season, primary_team, position,
    gp, goals, assists, points, plus_minus, pim, p_per_gp,
    evg, evp, ppg, ppp, shg, shp, otg, gwg,
    shots, shot_pct, toi_per_gp, fow_pct
)
SELECT
    sr.player_id,
    ts.season,
    SPLIT_PART(ts.team, ',', -1) AS primary_team,
    ts.position,
    ts.gp,
    ts.goals,
    ts.assists,
    ts.points,
    ts.plus_minus,
    ts.pim,
    ts.p_per_gp,
    ts.evg,
    ts.evp,
    ts.ppg,
    ts.ppp,
    ts.shg,
    ts.shp,
    ts.otg,
    ts.gwg,
    ts.shots,
    NULLIF(NULLIF(ts.shot_pct, ''), '--')::NUMERIC(4,1),
    ts.toi_per_gp,
    NULLIF(NULLIF(ts.fow_pct, ''), '--')::NUMERIC(4,1)
FROM temp_skaters ts
JOIN nhl.skaters_reference sr
    ON ts.player = sr.player_name
    AND ts.dob = sr.dob
WHERE ts.game_type = 'Regular Season';

INSERT INTO nhl.skaters_playoffs (
    player_id, season, team, position,
    gp, goals, assists, points, plus_minus, pim, p_per_gp,
    evg, evp, ppg, ppp, shg, shp, otg, gwg,
    shots, shot_pct, toi_per_gp, fow_pct
)
SELECT
    sr.player_id,
    ts.season,
    ts.team,
    ts.position,
    ts.gp,
    ts.goals,
    ts.assists,
    ts.points,
    ts.plus_minus,
    ts.pim,
    ts.p_per_gp,
    ts.evg,
    ts.evp,
    ts.ppg,
    ts.ppp,
    ts.shg,
    ts.shp,
    ts.otg,
    ts.gwg,
    ts.shots,
    NULLIF(NULLIF(ts.shot_pct, ''), '--')::NUMERIC(4,1),
    ts.toi_per_gp,
    NULLIF(NULLIF(ts.fow_pct, ''), '--')::NUMERIC(4,1)
FROM temp_skaters ts
JOIN nhl.skaters_reference sr
    ON ts.player = sr.player_name
    AND ts.dob = sr.dob
WHERE ts.game_type = 'Playoffs';


-- --------------------------------------------
-- Goalies: insert stats into goalies_regular and goalies_playoffs
-- REGEXP_REPLACE removes non-breaking spaces from sa and svs columns
-- --------------------------------------------

INSERT INTO nhl.goalies_regular (
    player_id, season, primary_team,
    gp, gs, wins, losses, ot,
    sa, svs, ga, sv_pct, gaa, toi, shutouts,
    goals, assists, points, pim
)
SELECT
    gr.player_id,
    tg.season,
    SPLIT_PART(tg.team, ',', -1) AS primary_team,
    tg.gp,
    tg.gs,
    tg.wins,
    tg.losses,
    NULLIF(NULLIF(tg.ot, ''), '--')::SMALLINT,
    NULLIF(NULLIF(REGEXP_REPLACE(tg.sa, '\s', '', 'g'), ''), '--')::INTEGER,
    NULLIF(NULLIF(REGEXP_REPLACE(tg.svs, '\s', '', 'g'), ''), '--')::INTEGER,
    tg.ga,
    NULLIF(NULLIF(tg.sv_pct, ''), '--')::NUMERIC(5,3),
    tg.gaa,
    tg.toi,
    tg.shutouts,
    tg.goals,
    tg.assists,
    tg.points,
    tg.pim
FROM temp_goalies tg
JOIN nhl.goalies_reference gr
    ON tg.player = gr.player_name
    AND tg.dob = gr.dob
WHERE tg.game_type = 'Regular Season';

INSERT INTO nhl.goalies_playoffs (
    player_id, season, team,
    gp, gs, wins, losses,
    sa, svs, ga, sv_pct, gaa, toi, shutouts,
    goals, assists, points, pim
)
SELECT
    gr.player_id,
    tg.season,
    tg.team,
    tg.gp,
    tg.gs,
    tg.wins,
    tg.losses,
    NULLIF(NULLIF(REGEXP_REPLACE(tg.sa, '\s', '', 'g'), ''), '--')::INTEGER,
    NULLIF(NULLIF(REGEXP_REPLACE(tg.svs, '\s', '', 'g'), ''), '--')::INTEGER,
    tg.ga,
    NULLIF(NULLIF(tg.sv_pct, ''), '--')::NUMERIC(5,3),
    tg.gaa,
    tg.toi,
    tg.shutouts,
    tg.goals,
    tg.assists,
    tg.points,
    tg.pim
FROM temp_goalies_playoffs tg
JOIN nhl.goalies_reference gr
    ON tg.player = gr.player_name
    AND tg.dob = gr.dob
WHERE tg.game_type = 'Playoffs';


-- --------------------------------------------
-- Teams: temporary tables and CSV import
-- Playoffs CSV contains "--" values so numeric columns use VARCHAR
-- --------------------------------------------

CREATE TEMPORARY TABLE temp_teams_regular (
    team          VARCHAR(50),    -- full team name, e.g. "Anaheim Ducks"
    season        INTEGER,
    gp            SMALLINT,
    wins          SMALLINT,
    losses        SMALLINT,
    t             VARCHAR(5),     -- ties (always empty in modern NHL)
    ot            SMALLINT,       -- overtime losses
    points        SMALLINT,
    point_pct     NUMERIC(4,3),   -- points percentage
    rw            SMALLINT,       -- regulation wins
    row           SMALLINT,       -- regulation + overtime wins
    so_wins       SMALLINT,       -- shootout wins
    gf            SMALLINT,       -- goals for
    ga            SMALLINT,       -- goals against
    gf_per_gp     NUMERIC(4,2),
    ga_per_gp     NUMERIC(4,2),
    pp_pct        NUMERIC(4,1),   -- power play percentage
    pk_pct        NUMERIC(4,1),   -- penalty kill percentage
    net_pp_pct    NUMERIC(4,1),   -- power play net percentage
    net_pk_pct    NUMERIC(4,1),   -- penalty kill net percentage
    shots_per_gp  NUMERIC(4,1),
    sa_per_gp     NUMERIC(4,1),
    fow_pct       NUMERIC(4,1),   -- faceoff win percentage
    game_type     VARCHAR(20)
);

COPY temp_teams_regular FROM 'C:\csv\2021_2022_regular_teams.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_teams_regular FROM 'C:\csv\2022_2023_regular_teams.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_teams_regular FROM 'C:\csv\2023_2024_regular_teams.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_teams_regular FROM 'C:\csv\2024_2025_regular_teams.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

CREATE TEMPORARY TABLE temp_teams_playoffs (
    team          VARCHAR(50),    -- full team name, e.g. "Anaheim Ducks"
    season        INTEGER,
    gp            SMALLINT,
    wins          SMALLINT,
    losses        SMALLINT,
    t             VARCHAR(5),     -- ties (always empty in modern NHL)
    points        SMALLINT,
    point_pct     VARCHAR(10),    -- VARCHAR due to possible "--" values
    rw            SMALLINT,       -- regulation wins
    row           SMALLINT,       -- regulation + overtime wins
    so_wins       SMALLINT,       -- shootout wins
    gf            SMALLINT,       -- goals for
    ga            SMALLINT,       -- goals against
    gf_per_gp     VARCHAR(10),    -- VARCHAR due to possible "--" values
    ga_per_gp     VARCHAR(10),    -- VARCHAR due to possible "--" values
    pp_pct        VARCHAR(10),    -- VARCHAR due to possible "--" values
    pk_pct        VARCHAR(10),    -- VARCHAR due to possible "--" values
    net_pp_pct    VARCHAR(10),    -- VARCHAR due to possible "--" values
    net_pk_pct    VARCHAR(10),    -- VARCHAR due to possible "--" values
    shots_per_gp  VARCHAR(10),    -- VARCHAR due to possible "--" values
    sa_per_gp     VARCHAR(10),    -- VARCHAR due to possible "--" values
    fow_pct       VARCHAR(10),    -- VARCHAR due to possible "--" values
    game_type     VARCHAR(20)
);

COPY temp_teams_playoffs FROM 'C:\csv\2021_2022_playoffs_teams.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_teams_playoffs FROM 'C:\csv\2022_2023_playoffs_teams.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_teams_playoffs FROM 'C:\csv\2023_2024_playoffs_teams.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY temp_teams_playoffs FROM 'C:\csv\2024_2025_playoffs_teams.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');


-- --------------------------------------------
-- Teams: insert stats into teams_regular and teams_playoffs
-- JOIN with teams_reference converts full team name to abbreviation
-- --------------------------------------------

INSERT INTO nhl.teams_regular (
    team, season, gp, wins, losses, ot, points, point_pct,
    rw, row, so_wins, gf, ga, gf_per_gp, ga_per_gp,
    pp_pct, pk_pct, net_pp_pct, net_pk_pct,
    shots_per_gp, sa_per_gp, fow_pct
)
SELECT
    tr.abbreviation,
    tt.season,
    tt.gp,
    tt.wins,
    tt.losses,
    tt.ot,
    tt.points,
    tt.point_pct,
    tt.rw,
    tt.row,
    tt.so_wins,
    tt.gf,
    tt.ga,
    tt.gf_per_gp,
    tt.ga_per_gp,
    tt.pp_pct,
    tt.pk_pct,
    tt.net_pp_pct,
    tt.net_pk_pct,
    tt.shots_per_gp,
    tt.sa_per_gp,
    tt.fow_pct
FROM temp_teams_regular tt
JOIN nhl.teams_reference tr ON tt.team = tr.team;

INSERT INTO nhl.teams_playoffs (
    team, season, gp, wins, losses, points, point_pct,
    rw, row, so_wins, gf, ga, gf_per_gp, ga_per_gp,
    pp_pct, pk_pct, net_pp_pct, net_pk_pct,
    shots_per_gp, sa_per_gp, fow_pct
)
SELECT
    tr.abbreviation,
    tt.season,
    tt.gp,
    tt.wins,
    tt.losses,
    tt.points,
    NULLIF(NULLIF(tt.point_pct, ''), '--')::NUMERIC(4,3),
    tt.rw,
    tt.row,
    tt.so_wins,
    tt.gf,
    tt.ga,
    NULLIF(NULLIF(tt.gf_per_gp, ''), '--')::NUMERIC(4,2),
    NULLIF(NULLIF(tt.ga_per_gp, ''), '--')::NUMERIC(4,2),
    NULLIF(NULLIF(tt.pp_pct, ''), '--')::NUMERIC(4,1),
    NULLIF(NULLIF(tt.pk_pct, ''), '--')::NUMERIC(4,1),
    NULLIF(NULLIF(tt.net_pp_pct, ''), '--')::NUMERIC(4,1),
    NULLIF(NULLIF(tt.net_pk_pct, ''), '--')::NUMERIC(4,1),
    NULLIF(NULLIF(tt.shots_per_gp, ''), '--')::NUMERIC(4,1),
    NULLIF(NULLIF(tt.sa_per_gp, ''), '--')::NUMERIC(4,1),
    NULLIF(NULLIF(tt.fow_pct, ''), '--')::NUMERIC(4,1)
FROM temp_teams_playoffs tt
JOIN nhl.teams_reference tr ON tt.team = tr.team;
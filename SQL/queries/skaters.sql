-- ============================================
-- NHL Statistics Database
-- Script: skaters.sql
-- Description: Skater statistics queries
--              - Top skaters by goals / assists / points
--              - Top skaters by plus_minus / pim / ppg / shg / gwg / shots
--              Regular season and playoffs
-- Schema: nhl | Database: nhl_db
-- ============================================


-- Top skaters by goals / assists / points (regular season)
-- Uncomment ORDER BY to switch between metrics
-- Remove comments from WHERE filters to narrow results
SELECT
    sr.player_name,
    sk.position,
    SUM(sk.gp)      AS games_played,
    SUM(sk.goals)   AS goals,
    SUM(sk.assists) AS assists,
    SUM(sk.points)  AS points
FROM nhl.skaters_regular sk
JOIN nhl.skaters_reference sr ON sk.player_id = sr.player_id
WHERE 1=1
    -- AND sk.season       = 20212022  -- filter by season
    -- AND sk.primary_team = 'EDM'     -- filter by team
    -- AND sk.position     = 'C'       -- filter by position: C, LW, RW, D
    -- AND sr.shoots       = 'L'       -- filter by shoots: L or R
GROUP BY sr.player_name, sk.position
ORDER BY points DESC      -- switch to goals or assists if needed
LIMIT 20;

-- Top skaters by goals / assists / points (playoffs)
-- Uncomment ORDER BY to switch between metrics
-- Remove comments from WHERE filters to narrow results
SELECT
    sr.player_name,
    sk.position,
    SUM(sk.gp)      AS games_played,
    SUM(sk.goals)   AS goals,
    SUM(sk.assists) AS assists,
    SUM(sk.points)  AS points
FROM nhl.skaters_playoffs sk
JOIN nhl.skaters_reference sr ON sk.player_id = sr.player_id
WHERE 1=1
    -- AND sk.season   = 20212022  -- filter by season
    -- AND sk.team     = 'EDM'     -- filter by team
    -- AND sk.position = 'C'       -- filter by position: C, LW, RW, D
    -- AND sr.shoots   = 'L'       -- filter by shoots: L or R
GROUP BY sr.player_name, sk.position
ORDER BY points DESC      -- switch to goals or assists if needed
LIMIT 20;

-- Top skaters by plus_minus / pim / ppg / shg / gwg / shots (regular season)
-- Uncomment ORDER BY to switch between metrics
-- Remove comments from WHERE filters to narrow results
SELECT
    sr.player_name,
    sk.position,
    SUM(sk.gp)          AS games_played,
    SUM(sk.plus_minus)  AS plus_minus,
    SUM(sk.pim)         AS penalty_minutes,
    SUM(sk.ppg)         AS power_play_goals,
    SUM(sk.shg)         AS shorthanded_goals,
    SUM(sk.gwg)         AS game_winning_goals,
    SUM(sk.shots)       AS shots
FROM nhl.skaters_regular sk
JOIN nhl.skaters_reference sr ON sk.player_id = sr.player_id
WHERE 1=1
    -- AND sk.season       = 20212022  -- filter by season
    -- AND sk.primary_team = 'EDM'     -- filter by team
    -- AND sk.position     = 'C'       -- filter by position: C, LW, RW, D
    -- AND sr.shoots       = 'L'       -- filter by shoots: L or R
GROUP BY sr.player_name, sk.position
ORDER BY plus_minus DESC  -- switch to penalty_minutes, power_play_goals,
                          -- shorthanded_goals, game_winning_goals or shots if needed
LIMIT 20;

-- Top skaters by plus_minus / pim / ppg / shg / gwg / shots (playoffs)
-- Uncomment ORDER BY to switch between metrics
-- Remove comments from WHERE filters to narrow results
SELECT
    sr.player_name,
    sk.position,
    SUM(sk.gp)          AS games_played,
    SUM(sk.plus_minus)  AS plus_minus,
    SUM(sk.pim)         AS penalty_minutes,
    SUM(sk.ppg)         AS power_play_goals,
    SUM(sk.shg)         AS shorthanded_goals,
    SUM(sk.gwg)         AS game_winning_goals,
    SUM(sk.shots)       AS shots
FROM nhl.skaters_playoffs sk
JOIN nhl.skaters_reference sr ON sk.player_id = sr.player_id
WHERE 1=1
    -- AND sk.season   = 20212022  -- filter by season
    -- AND sk.team     = 'EDM'     -- filter by team
    -- AND sk.position = 'C'       -- filter by position: C, LW, RW, D
    -- AND sr.shoots   = 'L'       -- filter by shoots: L or R
GROUP BY sr.player_name, sk.position
ORDER BY plus_minus DESC  -- switch to penalty_minutes, power_play_goals,
                          -- shorthanded_goals, game_winning_goals or shots if needed
LIMIT 20;

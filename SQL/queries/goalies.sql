-- ============================================
-- NHL Statistics Database
-- Script: goalies.sql
-- Description: Goalie statistics queries
--              - Save percentage vs goals against average
--              - Wins vs shutouts
--              Regular season (min. 25 games) and playoffs (min. 4 games)
-- Schema: nhl | Database: nhl_db
-- ============================================


-- Goalies: save percentage vs goals against average (regular season)
-- Minimum 25 games played to filter out backups with small sample size
-- Remove comments from WHERE filters to narrow results
SELECT
    gr.player_name,
    SUM(g.gp)               AS games_played,
    SUM(g.wins)             AS wins,
    SUM(g.losses)           AS losses,
    ROUND(AVG(g.sv_pct), 3) AS save_percentage,
    ROUND(AVG(g.gaa), 3)    AS goals_against_average,
    SUM(g.shutouts)         AS shutouts
FROM nhl.goalies_regular g
JOIN nhl.goalies_reference gr ON g.player_id = gr.player_id
WHERE 1=1
    -- AND g.season        = 20212022  -- filter by season
    -- AND g.primary_team  = 'EDM'     -- filter by team
    -- AND gr.catches      = 'L'       -- filter by catches: L or R
GROUP BY gr.player_name
HAVING SUM(g.gp) >= 25              -- minimum 25 games played
ORDER BY save_percentage DESC
LIMIT 20;

-- Goalies: save percentage vs goals against average (playoffs)
-- Remove comments from WHERE filters to narrow results
SELECT
    gr.player_name,
    SUM(g.gp)               AS games_played,
    SUM(g.wins)             AS wins,
    SUM(g.losses)           AS losses,
    ROUND(AVG(g.sv_pct), 3) AS save_percentage,
    ROUND(AVG(g.gaa), 3)    AS goals_against_average,
    SUM(g.shutouts)         AS shutouts
FROM nhl.goalies_playoffs g
JOIN nhl.goalies_reference gr ON g.player_id = gr.player_id
WHERE 1=1
    -- AND g.season    = 20212022  -- filter by season
    -- AND g.team      = 'EDM'     -- filter by team
    -- AND gr.catches  = 'L'       -- filter by catches: L or R
GROUP BY gr.player_name
HAVING SUM(g.gp) >= 4              -- minimum 4 games played
ORDER BY save_percentage DESC
LIMIT 20;
-- ============================================
-- NHL Statistics Database
-- Script: teams.sql
-- Description: Team statistics queries
--              - Team standings by conference and division
--              Regular season and playoffs
-- Schema: nhl | Database: nhl_db
-- ============================================


-- Team standings by conference and division (regular season)
-- Remove comments from WHERE filters to narrow results
-- Switch ORDER BY to change sorting
SELECT
    tr.team             AS team_name,
    tr.conference,
    tr.division,
    SUM(t.gp)           AS games_played,
    SUM(t.wins)         AS wins,
    SUM(t.losses)       AS losses,
    SUM(t.ot)           AS overtime_losses,
    SUM(t.gf)           AS goals_for,
    SUM(t.ga)           AS goals_against,
    SUM(t.points)       AS points
FROM nhl.teams_regular t
JOIN nhl.teams_reference tr ON t.team = tr.abbreviation
WHERE 1=1
    -- AND t.season        = 20212022  -- filter by season
    -- AND t.team          = 'EDM'     -- filter by team
    -- AND tr.conference   = 'Western' -- filter by conference
GROUP BY tr.team, tr.conference, tr.division
ORDER BY tr.conference, points DESC;                        -- sort by conference
-- ORDER BY tr.conference, tr.division, points DESC;        -- sort by division

-- Team standings by conference and division (playoffs)
-- Remove comments from WHERE filters to narrow results
-- Switch ORDER BY to change sorting
SELECT
    tr.team             AS team_name,
    tr.conference,
    tr.division,
    SUM(t.gp)           AS games_played,
    SUM(t.wins)         AS wins,
    SUM(t.losses)       AS losses,
    SUM(t.gf)           AS goals_for,
    SUM(t.ga)           AS goals_against,
    SUM(t.points)       AS points
FROM nhl.teams_playoffs t
JOIN nhl.teams_reference tr ON t.team = tr.abbreviation
WHERE 1=1
    -- AND t.season        = 20212022  -- filter by season
    -- AND t.team          = 'EDM'     -- filter by team
    -- AND tr.conference   = 'Western' -- filter by conference
GROUP BY tr.team, tr.conference, tr.division
ORDER BY tr.conference, points DESC;                        -- sort by conference
-- ORDER BY tr.conference, tr.division, points DESC;        -- sort by division
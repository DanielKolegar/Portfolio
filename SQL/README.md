# NHL Statistics SQL Project

## 📊 About the Project
This project provides an analysis of NHL player and team statistics using PostgreSQL.
It includes SQL queries for skater, goalie, and team statistics, covering both
Regular Season and Playoffs data from the 2021-2022 season onwards.

## 📂 Dataset
The dataset is organized by season, with each season divided into:
- Regular Season
- Playoffs

It includes statistics for skaters, goalies, and teams, as well as a separate
file with team reference data (conference, division).

All CSV files are available in the [data](data/) folder.

Data source: [NHL](https://www.nhl.com/stats/)

## ⚙️ Technologies Used
- PostgreSQL (Database)
- DBeaver (Database management)
- VS Code (CSV file inspection)
- Notepad++ (Script editing)

## 🤖 AI Tools Used
- [Claude](https://claude.ai/) (Anthropic) – used for database schema design,
  SQL query writing, and project guidance

## 🗄️ Database Structure
The database `nhl_db` uses schema `nhl` with the following tables:

**Reference tables**
- `teams_reference` – static team info (conference, division)
- `skaters_reference` – static skater info (date of birth, nationality, draft info)
- `goalies_reference` – static goalie info (date of birth, nationality, draft info)

**Statistics tables**
- `skaters_regular` / `skaters_playoffs` – skater statistics
- `goalies_regular` / `goalies_playoffs` – goalie statistics
- `teams_regular` / `teams_playoffs` – team statistics

## 📁 Project Files
- [1_create_tables.sql](1_create_tables.sql) – creates all tables in nhl schema
- [2_import_data.sql](2_import_data.sql) – imports data from CSV files into the database
- [queries/skaters.sql](queries/skaters.sql) – skater statistics queries
- [queries/goalies.sql](queries/goalies.sql) – goalie statistics queries
- [queries/teams.sql](queries/teams.sql) – team statistics queries

## 🚀 How to Set Up
1. Install [PostgreSQL](https://www.postgresql.org/download/) and [DBeaver](https://dbeaver.io/download/)
2. In DBeaver, connect to PostgreSQL and run the following commands to create the database and schema:
```sql
CREATE DATABASE nhl_db;
```
Then connect to `nhl_db` and run:
```sql
CREATE SCHEMA nhl;
```
3. Run [1_create_tables.sql](1_create_tables.sql) to create all tables
4. Place [CSV files](data/) in `C:/csv/` and run [2_import_data.sql](2_import_data.sql) to import data
5. Open query files in [queries](queries/) folder and run them in DBeaver

## 📈 Queries Overview
**Skaters**
- Top skaters by goals / assists / points
- Top skaters by plus/minus, penalty minutes, power play goals,
  shorthanded goals, game winning goals and shots

**Goalies**
- Save percentage vs goals against average, wins vs shutouts

**Teams**
- Team standings by conference and division

All queries support filters by season, team, etc.

## 🔄 Ongoing Updates
This project will be updated after the end of each NHL Regular Season and Playoffs
to include the latest data.

## 📩 Contact
If you have any questions or suggestions, feel free to open an issue in this repository.

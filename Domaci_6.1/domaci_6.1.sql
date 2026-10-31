-- 1. zadatak

CREATE TABLE dim_players AS
SELECT DISTINCT
    player_id,
    first_name AS ime,
    last_name AS prezime,
    position AS pozicija,
    nationality AS nacionalnost
FROM bootcamp.northern_star.players;

SELECT *
FROM dim_players;

-- 681 red


-- 2. zadatak

CREATE OR REPLACE TABLE dim_date AS
SELECT CAST(DATE_FORMAT(d, 'yyyyMMdd') AS INT) AS date_key,
       d                                       AS full_date,
       DATE_FORMAT(d, 'EEEE')                  AS weekday_name,
       DAYOFWEEK(d) IN (1, 7)                  AS is_weekend,
       CASE WHEN MONTH(d) >= 7 THEN CONCAT(YEAR(d), '/', SUBSTRING(CAST(YEAR(d) + 1 AS STRING), 3, 2))
            ELSE CONCAT(YEAR(d) - 1, '/', SUBSTRING(CAST(YEAR(d) AS STRING), 3, 2))
       END                                     AS season
FROM (SELECT EXPLODE(SEQUENCE(DATE'2023-07-01', DATE'2025-06-30', INTERVAL 1 DAY)) AS d);


CREATE OR REPLACE TABLE fact_player_match AS 
SELECT DISTINCT
    m.match_id AS match_id,
    CAST(DATE_FORMAT(kickoff_ts, 'yyyyMMdd') AS INT) AS date_key,
    ps.player_id AS player_id,
    ps.team_id AS team_id,
    ps.minutes_played AS minutes_played,
    ps.shots AS shots,
    ps.passes AS passes,
    ps.rating AS rating
FROM bootcamp.northern_star.player_match_stats ps
INNER JOIN bootcamp.northern_star.matches m ON m.match_id = ps.match_id
WHERE m.status = 'played';

SELECT *
FROM fact_player_match
ORDER BY player_id;

/*
Granularnost se zasniva na svakom igraču i njegovom učinku po meču.
Tabela sadrži 30.400 redova ((380 * 2 po sezoni) * (20 igrača jednog tima + 20 igrača drugog tima)).
*/


-- 3. zadatak

SELECT
    DISTINCT p.pozicija,
    ROUND(AVG(fpm.rating), 2) AS prosjek
FROM fact_player_match fpm
INNER JOIN dim_players p ON p.player_id = fpm.player_id
WHERE rating NOT ILIKE 'nan'
GROUP BY p.pozicija;

/*
pozicija	prosjek

FW      	6.79%
DF	        6.64%
MF	        6.71%
GK	        6.62%
*/


-- 4. zadatak

ALTER TABLE fact_player_match ADD COLUMN total_goals INT;

UPDATE fact_player_match AS fpm
SET total_goals = (
        SELECT COUNT(me.event_type)
        FROM bootcamp.northern_star.match_events me
        WHERE fpm.player_id = me.player_id
            AND me.match_id = fpm.match_id
            AND me.event_type IN ('goal', 'penalty_goal'));

SELECT
    SUM(total_goals)
FROM fact_player_match;

-- Ukupan broj golova svih igrača za obje sezone je 2043.        
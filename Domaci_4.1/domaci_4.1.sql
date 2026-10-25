-- 1. Zadatak

SELECT 
    COUNT(*)
FROM matches m
INNER JOIN player_match_stats ps ON m.match_id = ps.match_id
WHERE m.season = '2024/25';

-- Vraća 15.200 redova jer umnožava broj utakmica sa brojem igrača na utakmici.

SELECT
    m.match_id,
    COUNT(ps.player_id)
FROM matches m
INNER JOIN player_match_stats ps ON m.match_id = ps.match_id
WHERE m.season = '2024/25'
GROUP BY m.match_id;

-- 380 utakmica sa po 40 igrača iznosi 15.200 redova.

WITH broj_igraca_po_utakmici AS (
    SELECT
        m.match_id,
        COUNT(ps.player_id) AS broj_igraca
    FROM matches m
    INNER JOIN player_match_stats ps ON m.match_id = ps.match_id
    WHERE m.season = '2024/25'
    GROUP BY m.match_id
)
SELECT
    AVG(broj_igraca)
FROM broj_igraca_po_utakmici;


-- 2. zadatak

WITH igraci_u_vise_klubova AS (
    SELECT 
        ps.player_id AS igrac,
        m.season AS sezona,
        COUNT (DISTINCT ps.team_id) AS broj_klubova
    FROM player_match_stats ps
    INNER JOIN matches m ON m.match_id = ps.match_id
    GROUP BY ps.player_id, m.season
    HAVING broj_klubova > 1
)
SELECT 
    sezona,
    COUNT(igrac) AS broj_igraca
FROM igraci_u_vise_klubova
GROUP BY sezona;

/*
Sezona	    Broj_igraca
2023/24	    18
2024/25	    17
*/


-- 3. zadatak

WITH mnogo_kartona AS (
    SELECT
        m.match_id,
        COUNT(me.event_type) as broj_kartona
    FROM matches m
    LEFT JOIN match_events me ON me.match_id = m.match_id 
            AND me.event_type IN ('yellow_card', 'second_yellow', 'red_card')
    GROUP BY m.match_id
)
SELECT 
    COUNT(*)
FROM mnogo_kartona
WHERE broj_kartona > (SELECT AVG(broj_kartona) 
FROM mnogo_kartona);

-- 370 utakmica je imalo vise kartona od prosjeka.


-- 4. zadatak

WITH igraci_sa_vise_od_deset_utakmica AS (
    SELECT
        p.player_id AS Igrac,
        COUNT(DISTINCT m.match_id) AS Broj_utakmica
    FROM matches m
    INNER JOIN player_match_stats ps ON ps.match_id = m.match_id
    INNER JOIN players p ON p.player_id = ps.player_id
    WHERE m.season = '2024/25'
    GROUP BY p.player_id
    HAVING COUNT(DISTINCT m.match_id) > 10
)
SELECT
    COUNT(*)
FROM igraci_sa_vise_od_deset_utakmica;

-- 483 igraca hje odigralo vise on 10 utakmica u sezoni 2024/25.


-- 5. zadatak

SELECT
    m.home_team_id AS Broj_kluba,
    t.team_name AS Klub
FROM matches m
INNER JOIN teams t ON t.team_id = m.home_team_id
WHERE m.season = '2024/25'
UNION
SELECT 
    m.away_team_id AS Broj_kluba,
    t.team_name AS Klub
FROM matches m
INNER JOIN teams t ON t.team_id = m.away_team_id
WHERE m.season = '2024/25';

SELECT
    m.home_team_id AS Broj_kluba,
    t.team_name AS Klub
FROM matches m
INNER JOIN teams t ON t.team_id = m.home_team_id
WHERE m.season = '2024/25'
UNION ALL
SELECT 
    m.away_team_id AS Broj_kluba,
    t.team_name AS Klub
FROM matches m
INNER JOIN teams t ON t.team_id = m.away_team_id
WHERE m.season = '2024/25';

/*
UNION spaja rezultate i uklanja duplikate, vraćajući samo jedinstvene klubove, 
dok UNION ALL ispisuje svako pojedinačno pojavljivanje tima, 
što iznosi 19 utakmica na domaćem terenu i 19 gostujućih utakmica za 20 klubova
(19 * 20 + 19 * 20 = 760 redova).
*/
-- OSNOVNI NIVO

-- 1. zadatak

SELECT 
    DISTINCT t.team_name AS Klub,
    COALESCE(s.stadium_name, 'Ne postoji') AS `Naziv stadiona`
FROM teams AS t
LEFT JOIN stadiums AS s ON s.stadium_id = t.stadium_id
ORDER BY Klub;

-- Postoje 24 kluba, od toga 23 imaju svoj stadion, samo Harbor City FC nema svoj teren.


-- 2. zadatak 

SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS `Ime igrača`,
    t.team_name AS `Naziv kluba`
FROM matches AS m
INNER JOIN player_match_stats AS ps ON ps.match_id = m.match_id
INNER JOIN players AS p ON p.player_id = ps.player_id
INNER JOIN teams AS t ON t.team_id = ps.team_id
WHERE m.season = '2024/25'
GROUP BY p.player_id, `Ime igrača`, `Naziv kluba`
ORDER BY `Naziv kluba`, `Ime igrača`;

/*
Ime igrača	    Naziv kluba
Aaron Dawson	Ashford Rovers
Ante Šimić	    Ashford Rovers
Björn Johansson	Ashford Rovers
Chidi Adeyemi	Ashford Rovers
.
.
.
*/


-- 3. zadatak 

SELECT
    DATE(m.kickoff_ts) AS Datum,
    s.stadium_name AS  `Naziv stadiona`,
    COALESCE(CAST(m.attendance AS STRING), 'Nema podataka') AS `Broj gledalaca`
FROM matches AS m
INNER JOIN stadiums AS s ON s.stadium_id = m.stadium_id
WHERE m.season = '2024/25'
ORDER BY Datum;

/*
Datum	    Naziv stadiona	    Broj gledalaca
2024-08-17	The Albion Ground	23244
2024-08-17	Lakeside Stadium	22287
2024-08-17	Brackley Road	    Nema podataka
.
.
.
*/


-- SREDNJI NIVO

-- 1. zadatak 

SELECT
    DATE(m.kickoff_ts) AS Datum,
    home.team_name AS `Domaćini`,
    away.team_name AS Gosti
FROM matches AS m
INNER JOIN teams AS home ON home.team_id = m.home_team_id
INNER JOIN teams AS away ON away.team_id = m.away_team_id
WHERE m.attendance IS NULL
ORDER BY Datum;

-- 17 utakmica nema evidentirane podatke o gledaocima. 


-- 2. zadatak

SELECT 
    s.stadium_name
FROM stadiums AS s
LEFT JOIN matches AS m ON s.stadium_id = m.stadium_id AND m.season = '2024/25'
WHERE m.match_id IS NULL;

-- Fairhaven Lane

-- 3. zadatak

SELECT 
    t.team_name AS `Klub`,
    COUNT(*) AS `Ukupno žutih kartona`
FROM matches AS m
INNER JOIN match_events AS me ON m.match_id = me.match_id
INNER JOIN teams AS t ON t.team_id = me.team_id
WHERE m.season = '2024/25'
    AND me.event_type IN ('yellow_card', 'second_yellow')
GROUP BY t.team_name
ORDER BY `Ukupno žutih kartona` DESC;

/*
Klub	            Ukupno žutih kartona
Ashford Rovers	    77
Castlebrook United	76
Riverton Athletic	71
.
.
.
*/


-- NAPREDNI NIVO

-- 1. zadatak

SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS `Ime igrača`,	
    COUNT(me.related_player_id) AS `Broj asistencija`
FROM matches m 
INNER JOIN match_events me ON me.match_id = m.match_id
INNER JOIN players p ON p.player_id = me.related_player_id
WHERE m.season = '2024/25' AND me.event_type = 'goal'
GROUP BY p.player_id, `Ime igrača`
ORDER BY `Broj asistencija` DESC
LIMIT 5;

/*
Ime igrača	        Broj asistencija
Pablo Fernández	    9
Filip Petrović	    7
Eirik Solberg	    7
Lucas Pereira	    7
Kieran Bradley	    6
*/  


-- 2. zadatak

SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS `Ime igrača`,
    t.team_name AS `Klub`,	
    SUM(ps.minutes_played) AS `Broj minuta`
FROM player_match_stats ps 
INNER JOIN matches m ON m.match_id = ps.match_id
INNER JOIN players p ON p.player_id = ps.player_id
INNER JOIN teams t ON t.team_id = ps.team_id
WHERE m.season = '2024/25'
GROUP BY ps.player_id, `Ime igrača`, `Klub`
ORDER BY `Broj minuta` DESC
LIMIT 3;

/*
Ime igrača	        Klub	            Broj minuta
Aaron Lowe	        Kingsbridge City	3240
Jonas Müller	    Westmere Town	    3240
Ibrahima Ndiaye	    Ashford Rovers	    3240
*/


-- 3. zadatak

SELECT
    m.season AS Sezona,
    t.team_name AS Klub,
    COUNT(me.event_type) AS `Broj isključenja`
FROM matches m 
INNER JOIN match_events me ON me.match_id = m.match_id
INNER JOIN teams t ON t.team_id = me.team_id
WHERE me.event_type IN ('red_card', 'second_yellow')
GROUP BY m.season, t.team_name
HAVING `Broj isključenja` >= 1
ORDER BY t.team_name, m.season;

/*
Sezona	Klub	            Broj isključenja
2023/24	Ashford Rovers	    1
2024/25	Ashford Rovers	    3
2023/24	Brackley Harriers	4
2024/25	Castlebrook United	3
*/
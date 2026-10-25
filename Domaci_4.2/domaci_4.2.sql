-- 1. zadatak

WITH newbury_forest AS (
    SELECT team_id AS broj_kluba 
    FROM teams 
    WHERE team_name = 'Newbury Forest'
),
utakmice AS (
    SELECT
        match_id,
        season AS sezona,
        home_goals AS dati_golovi,
        away_goals AS primljeni_golovi
    FROM matches m
    INNER JOIN newbury_forest nf ON m.home_team_id = nf.broj_kluba
    UNION ALL
    SELECT 
        match_id,
        season AS sezona,
        away_goals AS dati_golovi,
        home_goals AS primljeni_golovi
    FROM matches m
    INNER JOIN newbury_forest nf ON m.away_team_id = nf.broj_kluba
)
SELECT
    COUNT(*) AS Broj_utakmica,
    COUNT(CASE WHEN dati_golovi > primljeni_golovi THEN 1 END) AS Pobjede,
    COUNT(CASE WHEN dati_golovi = primljeni_golovi THEN 1 END) AS Nerjeseno,
    COUNT(CASE WHEN dati_golovi < primljeni_golovi THEN 1 END) AS Porazi,
    SUM(dati_golovi) AS Dati_golovi,
    SUM(primljeni_golovi) AS Primljeni_golovi,
    SUM(CASE WHEN dati_golovi > primljeni_golovi THEN 3 
             WHEN dati_golovi = primljeni_golovi THEN 1
             ELSE 0 END) AS Bodovi
FROM utakmice
WHERE sezona = '2024/25';

/*
Broj_utakmica	Pobjede	 Nerjeseno	 Porazi	  Dati_golovi	Primljeni_golovi	Bodovi
38	            11       9	         18       47	        68	                42
*/


-- 2. zadatak

WITH newbury_forest AS (
    SELECT team_id AS broj_kluba 
    FROM teams 
    WHERE team_name = 'Newbury Forest'
),
utakmice AS (
    SELECT
        match_id,
        season AS sezona,
        'Kod kuce' AS lokacija,
        home_goals AS dati_golovi,
        away_goals AS primljeni_golovi
    FROM matches m
    INNER JOIN newbury_forest nf ON m.home_team_id = nf.broj_kluba
    UNION ALL
    SELECT 
        match_id,
        season AS sezona,
        'U gostima' AS lokacija,
        away_goals AS dati_golovi,
        home_goals AS primljeni_golovi
    FROM matches m
    INNER JOIN newbury_forest nf ON m.away_team_id = nf.broj_kluba
)
SELECT
    Lokacija,
    COUNT(*) AS Broj_utakmica,
    COUNT(CASE WHEN dati_golovi > primljeni_golovi THEN 1 END) AS Pobjede,
    COUNT(CASE WHEN dati_golovi = primljeni_golovi THEN 1 END) AS Nerjeseno,
    COUNT(CASE WHEN dati_golovi < primljeni_golovi THEN 1 END) AS Porazi,
    SUM(dati_golovi) AS Dati_golovi,
    SUM(primljeni_golovi) AS Primljeni_golovi,
    SUM(CASE WHEN dati_golovi > primljeni_golovi THEN 3 
             WHEN dati_golovi = primljeni_golovi THEN 1
             ELSE 0 END) AS Bodovi
FROM utakmice
WHERE sezona = '2024/25'
GROUP BY lokacija;

/*
Lokacija	Broj_utakmica	Pobjede	 Nerjeseno	Porazi	Dati_golovi	 Primljeni_golovi	Bodovi
Kod kuce	19	            4	     5	        10	    22	         32	                17
U gostima	19	            7	     4	        8	    25	         36	                25
*/


-- 3. zadatak

WITH newbury_forest AS (
    SELECT team_id AS broj_kluba 
    FROM teams 
    WHERE team_name = 'Newbury Forest'
),
strelci AS (
    SELECT 
        'Strelac' AS uloga,
        CONCAT(p.first_name, ' ', p.last_name) AS igrac,
        COUNT(me.event_id) AS ukupno
    FROM match_events me
    INNER JOIN matches m ON m.match_id = me.match_id
    INNER JOIN newbury_forest nf ON me.team_id = nf.broj_kluba
    INNER JOIN players p ON me.player_id = p.player_id 
    WHERE me.event_type IN ('goal', 'penalty_goal') 
        AND m.season = '2024/25'
    GROUP BY p.player_id, igrac
    ORDER BY ukupno DESC
    LIMIT 3
),
asistent AS (
    SELECT 
        'Asistent' AS uloga,
        CONCAT(p.first_name, ' ', p.last_name) AS igrac,
        COUNT(me.event_id) AS Ukupno
    FROM match_events me
    INNER JOIN matches m ON m.match_id = me.match_id
    INNER JOIN newbury_forest nf ON me.team_id = nf.broj_kluba
    INNER JOIN players p ON me.related_player_id = p.player_id 
    WHERE me.event_type IN ('goal', 'penalty_goal') 
            --AND me.related_player_id IS NOT NULL
            AND m.season = '2024/25'
    GROUP BY p.player_id, igrac
    ORDER BY ukupno DESC
    LIMIT 1
)
SELECT * FROM strelci
UNION ALL
SELECT * FROM asistent;

/*
uloga	    igrac	        ukupno
Strelac	    Harry Carter	6
Strelac	    Théo Laurent	5
Strelac 	Callum Walker	4
Asistent	Reece Carter	6
*/


-- 4. zadatak

WITH newbury_forest AS (
    SELECT team_id AS broj_kluba 
    FROM teams 
    WHERE team_name = 'Newbury Forest'
),
disciplina AS (
    SELECT
        m.match_id,
        COUNT(me.event_id) AS broj_kartona 
    FROM matches m
    CROSS JOIN newbury_forest nf
    LEFT JOIN match_events me ON me.match_id = m.match_id 
        AND me.team_id = nf.broj_kluba
        AND me.event_type IN ('yellow_card', 'second_yellow', 'red_card')
    WHERE m.season = '2024/25'
      AND (m.home_team_id = nf.broj_kluba OR m.away_team_id = nf.broj_kluba)
    GROUP BY m.match_id
),
prosjek_kartona_lige AS (
    SELECT
        (COUNT(me.event_id) * 1.0 / (SELECT COUNT(*) FROM matches WHERE season = '2024/25')) / 2 AS prosjek_lige
    FROM matches m
    LEFT JOIN match_events me ON m.match_id = me.match_id 
        AND me.event_type IN ('yellow_card', 'second_yellow', 'red_card')
    WHERE m.season = '2024/25'
)
SELECT
    ROUND(AVG(broj_kartona), 2), 
    ROUND((prosjek_lige), 2)
FROM disciplina
CROSS JOIN prosjek_kartona_lige
GROUP BY prosjek_lige;

/*
avg(broj_kartona)	prosjek_lige
1.79	            1.74
*/


-- 5. zadatak

WITH newbury_forest AS (
    SELECT team_id AS broj_kluba 
    FROM teams 
    WHERE team_name = 'Newbury Forest'
),
utakmice_trenera AS (
    SELECT 
        ms.manager_name AS trener,
        m.match_id,
        CASE 
            WHEN m.home_team_id = nf.broj_kluba AND m.home_goals > m.away_goals THEN 3
            WHEN m.away_team_id = nf.broj_kluba AND m.away_goals > m.home_goals THEN 3
            WHEN m.home_goals = m.away_goals THEN 1
            ELSE 0
        END AS bodovi
    FROM matches m
    CROSS JOIN newbury_forest nf
    INNER JOIN manager_spells ms ON ms.team_id = nf.broj_kluba
    WHERE m.season = '2024/25'
      AND (m.home_team_id = nf.broj_kluba OR m.away_team_id = nf.broj_kluba)
)
SELECT 
    trener,
    COUNT(match_id) AS broj_vodjenih_utakmica,
    SUM(bodovi) AS ukupno_osvojenih_bodova,
    ROUND(SUM(bodovi) / COUNT(match_id), 2) AS bodova_po_utakmici
FROM utakmice_trenera
GROUP BY trener;

/*
trener	        broj_vodjenih_utakmica	 ukupno_osvojenih_bodova	bodova_po_utakmici
Gary Neville	38	                     42	                        1.11
*/


-- 6. zadatak

WITH newbury_forest AS (
    SELECT team_id AS broj_kluba 
    FROM teams 
    WHERE team_name = 'Newbury Forest'
),
utakmice AS (
    SELECT 
        CASE 
            WHEN m.home_team_id = nf.broj_kluba THEN (m.home_goals - m.away_goals)
            ELSE (m.away_goals - m.home_goals)
        END AS gol_razlika
    FROM matches m
    CROSS JOIN newbury_forest nf
    WHERE m.season = '2024/25'
      AND (m.home_team_id = nf.broj_kluba OR m.away_team_id = nf.broj_kluba)
)
SELECT 
    MAX(gol_razlika) AS najveca_pobeda_razlika,
    ABS(MIN(gol_razlika)) AS najtezi_poraz_razlika
FROM utakmice;

/*
najveca_pobeda_razlika	najtezi_poraz_razlika
2	                    4
*/


-- 7. zadatak

WITH newbury_forest AS (
    SELECT team_id AS broj_kluba 
    FROM teams 
    WHERE team_name = 'Newbury Forest'
),
posjecenost AS (
    SELECT
        AVG(s.capacity),
        ROUND(AVG(m.attendance), 2),
        ROUND(100.0 * AVG(m.attendance) / MAX(s.capacity), 2) AS postotak,
        SUM(CASE WHEN m.attendance = 0 OR m.attendance IS NULL THEN 1 
            ELSE 0 END) AS bez_gledalaca_ili_podataka
    FROM matches m    
    INNER JOIN stadiums s ON s.stadium_id = m.stadium_id
    INNER JOIN newbury_forest nf ON nf.broj_kluba = m.home_team_id
)
SELECT *
FROM posjecenost;

/*
round(avg(attendance), 2)	postotak	avg(capacity)	bez_gledalaca_ili_podataka
13922.89	                87.02	    16000	        0
*/
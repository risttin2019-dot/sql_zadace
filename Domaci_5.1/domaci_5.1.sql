-- 1. zadatak

SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS igrac,
    COUNT(me.event_type) AS golovi,
    DENSE_RANK() OVER (ORDER BY COUNT(me.event_type) DESC) AS dense_rnk
FROM match_events me
INNER JOIN matches m ON m.match_id = me.match_id
INNER JOIN players p ON p.player_id = me.player_id
WHERE m.season = '2024/25' AND me.event_type IN ('goal', 'penalty_goal')
GROUP BY me.player_id, p.first_name, p.last_name
HAVING golovi > 0
ORDER BY golovi DESC;

/*
igrac	          golovi	dense_rnk
Mattéo O'Brien	  34	    1
Leo Marsh	      32	    2
José Muñoz	      24	    3
Marko Stanković   17	    4
Leo Marsh	      16	    5
Ben Bennett	      15	    6
Raphaël Rousseau  13	    7
Calum Fraser	  12	    8
Luke Gibbs	      11	    9
Jamal Holt	      11	    9
.
.
.

Luke Gibbs i Jamal Holt su prvi na listi koji dijele poziciju po DENSE_RANK()
rangiranju. Obojica imaju po 11 postignutih golova u sezoni 2024/25 i obojica 
se nalaze na 9. mjestu.
*/


-- 2. zadatak

SELECT
    t.team_name AS klub,
    CONCAT(p.first_name, ' ', p.last_name) AS igrac,
    COUNT(me.event_type) AS golovi,
    ROW_NUMBER() OVER (PARTITION BY t.team_name ORDER BY COUNT(me.event_type) DESC) AS rn
FROM match_events me
INNER JOIN matches m ON m.match_id = me.match_id
INNER JOIN players p ON p.player_id = me.player_id
INNER JOIN teams t ON t.team_id = me.team_id
WHERE m.season = '2024/25' AND me.event_type IN ('goal', 'penalty_goal')
GROUP BY me.player_id, p.first_name, p.last_name, t.team_name
QUALIFY rn <= 3;

/*
klub	            igrac	        golovi	rn
Ashford Rovers	    Luke Gibbs	    11  	1
Ashford Rovers	    Jack Cole	    5	    2
Ashford Rovers	    Jonas Becker	5	    3
Brackley Athletic	Lewis Bradley	6	    1
Brackley Athletic	Reece Cole  	6	    2
Brackley Athletic	Erik Johansson	5	    3
.
.
.
*/


-- 3. zadatak

WITH golovi_kluba AS (
    SELECT
        m.match_id AS utakmica,
        t.team_name AS klub,
        CASE WHEN m.home_team_id = t.team_id THEN m.home_goals
        ELSE m.away_goals END as dati_golovi
    FROM matches m
    INNER JOIN teams t ON t.team_id = m.home_team_id OR t.team_id = m.away_team_id
    WHERE season = '2024/25'
    ORDER BY t.team_name, m.match_id
)
SELECT
    utakmica,
    klub,
    dati_golovi,
    LAG(dati_golovi) OVER (PARTITION BY klub ORDER BY utakmica) AS golovi_prethodne_utakmice,
    dati_golovi - golovi_prethodne_utakmice AS razlika
FROM golovi_kluba; 

/*
utakmica	klub	         dati_golovi  golovi_prethodne_utakmice	 razlika

2001	    Ashford Rovers	 0	          null	                     null
2011	    Ashford Rovers	 3	          0	                         3
2030	    Ashford Rovers	 0	          3	                        -3
2036	    Ashford Rovers	 0	          0	                         0
.
.
.
*/
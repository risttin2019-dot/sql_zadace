-- 1. zadatak

SELECT
    season,
    COUNT(*) AS number_of_matches,
    SUM(home_goals + away_goals) AS total_goals,
    ROUND(AVG(home_goals + away_goals), 2) AS avg_goals
FROM matches_flat
GROUP BY season;

/*
season	 number_of_matches  total_goals	 avg_goals
2023/24	 381                1046	     2.75
2024/25	 380	            1092	     2.87
*/


-- 2. zadatak

SELECT
    stadium_name AS `Stadion`,
    MAX(attendance) AS `Najveća posjećenost`,
    MIN(attendance) AS `Najniža posjećenost`,
    ROUND(AVG(attendance), 2) AS `Prosječna posjećenost`, 
    COUNT(*) AS `Broj utakmica`
FROM matches_flat
WHERE attendance IS NOT NULL
GROUP BY stadium_name
ORDER BY `Najveća posjećenost` DESC;

/*
Stadion	            Najveća posjećenost	Najniža posjećenost	Prosječna posjećenost	Broj utakmica
Harbourside Park	50922	            37641	            44415.63	            38
Kingsbridge Stadium	46824	            33872	            40091.05	            38
Northport Arena 	40844	            29777	            35265.83	            36
.
.
.
*/


-- 3. zadatak

SELECT
    referee_name AS `Sudija`,
    COUNT(*) AS `Broj utakmica`,
    SUM(home_yellow_cards + away_yellow_cards) AS `Ukupno žutih kartona`
FROM matches_flat
GROUP BY referee_name
HAVING `Broj utakmica` >= 10 AND `Ukupno žutih kartona` >= 20
ORDER BY `Ukupno žutih kartona` DESC;

/*
Sudija	    	Broj utakmica	Ukupno žutih kartona
Henrik Dahl 	40	            164
Peter Lindgren	40	            162
Amir Haddad	    40	            154
.
.
.
*/


-- 4. zadatak

SELECT
    CASE WHEN (home_goals + away_goals) >= 3 THEN 'Mnogo golova'
         WHEN (home_goals + away_goals) BETWEEN 1 AND 2 THEN 'Malo golova' 
         WHEN (home_goals + away_goals) = 0 THEN 'Bez golova'    
         ELSE 'Nepoznato' END AS `Golovi`,
    COUNT(*) AS `Broj utakmica`,
    MAX(home_goals + away_goals) AS `Najveći broj golova` 
FROM matches_flat
WHERE home_goals IS NOT NULL AND away_goals IS NOT NULL
GROUP BY `Golovi`;

/*
Golovi	        Broj utakmica	Najveći broj golova
Mnogo golova	389	            9
Malo golova	    30	            2
Bez golova	    41	            0
*/


-- 5. zadatak

SELECT
    home_team AS `Klub`,
    COUNT(*) AS `Broj utakmica`,
    COUNT(CASE WHEN home_goals > away_goals THEN 1
          END) AS `Broj pobjeda kod kuće`,
    COUNT(CASE WHEN home_goals < away_goals THEN 1
          END) AS  `Broj poraza kod kuće`
FROM matches_flat
GROUP BY home_team
HAVING COUNT(*) >= 10
ORDER BY `Broj utakmica` DESC;

/*
Klub	            Broj utakmica	Broj pobjeda kod kuće	Broj poraza kod kuće
Oakfield Town	    39	            15	                    11
Northport City	    38	            26	                    4
Elmsworth Wanderers	38	            17	                    11
.
.
.
*/


-- 6. zadatak

SELECT
    referee_name AS `Sudija`,
    COUNT(*) AS `Broj utakmica`,
    SUM(CASE WHEN home_red_cards > 0 THEN 1
                WHEN away_red_cards > 0 THEN 1
                ELSE 0 END) AS `Crveni kartoni`,
    CONCAT(ROUND(100.0 * SUM(CASE WHEN home_red_cards > 0 THEN 1
                WHEN away_red_cards > 0 THEN 1
                ELSE 0 END) / COUNT(*), 2), '%') AS `Postotak`
FROM matches_flat
GROUP BY referee_name
HAVING `Crveni kartoni` >= 1
ORDER BY `Crveni kartoni` DESC;

/*
Sudija	                Broj utakmica	Crveni kartoni	Postotak
Robert Kane	            40	            8	            20.00%
Craig Pawson-Lee	    40	            8           	20.00%
Michael Oliver Hart	    40	            7	            17.50%
.
.
.
*/


-- 7. zadatak

SELECT
    season AS `Sezona`,
    COUNT(CASE WHEN home_goals > away_goals THEN 1
               END) AS `Pobjeda domaćina`,
    COUNT(CASE WHEN home_goals = away_goals THEN 1
               END) AS `Nerješeno`,
    COUNT(CASE WHEN home_goals < away_goals THEN 1
               END) AS `Pobjeda gostiju`,
    COUNT(CASE WHEN home_goals IS NULL OR away_goals IS NULL THEN 1
               END) AS `Nema podataka`,
    CONCAT(ROUND(100.0 * COUNT(CASE WHEN home_goals = away_goals THEN 1
               END) / COUNT(*), 2), '%') AS `Postotak nerješenih utakmica`
FROM matches_flat
GROUP BY season;

/*
Sezona	Pobjeda domaćina	Nerješeno	Pobjeda gostiju	Nema podataka	Postotak nerješenih utakmica
2023/24	172	                96	        112         	1	            25.20%
2024/25	157	                95	        128         	0	            25.00%
*/
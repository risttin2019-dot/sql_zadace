-- 1. zadatak

SELECT *
FROM matches_flat
WHERE match_report ILIKE '%goal%';

-- bez riječi 'goalless'

SELECT *
FROM matches_flat
WHERE match_report ILIKE '%goal%'
    AND match_report NOT ILIKE '%goalless%';

-- U match_report-u ne postoji riječ 'goal', ona se isključivo nalazi unutar riječi 'goalless' koja se pominje u 41 utakmici.



-- 2. zadatak

SELECT
    coalesce(referee_name, 'Unknown') AS referee_name
FROM matches_flat
LIMIT 20;



-- 3. zadatak

SELECT 
    match_report,
    length(match_report) AS character_length
FROM matches_flat
WHERE length(match_report) > 40
ORDER BY character_length DESC;

-- 537 utakmica ima naslov duži od 40 karaktera.



-- 4. zadatak

SELECT *
FROM matches_flat
WHERE kickoff_ts BETWEEN '2025-01-01 00:00:00' AND '2025-01-16 00:00:00'
ORDER BY kickoff_ts DESC;

-- 31 utakmica je odigrana od 1. do 15. januara 2025. godine.



-- 5. zadatak

SELECT
    home_team,
    away_team,
    DATE(kickoff_ts),
    dayofweek(kickoff_ts)
FROM matches_flat
WHERE dayofweek(kickoff_ts) = 6;

-- Nijedna utakmica se nije igrala petkom.



-- 6. zadatak 

SELECT 
    COUNT(*) AS number_of_matches
FROM matches_flat
WHERE season = '2024/25' 
    AND attendance BETWEEN 20000 AND 35000;

-- 188 utakmica je odigrano u sezoni 2024/25, a da je imalo između 20.000 i 35.000 gledaoca.



-- 7. zadatal

SELECT 
    DISTINCT first_goal_scorer
FROM matches_flat
WHERE first_goal_scorer LIKE 'A%' OR first_goal_scorer LIKE '%-%'
ORDER BY first_goal_scorer;

/*
Ukupno 22 igrača, 20 njih počinje na slovo 'A', dok dvojica imaju '-' u imenu. 
Nijedan ne počinje sa slovom 'A' i ima '-' u imenu.
*/


-- 8. zadatak

SELECT 
    DATE_FORMAT(kickoff_ts, 'HH:mm:ss'),
    home_team,
    away_team
FROM matches_flat
WHERE season = '2024/25' 
    AND DATE_FORMAT(kickoff_ts, 'HH:mm:ss') BETWEEN '18:00:00' AND '21:00:00'
ORDER BY kickoff_ts;

-- 12 utakmica je odigrano u periodu između 18h i 21h uključujući obje granice.



-- 9. zadatak

SELECT 
    COUNT(*) AS number_of_matches
FROM matches_flat
WHERE MONTH(kickoff_ts) IN (3, 4, 5) 
    AND YEAR(kickoff_ts) = '2025' 
    AND match_report ILIKE '%win%';

-- bez riječi 'winner'

SELECT
    COUNT(*) AS number_of_matches
FROM matches_flat
WHERE MONTH(kickoff_ts) IN (3, 4, 5) 
    AND YEAR(kickoff_ts) = '2025' 
    AND (match_report ILIKE '%win%' AND match_report NOT ILIKE '%winner%');

/*
Tri utakmice su odigrane u martu, aprilu i maju 2025. godine, a koje u naslovu imaju riječ 'win'.
Ukoliko dozvolimo i da se računaju ostale riječi koje sadrže riječ 'win' (npr. 'winner'),
onda imamo 5 utakmica kao krajnji rezultat.
*/
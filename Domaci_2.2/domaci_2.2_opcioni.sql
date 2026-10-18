-- 1. zadatak

SELECT 
    COUNT(*)
FROM matches_flat
WHERE referee_name IS NULL 
    AND attendance IS NULL;

-- Ne postoji utakmica koja nema evidenciju za posjeti i sudiju.



-- 2. zadatak

SELECT *
FROM matches_flat
WHERE DATE(kickoff_ts) BETWEEN '2025-03-01' AND '2025-03-31'
ORDER BY kickoff_ts;

-- 40 utakmica je odigrano u periodu između 1. i 31. marta 2025. godine.



-- 3. zadatak

SELECT 
    COUNT(*) AS number_of_matches
FROM matches_flat
WHERE DATE(kickoff_ts) BETWEEN '2024-12-20' AND '2025-01-10';

-- 51 utakmica je odigrana u periodu između 20. decembra 2024. godine i 10. januara 2025. godine.



-- 4. zadatak

SELECT 
    DATE(kickoff_ts),
    home_team,
    away_team,
    coalesce(CAST(attendance AS string), 'Unknown') AS attendance_status
FROM matches_flat;



-- 5. zadatak

SELECT *
FROM matches_flat
WHERE DATE(kickoff_ts) BETWEEN '2025-04-01' AND '2025-04-30'
    AND home_goals + away_goals BETWEEN 2 AND 4
ORDER BY kickoff_ts;

-- Ukupno 22 utakmice su imale između 2 i 4 gola uključujući 2 i 4, u periodu od 1. do 30. aprila 2025. godine.



-- 6. zadatak

SELECT 
    DATE(kickoff_ts),
    CONCAT(home_team, ' ', home_goals_ht, ' - ', away_goals_ht, ' ', away_team) AS half_time_score,
    CONCAT(home_team, ' ', home_goals, ' - ', away_goals, ' ', away_team) AS final_score
FROM matches_flat
WHERE home_goals_ht = away_goals_ht
    AND home_goals <> away_goals;

-- Ukupno 244 utakmice su imale neriješen rezultat na poluvremenu, ali se utakmica zavšila pobjedom jednog od timova.
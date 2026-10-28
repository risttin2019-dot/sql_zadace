-- 1. zadatak

WITH pret_pet_utakmica AS (
    SELECT
        season, 
        team_id, 
        kickoff_ts, 
        points,
        AVG(points) OVER (
            PARTITION BY season, team_id 
            ORDER BY kickoff_ts, match_id
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        ) AS prosjek_prehodnih_5,
        COUNT(points) OVER (
            PARTITION BY season, team_id
            ORDER BY kickoff_ts, match_id
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS broj_uporedjenih_utakmica
    FROM team_matches
)
SELECT *
FROM pret_pet_utakmica
WHERE broj_uporedjenih_utakmica = 5;

-- Dodao sam i kolonu broj_utakmica čisto da meni bude jasnije da sam dobro obuhvatio broj utakmica tj. redova.


-- 2. zadatak

WITH tekuci_golovi AS (
    SELECT
        team_id,
        match_id,
        kickoff_ts,
        goals_for,
        SUM(goals_for) OVER (
            PARTITION BY team_id
            ORDER BY kickoff_ts
        ) AS running_total
        FROM team_matches
        WHERE season = '2024/25'
)
SELECT
    tg.team_id,
    t.team_name,
    tg.kickoff_ts,
    tg.running_total
FROM tekuci_golovi tg
INNER JOIN teams t ON t.team_id = tg.team_id
WHERE tg.running_total >= 50
ORDER BY tg.kickoff_ts
LIMIT 1;

-- Prvi koji je postigao 50 golova je Kingsbridge City, 18. januara 2025. godine.


-- 3. zadatak

WITH razlika_posjeta AS (
    SELECT
        match_id,
        season,
        kickoff_ts,
        home_team_id,
        away_team_id,
        attendance,
        attendance - LAG(attendance) OVER (
            PARTITION BY season, home_team_id
            ORDER BY kickoff_ts, match_id
        ) AS razlika
    FROM matches
    ORDER BY razlika, home_team_id
)
SELECT
    rp.match_id,
    t_home.team_name AS domacin,
    t_away.team_name AS gost,  
    rp.kickoff_ts,
    rp.season,
    rp.attendance,
    rp.razlika
FROM razlika_posjeta rp
INNER JOIN teams t_home ON rp.home_team_id = t_home.team_id
INNER JOIN teams t_away ON rp.away_team_id = t_away.team_id
WHERE rp.razlika IS NOT NULL
ORDER BY razlika;

/*
Najveća razlika ja na meču Oakfield Town - Fairhaven Town (ID 1220) sa padom od 17.864 posjetioca
u odnosu na prethodni meć Oakfiled Town, najvjerovatnije zbog kazne kojom su zabranjeno prisustvo navijača.
*/
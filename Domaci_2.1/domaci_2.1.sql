-- 1. zadatak

SELECT home_team, away_team, stadium_name,
        stadium_capacity, attendance, stadium_capacity - attendance AS empty_seats
FROM bootcamp.northern_star.matches_flat
ORDER BY empty_seats DESC NULLS LAST
LIMIT 5;

-- Prve tri utakmice sa najviše praznih mjesta su se desile na istom stadionu - National Stadium.



-- 2. zadatak

SELECT DISTINCT referee_name, home_team
FROM bootcamp.northern_star.matches_flat
WHERE home_team = 'Riverton Athletic';

-- ili sa COUNT

SELECT COUNT(DISTINCT referee_name)
FROM bootcamp.northern_star.matches_flat
WHERE home_team = 'Riverton Athletic';

-- 15 različitih sudija je sudilo Riverton Athleticu na domaćem terenu.



-- 3. zadatak 

SELECT home_team, away_team, home_goals, 
        away_goals, home_goals_ht, away_goals_ht
FROM bootcamp.northern_star.matches_flat
WHERE away_goals_ht > home_goals_ht AND home_goals > away_goals;

-- ili sa COUNT

SELECT COUNT(*)
FROM bootcamp.northern_star.matches_flat
WHERE away_goals_ht > home_goals_ht AND home_goals > away_goals;

-- U 15 utakmica je gostujući tim vodio na poluvremenu, ali na kraju izgubio od domaćina.



-- 4. zadatak

SELECT home_team, away_team, home_goals, away_goals, home_goals_ht, away_goals_ht,
        (home_goals - home_goals_ht) + (away_goals - away_goals_ht) AS second_ht_total_goals
FROM bootcamp.northern_star.matches_flat
ORDER BY second_ht_total_goals DESC
LIMIT 10;

-- Na utakmici Northport United - Newbury Forest (6:3) je palo najviše golova u drugom poluvremenu, ukupno 8.



-- 5. zadatak

SELECT home_team, away_team, weather
FROM bootcamp.northern_star.matches_flat
WHERE season = '2023/24' AND (weather = 'snow' OR weather = 'fog')
ORDER BY weather;

-- ili sa COUNT

SELECT COUNT(*)
FROM bootcamp.northern_star.matches_flat
WHERE season = '2023/24' AND (weather = 'snow' OR weather = 'fog');

-- 25 utakmica je odigrano po snegu ili magli u sezoni 2023/24.



-- 6. zadatak

SELECT home_team, away_team, home_goals, away_goals, kickoff_ts, stadium_name
FROM bootcamp.northern_star.matches_flat
WHERE (home_team = 'Northport United' AND away_team = 'Northport City')
        OR (home_team = 'Northport City' AND away_team = 'Northport United')
ORDER BY kickoff_ts;

-- Northport United je pobijedio u prvom susretu 11. novembra 2023. godine;
-- Zatim je bilo neriješeno 16. marta 2024. godine;
-- 21. septembra 2024. godine Northport City napokon pobjeđuje;
-- I u zadnjem susretu 1. februara 2025. godine Northport United po drugi odnosi pobjedu.



-- 7. zadatak

SELECT match_id, home_team, away_team, kickoff_ts
FROM bootcamp.northern_star.matches_flat
WHERE season = '2024/25'
ORDER BY kickoff_ts, match_id
LIMIT 3;

-- ili

SELECT match_id, home_team, away_team, kickoff_ts
FROM bootcamp.northern_star.matches_flat
WHERE season = '2024/25'
ORDER BY kickoff_ts, home_team
LIMIT 3;

-- Ne možemo biti 100% sigurni, na osnovu timestampa, koja je utakmica zapravo krenula prva , ali ukoliko ubacimo drugi kriterijum za sortiranje, kao npr. match_id, možemo dobiti rezultat u upitu koja je utakmica bila upisana prije u raspored odigravanja ili možda da pratimo abecednim rasporedom naziva domaćih timova.



-- 8. zadatak

SELECT home_team, away_team, home_goals, away_goals, first_goal_scorer
FROM bootcamp.northern_star.matches_flat
WHERE first_goal_scorer = "Sean O'Neill";

-- ili sa COUNT

SELECT COUNT(*)
FROM bootcamp.northern_star.matches_flat
WHERE first_goal_scorer = "Sean O'Neill";

-- Sean O'Neill je postigao prvi gol na 2 utakmice.
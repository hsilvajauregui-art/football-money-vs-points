-- 01_puntos.sql
-- Points, goals for and goals against per club and season
CREATE OR REPLACE TABLE `Caso_de_estudio.puntos` AS
SELECT g.season, g.competition_id, cg.club_id,
       COUNT(*) AS partidos,
       SUM(CASE WHEN cg.own_goals > cg.opponent_goals THEN 3
                WHEN cg.own_goals = cg.opponent_goals THEN 1
                ELSE 0 END) AS puntos,
       SUM(cg.own_goals) AS goles_favor,
       SUM(cg.opponent_goals) AS goles_contra
FROM `Caso_de_estudio.club_games` cg
JOIN `Caso_de_estudio.Games` g ON g.game_id = cg.game_id
WHERE g.competition_id IN ('GB1','ES1','IT1','L1','FR1')
  AND g.season BETWEEN 2015 AND 2024
  AND cg.own_goals IS NOT NULL
GROUP BY 1, 2, 3;

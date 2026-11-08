-- 02_valor_plantilla.sql
-- Squad value at the start of each season: sum of each player's latest
-- valuation before September 1, for every player who appeared for the club
CREATE OR REPLACE TABLE `Caso_de_estudio.valor_plantilla` AS
WITH plantilla AS (
  SELECT DISTINCT g.season, a.player_club_id AS club_id, a.player_id
  FROM `Caso_de_estudio.appearances_drive` a
  JOIN `Caso_de_estudio.Games` g ON g.game_id = a.game_id
  WHERE g.competition_id IN ('GB1','ES1','IT1','L1','FR1')
    AND g.season BETWEEN 2015 AND 2024
),
valor AS (
  SELECT p.season, p.club_id, p.player_id, v.market_value_in_eur
  FROM plantilla p
  JOIN `Caso_de_estudio.Player_valuations` v
    ON v.player_id = p.player_id
   AND v.date <= DATE(p.season, 9, 1)
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY p.season, p.club_id, p.player_id
    ORDER BY v.date DESC) = 1
)
SELECT season, club_id,
       SUM(market_value_in_eur) AS valor_plantilla_eur,
       COUNT(*) AS jugadores_valorados
FROM valor
GROUP BY 1, 2;

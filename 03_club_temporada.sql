-- 03_club_temporada.sql
-- Final analysis table: one row per club-season with points per game
-- and relative value (squad value / league average that season)
CREATE OR REPLACE TABLE `Caso_de_estudio.club_temporada` AS
SELECT p.season, p.competition_id, p.club_id, c.name AS club,
       p.partidos, p.puntos,
       ROUND(p.puntos / p.partidos, 2) AS puntos_por_partido,
       v.valor_plantilla_eur, v.jugadores_valorados,
       ROUND(v.valor_plantilla_eur /
         AVG(v.valor_plantilla_eur) OVER (PARTITION BY p.season, p.competition_id), 2) AS valor_relativo
FROM `Caso_de_estudio.puntos` p
JOIN `Caso_de_estudio.valor_plantilla` v USING (season, club_id)
JOIN `Caso_de_estudio.clubs` c ON c.club_id = p.club_id;

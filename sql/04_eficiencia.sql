-- 04_eficiencia.sql
-- Expected points: simple linear regression of PPG on ln(relative value)
-- Result: Expected PPG = 0.4386 * ln(relative value) + 1.518  (R^2 = 0.571)
CREATE OR REPLACE TABLE `Caso_de_estudio.eficiencia` AS
WITH base AS (
  SELECT *, LN(valor_relativo) AS x
  FROM `Caso_de_estudio.club_temporada`
),
modelo AS (
  SELECT
    COVAR_SAMP(x, puntos_por_partido) / VAR_SAMP(x) AS pendiente,
    AVG(puntos_por_partido) - COVAR_SAMP(x, puntos_por_partido) / VAR_SAMP(x) * AVG(x) AS intercepto
  FROM base
)
SELECT b.season, b.competition_id, b.club, b.partidos, b.puntos,
       b.puntos_por_partido, b.valor_plantilla_eur, b.valor_relativo,
       ROUND(m.intercepto + m.pendiente * b.x, 2) AS ppp_esperado,
       ROUND(b.puntos_por_partido - (m.intercepto + m.pendiente * b.x), 2) AS ppp_sobre_esperado,
       ROUND((b.puntos_por_partido - (m.intercepto + m.pendiente * b.x)) * b.partidos, 1) AS puntos_sobre_esperado
FROM base b CROSS JOIN modelo m;

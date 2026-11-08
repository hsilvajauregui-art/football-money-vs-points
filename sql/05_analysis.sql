-- 05_analysis.sql
-- Descriptive statistics, correlations and efficiency rankings

-- 1. Descriptive statistics by league
SELECT competition_id,
       COUNT(*) AS club_temporadas,
       ROUND(AVG(valor_plantilla_eur) / 1e6, 1) AS valor_promedio_millones,
       ROUND(MIN(valor_plantilla_eur) / 1e6, 1) AS valor_min_millones,
       ROUND(MAX(valor_plantilla_eur) / 1e6, 1) AS valor_max_millones,
       ROUND(AVG(puntos_por_partido), 2) AS ppp_promedio
FROM `Caso_de_estudio.club_temporada`
GROUP BY 1
ORDER BY valor_promedio_millones DESC;

-- 2. Correlation between money and points (overall: 0.75)
SELECT competition_id,
       ROUND(CORR(valor_relativo, puntos_por_partido), 2) AS correlacion
FROM `Caso_de_estudio.club_temporada`
GROUP BY 1
UNION ALL
SELECT 'TODAS', ROUND(CORR(valor_relativo, puntos_por_partido), 2)
FROM `Caso_de_estudio.club_temporada`
ORDER BY correlacion DESC;

-- 3. Plain vs. log correlation by league
SELECT competition_id,
       ROUND(CORR(valor_relativo, puntos_por_partido), 2) AS corr_normal,
       ROUND(CORR(LN(valor_relativo), puntos_por_partido), 2) AS corr_log
FROM `Caso_de_estudio.club_temporada`
GROUP BY 1
ORDER BY 1;

-- 4. Efficiency ranking (clubs with 5+ seasons)
SELECT club, competition_id,
       COUNT(*) AS temporadas,
       ROUND(SUM(puntos_sobre_esperado), 1) AS puntos_extra_totales,
       ROUND(AVG(puntos_sobre_esperado), 1) AS puntos_extra_por_temporada,
       COUNTIF(puntos_sobre_esperado > 0) AS temporadas_arriba
FROM `Caso_de_estudio.eficiencia`
GROUP BY 1, 2
HAVING COUNT(*) >= 5
ORDER BY puntos_extra_por_temporada DESC;

-- 5. Efficient clubs on a low budget (average relative value < 1)
SELECT club, competition_id,
       COUNT(*) AS temporadas,
       ROUND(AVG(valor_relativo), 2) AS valor_relativo_promedio,
       ROUND(AVG(puntos_sobre_esperado), 1) AS puntos_extra_por_temporada,
       COUNTIF(puntos_sobre_esperado > 0) AS temporadas_arriba
FROM `Caso_de_estudio.eficiencia`
GROUP BY 1, 2
HAVING COUNT(*) >= 5 AND AVG(valor_relativo) < 1
ORDER BY puntos_extra_por_temporada DESC
LIMIT 15;

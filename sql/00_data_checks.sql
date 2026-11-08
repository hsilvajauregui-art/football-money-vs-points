-- 00_data_checks.sql
-- Data quality checks run before the analysis (BigQuery, dataset Caso_de_estudio)

-- 1. Row count per table
SELECT 'Games' AS tabla, COUNT(*) AS filas FROM `Caso_de_estudio.Games`
UNION ALL SELECT 'club_games', COUNT(*) FROM `Caso_de_estudio.club_games`
UNION ALL SELECT 'clubs', COUNT(*) FROM `Caso_de_estudio.clubs`
UNION ALL SELECT 'appearances', COUNT(*) FROM `Caso_de_estudio.appearances_drive`
UNION ALL SELECT 'Player_valuations', COUNT(*) FROM `Caso_de_estudio.Player_valuations`
UNION ALL SELECT 'Transfers', COUNT(*) FROM `Caso_de_estudio.Transfers`;
-- Result: club_games (177,916) = 2 x Games (88,958) -> each game appears once per club.

-- 2. Column names and data types
SELECT table_name, column_name, data_type
FROM `Caso_de_estudio.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN ('Games', 'club_games', 'appearances_drive', 'Player_valuations', 'clubs')
ORDER BY table_name, ordinal_position;

-- 3. Coverage by league and season (duplicates and missing goals)
SELECT competition_id, season,
       COUNT(*) AS partidos,
       COUNT(DISTINCT game_id) AS partidos_unicos,
       COUNTIF(home_club_goals IS NULL OR away_club_goals IS NULL) AS sin_goles
FROM `Caso_de_estudio.Games`
WHERE competition_id IN ('GB1','ES1','IT1','L1','FR1')
  AND season BETWEEN 2015 AND 2024
GROUP BY 1, 2
ORDER BY 1, 2;

-- 4. Row counts of the built tables (run after 01-03)
SELECT
  (SELECT COUNT(*) FROM `Caso_de_estudio.puntos`) AS filas_puntos,
  (SELECT COUNT(*) FROM `Caso_de_estudio.valor_plantilla`) AS filas_valor,
  (SELECT COUNT(*) FROM `Caso_de_estudio.club_temporada`) AS filas_final;
-- Result: 976 / 976 / 976 -> no rows lost in the joins.

-- 5. Squads with the fewest valued players
SELECT season, competition_id, club, partidos, jugadores_valorados, valor_plantilla_eur
FROM `Caso_de_estudio.club_temporada`
ORDER BY jugadores_valorados
LIMIT 10;
-- Result: minimum 20 players -> no club excluded.

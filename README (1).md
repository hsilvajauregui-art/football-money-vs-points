# Does Money Buy Points in Football?

**Squad market value explains 57% of the differences in points between clubs in Europe's top five leagues — and 15 low-budget clubs consistently beat the odds.**

Capstone case study for the **Google Data Analytics Professional Certificate**, by Héctor Silva.

| | |
| --- | --- |
| **Interactive dashboard** | [Tableau Public](https://public.tableau.com/views/Casodeestudiofutbol/Dashboard1) (labels in Spanish) |
| **Tools** | BigQuery (SQL) · Google Sheets · Tableau Public |
| **Data** | [Football Data from Transfermarkt (Kaggle)](https://www.kaggle.com/datasets/davidcariboo/player-scores) |
| **Scope** | Premier League, LaLiga, Serie A, Bundesliga, Ligue 1 · seasons 2015/16–2024/25 · 976 club-seasons |

---

## 1. Ask — the business task

A mid-budget club wants to compete better without spending like the giants.

> Analyze the relationship between squad market value and league points in Europe's top five leagues (2015/16–2024/25), measure how strong it is, and identify which clubs earn more points than their investment predicts.

**Stakeholders:** sporting director, CFO and club president.

## 2. Prepare — the data

| Table | Rows | Use |
| --- | --- | --- |
| appearances | 1,894,350 | Who played for each club each season |
| Player_valuations | 656,301 | Market value history per player |
| club_games | 177,916 | Goals for and against, per club and game |
| Games | 88,958 | League, season and result of each game |
| clubs | 796 | Club names |

**ROCCC:** Reliable (medium — values are Transfermarkt estimates) · Original (low — secondary source) · Comprehensive, Current and Cited (high).

**Limitations:** market value is not the wage bill; salaries are rarely public.

## 3. Process — cleaning

1. Loaded all CSVs into BigQuery. `appearances` exceeded the 100 MB local upload limit and was loaded from Google Drive.
2. Verified row counts: `club_games` has exactly 2 × the rows of `Games` (each game appears once per club).
3. Filtered to the 5 leagues and 10 seasons; excluded games without recorded goals.
4. Built intermediate tables `puntos` (points) and `valor_plantilla` (squad value at September 1).
5. Joined them into `club_temporada`: **976 rows, matching reality exactly** (200 club-seasons in the Premier League, LaLiga and Serie A; 180 in the Bundesliga; 196 in Ligue 1, which dropped to 18 teams in 2023).

Every step is documented in the [cleaning log](https://docs.google.com/spreadsheets/d/1lWjV95FSG5tvXc6vgEIk933qyKgVVPxiXuMKO8j0JO0/edit) (Spanish).

## 4. Analyze — method

- **Relative value** = squad value ÷ league average that season (removes inflation and league size).
- **Points per game (PPG)** to compare 34- and 38-game seasons.
- **Expected PPG** from a simple linear regression computed in SQL and validated in Tableau (R² = 0.571, p < 0.0001):

```
Expected PPG = 0.4386 × ln(relative value) + 1.518
```

- **Points above expected** = (actual PPG − expected PPG) × games.

## 5. Share — key findings

1. **Money explains 57% of the differences in points.** Doubling squad value ≈ **+11.5 points per season**.
2. **It depends on the league:** money explains 71% of points in Serie A but only 49% in the Bundesliga.
3. **The Premier League nearly tripled** its average squad value (€213M → €606M) since 2015; the other leagues stalled after 2019.
4. **15 low-budget clubs consistently overperform.** RC Lens: +14.4 points per season above expected, in 5 of 5 seasons. SD Eibar: +9.1 with a squad worth only 27% of its league average.

| Most efficient (low budget) | Pts above expected / season | Least efficient | Pts above expected / season |
| --- | --- | --- | --- |
| RC Lens | +14.4 | FC Schalke 04 | −11.5 |
| 1.FC Union Berlin | +10.7 | Southampton FC | −10.7 |
| Girona FC | +9.2 | Valencia CF | −9.5 |
| SD Eibar | +9.1 | Genoa CFC | −8.2 |
| Stade Brestois 29 | +7.5 | Everton FC | −7.5 |

## 6. Act — recommendations

1. Use **expected points** as a realistic target to set goals and evaluate staff.
2. Study the model of efficient clubs (Lens, Union Berlin, Freiburg, Eibar).
3. Judge every signing by **performance per euro**, not by price.

**Further analysis:** coaching stability (`own_manager_name`), real wages, transfer ROI, squad age, survivorship bias from relegated clubs, other leagues such as Liga MX.

**Caveat:** this shows association, not causation.

---

## Repository structure

```
├── README.md
├── sql/
│   ├── 00_data_checks.sql        # row counts, schema, coverage
│   ├── 01_puntos.sql             # points per club-season
│   ├── 02_valor_plantilla.sql    # squad value at season start
│   ├── 03_club_temporada.sql     # final table + relative value
│   ├── 04_eficiencia.sql         # expected points (regression)
│   └── 05_analysis.sql           # descriptives, correlations, rankings
├── data/
│   └── README.md                 # where to place eficiencia_v1.csv
└── docs/
    └── links.md                  # dashboard, reports, cleaning log
```

Table and column names are in Spanish: `puntos` = points, `valor_plantilla` = squad value, `club_temporada` = club-season, `eficiencia` = efficiency, `partidos` = games.

## Contact

Héctor Silva · Ciudad Juárez, Mexico · [LinkedIn](#) <!-- add your LinkedIn URL -->

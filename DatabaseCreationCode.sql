cd /Users/GilbertJ/Documents/eLife_stats

cat "ejp_query_tool_query_id_209_SQL_Initial_2014_05_30_eLife.csv" | sed "1,4 d" | sed "s/\"//g" > initial.csv
cat "ejp_query_tool_query_id_210_SQL_Full_2014_05_30_eLife.csv" | sed "1,4 d" | sed "s/\"//g" > full.csv
cat "ejp_query_tool_query_id_211_SQL_Rev1_2014_05_30_eLife.csv" | sed "1,4 d" | sed "s/\"//g" > rev1.csv
cat "ejp_query_tool_query_id_212_SQL_Rev2_2014_05_30_eLife.csv" | sed "1,4 d" | sed "s/\"//g" > rev2.csv
cat "ejp_query_tool_query_id_213_SQL_Rev3_2014_05_30_eLife.csv" | sed "1,4 d" | sed "s/\"//g" > rev3.csv

sqlite3 paper_stats_test3.sqlite

.mode csv
.separator ","


CREATE TABLE "initial" ("ms" INTEGER PRIMARY KEY,"initial_qc_dt" DATETIME,"initial_decision" TEXT,"initial_decision_dt" DATETIME);
CREATE TABLE "full" ("ms" INTEGER PRIMARY KEY,"full_qc_dt" DATETIME,"full_decision" TEXT,"full_decision_dt" DATETIME);
CREATE TABLE "rev1" ("ms" INTEGER PRIMARY KEY,"rev1_qc_dt" DATETIME,"rev1_decision" TEXT,"rev1_decision_dt" DATETIME);
CREATE TABLE "rev2" ("ms" INTEGER PRIMARY KEY,"rev2_qc_dt" DATETIME,"rev2_decision" TEXT,"rev2_decision_dt" DATETIME);
CREATE TABLE "rev3" ("ms" INTEGER PRIMARY KEY,"rev3_qc_dt" DATETIME,"rev3_decision" TEXT,"rev3_decision_dt" DATETIME);
CREATE TABLE "rev4" ("ms" INTEGER PRIMARY KEY,"rev4_qc_dt" DATETIME,"rev4_decision" TEXT,"rev4_decision_dt" DATETIME);
CREATE TABLE "published" ("ms" INTEGER PRIMARY KEY,"poa_dt" DATETIME,"vor_dt" DATETIME);
CREATE TABLE "type" ("ms" INTEGER PRIMARY KEY,"type" INTEGER);

.import initial.csv initial
.import full.csv full
.import rev1.csv rev1
.import rev2.csv rev2
.import rev3.csv rev3
.import published.csv published

.header on
.mode csv
.output paper_history.csv


SELECT i.ms,i.initial_qc_dt,i.initial_decision,i.initial_decision_dt,
f.full_qc_dt,f.full_decision,f.full_decision_dt,
r1.rev1_qc_dt,r1.rev1_decision,r1.rev1_decision_dt,
r2.rev2_qc_dt,r2.rev2_decision,r2.rev2_decision_dt,
r3.rev3_qc_dt,r3.rev3_decision,r3.rev3_decision_dt,
p.poa_dt,p.vor_dt

FROM initial i

LEFT JOIN full f
ON i.ms=f.ms

LEFT JOIN rev1 r1
ON i.ms=r1.ms

LEFT JOIN rev2 r2
ON i.ms=r2.ms

LEFT JOIN rev3 r3
ON i.ms=r3.ms

LEFT JOIN published p
ON i.ms=p.ms

ORDER BY i.ms;

.quit

exit

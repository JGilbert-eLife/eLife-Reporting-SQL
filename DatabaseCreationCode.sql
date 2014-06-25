cd /Users/GilbertJ/Documents/eLife_stats


sqlite3 elife_paper_stats.sqlite

CREATE TABLE "initial_import" ("ms" INTEGER PRIMARY KEY,"initial_qc_dt" DATETIME,"initial_decision" TEXT,"initial_decision_dt" DATETIME);
CREATE TABLE "full_import" ("ms" INTEGER PRIMARY KEY,"full_qc_dt" DATETIME,"full_decision" TEXT,"full_decision_dt" DATETIME);
CREATE TABLE "rev1_import" ("ms" INTEGER PRIMARY KEY,"rev1_qc_dt" DATETIME,"rev1_decision" TEXT,"rev1_decision_dt" DATETIME);
CREATE TABLE "rev2_import" ("ms" INTEGER PRIMARY KEY,"rev2_qc_dt" DATETIME,"rev2_decision" TEXT,"rev2_decision_dt" DATETIME);
CREATE TABLE "rev3_import" ("ms" INTEGER PRIMARY KEY,"rev3_qc_dt" DATETIME,"rev3_decision" TEXT,"rev3_decision_dt" DATETIME);
CREATE TABLE "rev4_import" ("ms" INTEGER PRIMARY KEY,"rev4_qc_dt" DATETIME,"rev4_decision" TEXT,"rev4_decision_dt" DATETIME);
CREATE TABLE "published_import" ("ms" INTEGER PRIMARY KEY,"poa_dt" DATETIME,"vor_dt" DATETIME);
CREATE TABLE "type_import" ("ms" INTEGER PRIMARY KEY,"type" INTEGER);

CREATE TABLE "initial" ("ms" INTEGER PRIMARY KEY,"initial_qc_dt" DATETIME,"initial_decision" TEXT,"initial_decision_dt" DATETIME);
CREATE TABLE "full" ("ms" INTEGER PRIMARY KEY,"full_qc_dt" DATETIME,"full_decision" TEXT,"full_decision_dt" DATETIME);
CREATE TABLE "rev1" ("ms" INTEGER PRIMARY KEY,"rev1_qc_dt" DATETIME,"rev1_decision" TEXT,"rev1_decision_dt" DATETIME);
CREATE TABLE "rev2" ("ms" INTEGER PRIMARY KEY,"rev2_qc_dt" DATETIME,"rev2_decision" TEXT,"rev2_decision_dt" DATETIME);
CREATE TABLE "rev3" ("ms" INTEGER PRIMARY KEY,"rev3_qc_dt" DATETIME,"rev3_decision" TEXT,"rev3_decision_dt" DATETIME);
CREATE TABLE "rev4" ("ms" INTEGER PRIMARY KEY,"rev4_qc_dt" DATETIME,"rev4_decision" TEXT,"rev4_decision_dt" DATETIME);
CREATE TABLE "published" ("ms" INTEGER PRIMARY KEY,"poa_dt" DATETIME,"vor_dt" DATETIME);
CREATE TABLE "type" ("ms" INTEGER PRIMARY KEY,"type" INTEGER);

.quit

exit

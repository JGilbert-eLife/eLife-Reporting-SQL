#!/bin/bash

#Script to create eLife history database
#Requires SQLite

echo "CREATE TABLE "initial_import" ("ms" INTEGER PRIMARY KEY,"initial_qc_dt" DATETIME,"initial_decision" TEXT,"initial_decision_dt" DATETIME);" > /tmp/sql.cmds #
echo "CREATE TABLE "full_import" ("ms" INTEGER PRIMARY KEY,"full_qc_dt" DATETIME,"full_decision" TEXT,"full_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "rev1_import" ("ms" INTEGER PRIMARY KEY,"rev1_qc_dt" DATETIME,"rev1_decision" TEXT,"rev1_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "rev2_import" ("ms" INTEGER PRIMARY KEY,"rev2_qc_dt" DATETIME,"rev2_decision" TEXT,"rev2_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "rev3_import" ("ms" INTEGER PRIMARY KEY,"rev3_qc_dt" DATETIME,"rev3_decision" TEXT,"rev3_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "rev4_import" ("ms" INTEGER PRIMARY KEY,"rev4_qc_dt" DATETIME,"rev4_decision" TEXT,"rev4_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "published_import" ("ms" INTEGER PRIMARY KEY,"poa_dt" DATETIME,"vor_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "type_import" ("ms" INTEGER PRIMARY KEY,"type" INTEGER);" >> /tmp/sql.cmds #

echo "CREATE TABLE "initial" ("ms" INTEGER PRIMARY KEY,"initial_qc_dt" DATETIME,"initial_decision" TEXT,"initial_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "full" ("ms" INTEGER PRIMARY KEY,"full_qc_dt" DATETIME,"full_decision" TEXT,"full_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "rev1" ("ms" INTEGER PRIMARY KEY,"rev1_qc_dt" DATETIME,"rev1_decision" TEXT,"rev1_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "rev2" ("ms" INTEGER PRIMARY KEY,"rev2_qc_dt" DATETIME,"rev2_decision" TEXT,"rev2_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "rev3" ("ms" INTEGER PRIMARY KEY,"rev3_qc_dt" DATETIME,"rev3_decision" TEXT,"rev3_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "rev4" ("ms" INTEGER PRIMARY KEY,"rev4_qc_dt" DATETIME,"rev4_decision" TEXT,"rev4_decision_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "published" ("ms" INTEGER PRIMARY KEY,"poa_dt" DATETIME,"vor_dt" DATETIME);" >> /tmp/sql.cmds #
echo "CREATE TABLE "type" ("ms" INTEGER PRIMARY KEY,"type" INTEGER);" >> /tmp/sql.cmds #

# Pipe SQL command file to SQLite and command SQLite to open database

cat /tmp/sql.cmds | sqlite3 elife_paper_stats.sqlite

# Remove SQL command file

rm /tmp/sql.cmds
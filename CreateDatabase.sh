#!/bin/bash

#Script to create eLife history database
#Requires SQLite

#Create import tables

echo "CREATE TABLE "initial_import" ("ms" INTEGER PRIMARY KEY,"initial_qc_dt" DATE,"initial_decision" TEXT,"initial_decision_dt" DATE,"appeal" INTEGER, "appeal_dt" DATE);" > /tmp/sql.cmds
echo "CREATE TABLE "full_import" ("ms" INTEGER PRIMARY KEY,"full_qc_dt" DATE,"full_decision" TEXT,"full_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "rev1_import" ("ms" INTEGER PRIMARY KEY,"rev1_qc_dt" DATE,"rev1_decision" TEXT,"rev1_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "rev2_import" ("ms" INTEGER PRIMARY KEY,"rev2_qc_dt" DATE,"rev2_decision" TEXT,"rev2_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "rev3_import" ("ms" INTEGER PRIMARY KEY,"rev3_qc_dt" DATE,"rev3_decision" TEXT,"rev3_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "rev4_import" ("ms" INTEGER PRIMARY KEY,"rev4_qc_dt" DATE,"rev4_decision" TEXT,"rev4_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "senior_editor_import_1" ("ms" INTEGER PRIMARY KEY,"senior_editor" INTEGER,"se_assign_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "senior_editor_import_2" ("ms" INTEGER PRIMARY KEY,"senior_editor" INTEGER,"se_assign_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "senior_editor_import_3" ("ms" INTEGER PRIMARY KEY,"senior_editor" INTEGER,"se_assign_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "reviewing_editor_import" ("ms" INTEGER PRIMARY KEY,"reviewing_editor" INTEGER,"re_assign_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "published_import" ("ms" INTEGER PRIMARY KEY,"poa_dt" DATE,"vor_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "type_import" ("ms" INTEGER PRIMARY KEY,"type" TEXT);" >> /tmp/sql.cmds
echo "CREATE TABLE "type_import_full" ("ms" INTEGER PRIMARY KEY,"type" TEXT);" >> /tmp/sql.cmds
echo "CREATE TABLE "type_import_rev1" ("ms" INTEGER PRIMARY KEY,"type" TEXT);" >> /tmp/sql.cmds
echo "CREATE TABLE "type_import_rev2" ("ms" INTEGER PRIMARY KEY,"type" TEXT);" >> /tmp/sql.cmds
echo "CREATE TABLE "type_import_rev3" ("ms" INTEGER PRIMARY KEY,"type" TEXT);" >> /tmp/sql.cmds
echo "CREATE TABLE "country_import" ("ms" INTEGER PRIMARY KEY,"country" TEXT);" >> /tmp/sql.cmds
echo "CREATE TABLE "country_import_full" ("ms" INTEGER PRIMARY KEY,"country" TEXT);" >> /tmp/sql.cmds
echo "CREATE TABLE "country_import_other" ("ms" INTEGER PRIMARY KEY,"country" TEXT);" >> /tmp/sql.cmds


#Create main tables

echo "CREATE TABLE "initial" ("ms" INTEGER PRIMARY KEY,"initial_qc_dt" DATE,"initial_decision" TEXT,"initial_decision_dt" DATE,"appeal" INTEGER, "appeal_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "full" ("ms" INTEGER PRIMARY KEY,"full_qc_dt" DATE,"full_decision" TEXT,"full_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "rev1" ("ms" INTEGER PRIMARY KEY,"rev1_qc_dt" DATE,"rev1_decision" TEXT,"rev1_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "rev2" ("ms" INTEGER PRIMARY KEY,"rev2_qc_dt" DATE,"rev2_decision" TEXT,"rev2_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "rev3" ("ms" INTEGER PRIMARY KEY,"rev3_qc_dt" DATE,"rev3_decision" TEXT,"rev3_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "rev4" ("ms" INTEGER PRIMARY KEY,"rev4_qc_dt" DATE,"rev4_decision" TEXT,"rev4_decision_dt" DATE,"appeal" INTEGER);" >> /tmp/sql.cmds
echo "CREATE TABLE "senior_editor" ("ms" INTEGER PRIMARY KEY,"senior_editor" INTEGER,"se_assign_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "reviewing_editor" ("ms" INTEGER PRIMARY KEY,"reviewing_editor" INTEGER,"re_assign_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "published" ("ms" INTEGER PRIMARY KEY,"poa_dt" DATE,"vor_dt" DATE);" >> /tmp/sql.cmds
echo "CREATE TABLE "type" ("ms" INTEGER PRIMARY KEY,"type" TEXT);" >> /tmp/sql.cmds
echo "CREATE TABLE "country" ("ms" INTEGER PRIMARY KEY,"country" TEXT);" >> /tmp/sql.cmds


# Pipe SQL command file to SQLite and command SQLite to open database

cat /tmp/sql.cmds | sqlite3 elife_paper_stats.sqlite

# Remove SQL command file

rm /tmp/sql.cmds
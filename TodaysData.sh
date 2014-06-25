#!/bin/bash

# Script to import eLife data into SQLite database
# Requires data downloaded from eLife submission database
# For use generating monthly stats
# Note: terminal must be pointed to correct directory before running this script
# issue: cd ~/eLife_stats before summoning script to change to correct directory
# issue: sh Todaysdata.sh to run script

# Get today's date

tday=`date +%Y_%m_%d`

# Generate SQL/SQLite commands to import data
# Commands stored in 'sql.cmds' file

echo ".separator \",\"" > /tmp/sql.cmds #

# Generate input .csv files for required tables if corresponding EJP output file is present
# Add SQL commands to clear import tables, import data into import tables, and move table to main tables, if present
# If EJP output files for today are not present, do nothing

#Initial Submission data

if [ -e ejp_query_tool_query_id_209_SQL_Initial_${tday}_eLife.csv ]; then
initialinput="ejp_query_tool_query_id_209_SQL_Initial_${tday}_eLife.csv"
egrep "^\"[[:digit:]]*\"," $initialinput > initial_tmp.csv
tr -d "\"" < initial_tmp.csv > initial.csv
rm initial_tmp.csv
echo "delete from initial_import;">> /tmp/sql.cmds #
echo ".import initial.csv initial_import">> /tmp/sql.cmds #
echo "insert into initial select * from initial_import where initial_import.ms not in (select ms from initial);">> /tmp/sql.cmds #
else :
fi

#Full Submission data

if [ -e ejp_query_tool_query_id_210_SQL_Full_${tday}_eLife.csv ]; then
fullinput="ejp_query_tool_query_id_210_SQL_Full_${tday}_eLife.csv"
egrep "^\"[[:digit:]]*\"," $fullinput > full_tmp.csv
tr -d "\"" < full_tmp.csv > full.csv
rm full_tmp.csv
echo "delete from full_import;">> /tmp/sql.cmds #
echo ".import full.csv full_import">> /tmp/sql.cmds #
echo "insert into full select * from full_import where full_import.ms not in (select ms from full);">> /tmp/sql.cmds #
else :
fi

#Rev1 Submission data

if [ -e ejp_query_tool_query_id_211_SQL_Rev1_${tday}_eLife.csv ]; then
rev1input="ejp_query_tool_query_id_211_SQL_Rev1_${tday}_eLife.csv"
egrep "^\"[[:digit:]]*\"," $rev1input > rev1_tmp.csv
tr -d "\"" < rev1_tmp.csv > rev1.csv
rm rev1_tmp.csv
echo "delete from rev1_import;">> /tmp/sql.cmds #
echo ".import rev1.csv rev1_import">> /tmp/sql.cmds #
echo "insert into rev1 select * from rev1_import where rev1_import.ms not in (select ms from rev1);">> /tmp/sql.cmds #
else :
fi

#Rev2 Submission data

if [ -e ejp_query_tool_query_id_212_SQL_Rev2_${tday}_eLife.csv ]; then
rev2input="ejp_query_tool_query_id_212_SQL_Rev2_${tday}_eLife.csv"
egrep "^\"[[:digit:]]*\"," $rev2input > rev2_tmp.csv
tr -d "\"" < rev2_tmp.csv > rev2.csv
rm rev2_tmp.csv
echo "delete from rev2_import;">> /tmp/sql.cmds #
echo ".import rev2.csv rev2_import">> /tmp/sql.cmds #
echo "insert into rev2 select * from rev2_import where rev2_import.ms not in (select ms from rev2);">> /tmp/sql.cmds #
else :
fi

#Rev3 Submission data

if [ -e ejp_query_tool_query_id_213_SQL_Rev3_${tday}_eLife.csv ]; then
rev3input="ejp_query_tool_query_id_213_SQL_Rev3_${tday}_eLife.csv"
egrep "^\"[[:digit:]]*\"," $rev3input > rev3_tmp.csv
tr -d "\"" < rev3_tmp.csv > rev3.csv
rm rev3_tmp.csv
echo "delete from rev3_import;">> /tmp/sql.cmds #
echo ".import rev3.csv rev3_import">> /tmp/sql.cmds #
echo "insert into rev3 select * from rev3_import where rev3_import.ms not in (select ms from rev3);">> /tmp/sql.cmds #
else :
fi

#Rev4 Submission data

if [ -e ejp_query_tool_query_id_214_SQL_Rev4_${tday}_eLife.csv ]; then
rev4input="ejp_query_tool_query_id_214_SQL_Rev4_${tday}_eLife.csv"
egrep "^\"[[:digit:]]*\"," $rev4input > rev4_tmp.csv
tr -d "\"" < rev4_tmp.csv > rev4.csv
rm rev4_tmp.csv
echo "delete from rev4_import;">> /tmp/sql.cmds #
echo ".import rev4.csv rev4_import">> /tmp/sql.cmds #
echo "insert into rev4 select * from rev4_import where rev4_import.ms not in (select ms from rev4);">> /tmp/sql.cmds #
else :
fi

#Publication date data

if [ -e published.csv ]; then
echo "delete from published_import;">> /tmp/sql.cmds #
echo ".import published.csv published_import">> /tmp/sql.cmds #
echo "insert into published select * from published_import where published_import.ms not in (select ms from published);">> /tmp/sql.cmds #
else :
fi

# Pipe SQL command file to SQLite and command SQLite to open database

cat /tmp/sql.cmds | sqlite3 elife_paper_stats.sqlite

# Remove SQL command file

rm /tmp/sql.cmds
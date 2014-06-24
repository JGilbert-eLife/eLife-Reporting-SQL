#!/bin/bash

tday=`date +%Y_%m_%d`

initialinput="ejp_query_tool_query_id_209_SQL_Initial_${tday}_eLife.csv"
fullinput="ejp_query_tool_query_id_210_SQL_Full_${tday}_eLife.csv"
rev1input="ejp_query_tool_query_id_211_SQL_Rev1_${tday}_eLife.csv"
rev2input="ejp_query_tool_query_id_212_SQL_Rev2_${tday}_eLife.csv"
rev3input="ejp_query_tool_query_id_213_SQL_Rev3_${tday}_eLife.csv"

egrep "^\"[[:digit:]]*\"," $initialinput > initial_tmp.csv
egrep "^\"[[:digit:]]*\"," $fullinput > full_tmp.csv
egrep "^\"[[:digit:]]*\"," $rev1input > rev1_tmp.csv
egrep "^\"[[:digit:]]*\"," $rev2input > rev2_tmp.csv
egrep "^\"[[:digit:]]*\"," $rev3input > rev3_tmp.csv

tr -d "\"" < initial_tmp.csv > initial.csv
tr -d "\"" < full_tmp.csv > full.csv
tr -d "\"" < rev1_tmp.csv > rev1.csv
tr -d "\"" < rev2_tmp.csv > rev2.csv
tr -d "\"" < rev3_tmp.csv > rev3.csv

rm initial_tmp.csv
rm full_tmp.csv
rm rev1_tmp.csv
rm rev2_tmp.csv
rm rev3_tmp.csv

echo ".separator \",\"" > /tmp/sql.cmds #

echo "delete from initial_import,full_import,rev1_import,rev2_import,rev3_import;">> /tmp/sql.cmds #

echo ".import full.csv full_import">> /tmp/sql.cmds #

echo "insert into full select * from full_import where full_import.ms not in (select ms from full);">> /tmp/sql.cmds #

cat /tmp/sql.cmds | sqlite3 paper_stats_test3.sqlite

rm /tmp/sql.cmds
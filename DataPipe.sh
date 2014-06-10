#!/bin/bash

egrep "^\"[[:digit:]]*\"," ejp_query_tool_query_id_210_SQL_Full_2014_05_30_eLife.csv > full_tmp.csv

tr -d "\"" < full_tmp.csv > full.csv

rm full_tmp.csv

echo ".separator \",\"" > /tmp/sql.cmds #

echo "delete from full;">> /tmp/sql.cmds #

echo ".import full.csv full">> /tmp/sql.cmds #

cat /tmp/sql.cmds | sqlite3 paper_stats_test3.sqlite

rm /tmp/sql.cmds
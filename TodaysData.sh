#!/bin/bash

# Script to import eLife data into SQLite database
# Requires data downloaded from eLife submission database
# For use generating monthly stats
# Note: terminal must be pointed to correct directory before running this script
# issue: cd ~/eLife_stats before summoning script to change to correct directory
# issue: sh Todaysdata.sh to run script

# Get today's date

tday=`date +%Y_%m_%d`

# Define variables containing today's query rest file names

initialinput="ejp_query_tool_query_id_209_SQL_Initial_${tday}_eLife.csv"
fullinput="ejp_query_tool_query_id_210_SQL_Full_${tday}_eLife.csv"
rev1input="ejp_query_tool_query_id_211_SQL_Rev1_${tday}_eLife.csv"
rev2input="ejp_query_tool_query_id_212_SQL_Rev2_${tday}_eLife.csv"
rev3input="ejp_query_tool_query_id_213_SQL_Rev3_${tday}_eLife.csv"
rev4input="ejp_query_tool_query_id_214_SQL_Rev4_${tday}_eLife.csv"
typeinput="ejp_query_tool_query_id_218_SQL_Types_${tday}_eLife.csv"

# Generate SQL/SQLite commands to import data
# Commands stored in 'sql.cmds' file

echo ".separator \",\"" > /tmp/sql.cmds #

# Generate input .csv files for required tables if corresponding EJP output file is present
# Add SQL commands to clear import tables, import data into import tables, and move table to main tables, if present
# If EJP output files for today are not present, do nothing

#IF statement checks that a file matching today's date is present in folder
#Removes EJP header and column heads
#Removes double quotes present in EJP output
#Add instructions to SQL command file:
	#Clear import table
	#Import data into import table
	#Transfer data to main table
#ELSE - do nothing

#Initial Submission data

if [ -e $initialinput ]; then
egrep "^\"[[:digit:]]*\"," $initialinput > initial_tmp.csv
tr -d "\"" < initial_tmp.csv > initial.csv
rm initial_tmp.csv
echo "delete FROM initial_import;" >> /tmp/sql.cmds #
echo ".import initial.csv initial_import" >> /tmp/sql.cmds #
echo "insert INTO initial SELECT * FROM initial_import WHERE initial_import.ms NOT IN (SELECT ms FROM initial);" >> /tmp/sql.cmds #
else :
fi

#Full Submission data

if [ -e $fullinput ]; then
egrep "^\"[[:digit:]]*\"," $fullinput > full_tmp.csv
tr -d "\"" < full_tmp.csv > full.csv
rm full_tmp.csv
echo "delete FROM full_import;" >> /tmp/sql.cmds #
echo ".import full.csv full_import" >> /tmp/sql.cmds #
echo "insert INTO full SELECT * FROM full_import WHERE full_import.ms NOT IN (SELECT ms FROM full);" >> /tmp/sql.cmds #
else :
fi

#Rev1 Submission data

if [ -e $rev1input ]; then
egrep "^\"[[:digit:]]*\"," $rev1input > rev1_tmp.csv
tr -d "\"" < rev1_tmp.csv > rev1.csv
rm rev1_tmp.csv
echo "delete FROM rev1_import;" >> /tmp/sql.cmds #
echo ".import rev1.csv rev1_import" >> /tmp/sql.cmds #
echo "insert INTO rev1 SELECT * FROM rev1_import WHERE rev1_import.ms NOT IN (SELECT ms FROM rev1);" >> /tmp/sql.cmds #
else :
fi

#Rev2 Submission data

if [ -e $rev2input ]; then
egrep "^\"[[:digit:]]*\"," $rev2input > rev2_tmp.csv
tr -d "\"" < rev2_tmp.csv > rev2.csv
rm rev2_tmp.csv
echo "delete FROM rev2_import;" >> /tmp/sql.cmds #
echo ".import rev2.csv rev2_import" >> /tmp/sql.cmds #
echo "insert INTO rev2 SELECT * FROM rev2_import WHERE rev2_import.ms NOT IN (SELECT ms FROM rev2);" >> /tmp/sql.cmds #
else :
fi

#Rev3 Submission data

if [ -e $rev3input ]; then
egrep "^\"[[:digit:]]*\"," $rev3input > rev3_tmp.csv
tr -d "\"" < rev3_tmp.csv > rev3.csv
rm rev3_tmp.csv
echo "delete FROM rev3_import;" >> /tmp/sql.cmds #
echo ".import rev3.csv rev3_import" >> /tmp/sql.cmds #
echo "insert INTO rev3 SELECT * FROM rev3_import WHERE rev3_import.ms NOT IN (SELECT ms FROM rev3);" >> /tmp/sql.cmds #
else :
fi

#Rev4 Submission data

if [ -e $rev4input ]; then
egrep "^\"[[:digit:]]*\"," $rev4input > rev4_tmp.csv
tr -d "\"" < rev4_tmp.csv > rev4.csv
rm rev4_tmp.csv
echo "delete FROM rev4_import;" >> /tmp/sql.cmds #
echo ".import rev4.csv rev4_import" >> /tmp/sql.cmds #
echo "insert INTO rev4 SELECT * FROM rev4_import WHERE rev4_import.ms NOT IN (SELECT ms FROM rev4);" >> /tmp/sql.cmds #
else :
fi

#Type data

if [ -e $typeinput ]; then
egrep "^\"[[:digit:]]*\"," $typeinput > type_tmp.csv
tr -d "\"" < type_tmp.csv > type.csv
rm type_tmp.csv
echo "delete FROM type_import;" >> /tmp/sql.cmds #
echo ".import type.csv type_import" >> /tmp/sql.cmds #
echo "insert INTO type SELECT * FROM type_import WHERE type_import.ms NOT IN (SELECT ms FROM type);" >> /tmp/sql.cmds #
else :
fi

#Publication date data

if [ -e published.csv ]; then
echo "delete FROM published_import;" >> /tmp/sql.cmds #
echo ".import published.csv published_import" >> /tmp/sql.cmds #
echo "insert INTO published SELECT * FROM published_import WHERE published_import.ms NOT IN (SELECT ms FROM published);" >> /tmp/sql.cmds #
else :
fi


#Provide output CSV of all data

echo ".header on" >> /tmp/sql.cmds #
echo ".mode csv" >> /tmp/sql.cmds #
echo ".output paper_history${tday}.csv" >> /tmp/sql.cmds #

echo "SELECT i.ms,i.initial_qc_dt,i.initial_decision,i.initial_decision_dt, f.full_qc_dt,f.full_decision,f.full_decision_dt, r1.rev1_qc_dt,r1.rev1_decision,r1.rev1_decision_dt, r2.rev2_qc_dt,r2.rev2_decision,r2.rev2_decision_dt, r3.rev3_qc_dt,r3.rev3_decision,r3.rev3_decision_dt, p.poa_dt,p.vor_dt FROM initial i LEFT JOIN full f ON i.ms=f.ms LEFT JOIN rev1 r1 ON i.ms=r1.ms LEFT JOIN rev2 r2 ON i.ms=r2.ms LEFT JOIN rev3 r3 ON i.ms=r3.ms LEFT JOIN published p ON i.ms=p.ms ORDER BY i.ms;" >> /tmp/sql.cmds #


# Pipe SQL command file to SQLite and command SQLite to open database

cat /tmp/sql.cmds | sqlite3 elife_paper_stats.sqlite

# Remove SQL command file

rm /tmp/sql.cmds

# Remove temp .csv files

rm initial.csv
rm full.csv
rm rev1.csv
rm rev2.csv
rm rev3.csv
rm rev4.csv
rm type.csv
#!/bin/bash

# Script to import eLife data into SQLite database
# Requires data downloaded from eLife submission database
# For use generating monthly stats
# Note: terminal must be pointed to correct directory before running this script
# issue: cd ~/eLife_stats before summoning script to change to correct directory
# issue: sh Todaysdata.sh to run script

# Set file path to download folder

path="/Users/GilbertJ/Documents/eLife_stats/stat_downloads"

# Get today's date

tday=`date +%Y_%m_%d`

# Generate SQL/SQLite commands to import data
# Commands stored in 'sql.cmds' file

echo ".separator \",\"" > /tmp/sql.cmds
 
for filename in $( ls $path/ ); do

case $filename in
	209.csv) #Initial Submission data
echo "DELETE FROM initial_import;" >> /tmp/sql.cmds
echo ".import $path/209.csv initial_import" >> /tmp/sql.cmds
echo "INSERT INTO initial SELECT * FROM initial_import WHERE initial_import.ms NOT IN (SELECT ms FROM initial);" >> /tmp/sql.cmds
echo "UPDATE initial SET initial_decision = (SELECT initial_import.initial_decision FROM initial_import WHERE initial.ms=initial_import.ms), initial_decision_dt = (SELECT initial_import.initial_decision_dt FROM initial_import WHERE initial.ms=initial_import.ms);" >> /tmp/sql.cmds
echo "Updated Initial Submissions"
	;;

	210.csv) #Full Submission data
echo "DELETE FROM full_import;" >> /tmp/sql.cmds
echo ".import $path/210.csv full_import" >> /tmp/sql.cmds
echo "INSERT INTO full SELECT * FROM full_import WHERE full_import.ms NOT IN (SELECT ms FROM full);" >> /tmp/sql.cmds
echo "UPDATE full SET full_decision = (SELECT full_import.full_decision FROM full_import WHERE full.ms=full_import.ms), full_decision_dt = (SELECT full_import.full_decision_dt FROM full_import WHERE full.ms=full_import.ms);" >> /tmp/sql.cmds
echo "Updated Full Submissions"
	;;

	211.csv) #Rev1 Submission data
echo "DELETE FROM rev1_import;" >> /tmp/sql.cmds
echo ".import $path/211.csv rev1_import" >> /tmp/sql.cmds
echo "insert INTO rev1 SELECT * FROM rev1_import WHERE rev1_import.ms NOT IN (SELECT ms FROM rev1);" >> /tmp/sql.cmds
echo "UPDATE rev1 SET rev1_decision = (SELECT rev1_import.rev1_decision FROM rev1_import WHERE rev1.ms=rev1_import.ms), rev1_decision_dt = (SELECT rev1_import.rev1_decision_dt FROM rev1_import WHERE rev1.ms=rev1_import.ms);" >> /tmp/sql.cmds
echo "Updated Rev1 Submissions"
	;;

	212.csv) #Rev2 Submission data
echo "DELETE FROM rev2_import;" >> /tmp/sql.cmds
echo ".import $path/212.csv rev2_import" >> /tmp/sql.cmds
echo "insert INTO rev2 SELECT * FROM rev2_import WHERE rev2_import.ms NOT IN (SELECT ms FROM rev2);" >> /tmp/sql.cmds
echo "UPDATE rev2 SET rev2_decision = (SELECT rev2_import.rev2_decision FROM rev2_import WHERE rev2.ms=rev2_import.ms), rev2_decision_dt = (SELECT rev2_import.rev2_decision_dt FROM rev2_import WHERE rev2.ms=rev2_import.ms);" >> /tmp/sql.cmds
echo "Updated Rev2 Submissions"
	;;

	213.csv) #Rev3 Submission data
echo "DELETE FROM rev3_import;" >> /tmp/sql.cmds
echo ".import $path/213.csv rev3_import" >> /tmp/sql.cmds
echo "insert INTO rev3 SELECT * FROM rev3_import WHERE rev3_import.ms NOT IN (SELECT ms FROM rev3);" >> /tmp/sql.cmds
echo "UPDATE rev3 SET rev3_decision = (SELECT rev3_import.rev3_decision FROM rev3_import WHERE rev3.ms=rev3_import.ms), rev3_decision_dt = (SELECT rev3_import.rev3_decision_dt FROM rev3_import WHERE rev3.ms=rev3_import.ms);" >> /tmp/sql.cmds
echo "Updated Rev3 Submissions"
	;;

	214.csv) #Rev4 Submission data
echo "DELETE FROM rev4_import;" >> /tmp/sql.cmds #
echo ".import $path/214.csv rev4_import" >> /tmp/sql.cmds #
echo "INSERT INTO rev4 SELECT * FROM rev4_import WHERE rev4_import.ms NOT IN (SELECT ms FROM rev4);" >> /tmp/sql.cmds #
echo "UPDATE rev4 SET rev4_decision = (SELECT rev4_import.rev4_decision FROM rev4_import WHERE rev4.ms=rev4_import.ms), rev4_decision_dt = (SELECT rev4_import.rev4_decision_dt FROM rev4_import WHERE rev4.ms=rev4_import.ms);" >> /tmp/sql.cmds #
echo "Updated Rev4 Submissions"
	;;

	218.csv) #Type data
echo "DELETE FROM type_import;" >> /tmp/sql.cmds #
echo ".import $path/218.csv type_import" >> /tmp/sql.cmds #
echo "insert INTO type SELECT * FROM type_import WHERE type_import.ms NOT IN (SELECT ms FROM type);" >> /tmp/sql.cmds #
echo "Updated Type codes"
	;;

	221.csv) #Senior editor data
echo "DELETE FROM senior_editor_import;" >> /tmp/sql.cmds #
echo ".import $path/221.csv senior_editor_import" >> /tmp/sql.cmds #
echo "insert INTO senior_editor SELECT * FROM senior_editor_import WHERE senior_editor_import.ms NOT IN (SELECT ms FROM senior_editor);" >> /tmp/sql.cmds #
echo "Updated Senior Editors"
	;;

	222.csv) #Reviewing editor data
echo "DELETE FROM reviewing_editor_import;" >> /tmp/sql.cmds #
echo ".import $path/222.csv reviewing_editor_import" >> /tmp/sql.cmds #
echo "insert INTO reviewing_editor SELECT * FROM reviewing_editor_import WHERE reviewing_editor_import.ms NOT IN (SELECT ms FROM reviewing_editor);" >> /tmp/sql.cmds #
echo "Updated Reviewing Editors"
	;;

esac

done

#Publication date data

if [ -e published.csv ]; then
echo "DELETE FROM published_import;" >> /tmp/sql.cmds #
echo ".import published.csv published_import" >> /tmp/sql.cmds #
echo "INSERT INTO published SELECT * FROM published_import WHERE published_import.ms NOT IN (SELECT ms FROM published);" >> /tmp/sql.cmds #
echo "UPDATE published SET vor_dt = (SELECT published_import.vor_dt FROM published_import WHERE published.ms=published_import.ms);" >> /tmp/sql.cmds #
echo "Publication dates updated"
fi

#Provide output CSV of all data

echo ".header on" >> /tmp/sql.cmds
echo ".mode csv" >> /tmp/sql.cmds
echo ".output paper_history${tday}.csv" >> /tmp/sql.cmds

echo "SELECT i.ms,se.senior_editor,i.initial_qc_dt,i.initial_decision,i.initial_decision_dt,f.full_qc_dt,f.full_decision,f.full_decision_dt,r1.rev1_qc_dt,r1.rev1_decision,r1.rev1_decision_dt,r2.rev2_qc_dt,r2.rev2_decision,r2.rev2_decision_dt,r3.rev3_qc_dt,r3.rev3_decision,r3.rev3_decision_dt,p.poa_dt,p.vor_dt FROM initial i LEFT JOIN senior_editor se ON i.ms=se.ms LEFT JOIN full f ON i.ms=f.ms LEFT JOIN rev1 r1 ON i.ms=r1.ms LEFT JOIN rev2 r2 ON i.ms=r2.ms LEFT JOIN rev3 r3 ON i.ms=r3.ms LEFT JOIN published p ON i.ms=p.ms ORDER BY i.ms;" >> /tmp/sql.cmds #

echo ".output paper_history${tday}_Appeals.csv" >> /tmp/sql.cmds

echo "SELECT i.ms,se.senior_editor,i.initial_qc_dt,i.initial_decision,i.initial_decision_dt,i.appeal,i.appeal_dt,f.full_qc_dt,f.full_decision,f.full_decision_dt,f.appeal,r1.rev1_qc_dt,r1.rev1_decision,r1.rev1_decision_dt,r1.appeal,r2.rev2_qc_dt,r2.rev2_decision,r2.rev2_decision_dt,r2.appeal,r3.rev3_qc_dt,r3.rev3_decision,r3.rev3_decision_dt,r3.appeal,p.poa_dt,p.vor_dt FROM initial i LEFT JOIN senior_editor se ON i.ms=se.ms LEFT JOIN full f ON i.ms=f.ms LEFT JOIN rev1 r1 ON i.ms=r1.ms LEFT JOIN rev2 r2 ON i.ms=r2.ms LEFT JOIN rev3 r3 ON i.ms=r3.ms LEFT JOIN published p ON i.ms=p.ms ORDER BY i.ms;" >> /tmp/sql.cmds #

# Pipe SQL command file to SQLite and command SQLite to open database

cat /tmp/sql.cmds | sqlite3 elife_paper_stats.sqlite

# Remove SQL command file

rm /tmp/sql.cmds

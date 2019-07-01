#!/bin/bash

set -e # all commands must succeed. exits immediately on error
set -u # no unbound variables

# Script to download and import eLife data into SQLite database
# For use generating monthly stats
# issue: sh GetData.sh to run script

# Switch to script directory
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd $dir

# Import path to download folder from configuration file
source config.cfg

# Get today's date
tday=$(date +%Y_%m_%d)
tday_out=$(date +%Y-%m-%d)

# Skip user input if NOCONFIRM is set (to anything)
if [ -z ${NOCONFIRM+x} ]; then
	# Get user input and decide whether to download new data
	echo "Get data? [y/n]"
	read input
else
	input="y"
fi

if [ $input == "y" ]; then

	# Clear download folder ahead of download

	rm $path/*

	# Set up variables containing the names of the files required by eLife stats database

	initialinput="ejp_query_tool_query_id_SQL_Initial_${tday}_eLife.csv"
	fullinput="ejp_query_tool_query_id_SQL_Full_${tday}_eLife.csv"
	rev1input="ejp_query_tool_query_id_SQL_Rev1_${tday}_eLife.csv"
	rev2input="ejp_query_tool_query_id_SQL_Rev2_${tday}_eLife.csv"
	rev3input="ejp_query_tool_query_id_SQL_Rev3_${tday}_eLife.csv"
	rev4input="ejp_query_tool_query_id_SQL_Rev4_${tday}_eLife.csv"
	typeinput="ejp_query_tool_query_id_SQL_Types_${tday}_eLife.csv"
	typefullinput="ejp_query_tool_query_id_SQL_Types_Full_${tday}_eLife.csv"
	typerev1input="ejp_query_tool_query_id_SQL_Types_Rev1_${tday}_eLife.csv"
	typerev2input="ejp_query_tool_query_id_SQL_Types_Rev2_${tday}_eLife.csv"
	typerev3input="ejp_query_tool_query_id_SQL_Types_Rev3_${tday}_eLife.csv"
	seinput1="ejp_query_tool_query_id_SQL_Senior_Editor_1_${tday}_eLife.csv"
	seinput2="ejp_query_tool_query_id_SQL_Senior_Editor_2_${tday}_eLife.csv"
	seinput3="ejp_query_tool_query_id_SQL_Senior_Editor_3_${tday}_eLife.csv"
	reinput="ejp_query_tool_query_id_SQL_Reviewing_Editor_${tday}_eLife.csv"
	country1input="ejp_query_tool_query_id_SQL_Country_1_${tday}_eLife.csv"
	country2input="ejp_query_tool_query_id_SQL_Country_2_${tday}_eLife.csv"
	country3input="ejp_query_tool_query_id_SQL_Country_3_${tday}_eLife.csv"
	institution1input="ejp_query_tool_query_id_SQL_Institution_1_${tday}_eLife.csv"
	institution2input="ejp_query_tool_query_id_SQL_Institution_2_${tday}_eLife.csv"
	institution3input="ejp_query_tool_query_id_SQL_Institution_3_${tday}_eLife.csv"


	# For all the filenames listed above, download files, process and rename

	for report_name in ${initialinput} ${fullinput} ${rev1input} ${rev2input} ${rev3input} ${rev4input} ${typeinput} ${typefullinput} ${typerev1input} ${typerev2input} ${typerev3input} ${seinput1} ${seinput2} ${seinput3} ${reinput} ${country1input} ${country2input} ${country3input} ${institution1input} ${institution2input} ${institution3input}; do
		# looks like: 'Institution_1.csv', 'Country_3.csv'
		new_report_name=$(echo $report_name | sed -n "s/ejp_query_tool_query_id_SQL_\(.*\)_${tday}_eLife\.csv$/\1/p")

		# download the file at the remote path to the local path
		/opt/s3-bash.0.02/s3-get -k $key -s $skeypath /elife-ejp-ftp/$report_name > $path/$report_name.csv

		# 1. ignores lines in file that don't start with a double quoted digit followed by a comma (first four lines of file)
		# 2. removes double quotes from the remaining lines
		# 3. writes the results into a new file, deletes the old file
		egrep "^\"[[:digit:]]*\"," $path/$report_name.csv | tr -d "\"" > $path/$new_report_name.csv
		rm $path/$report_name.csv
		echo "$report_name"
	done

	echo "The above files were downloaded."

else
	echo "Nothing downloaded."

fi


# Generate SQL/SQLite commands to import data
# Commands stored in 'sql.cmds' file

echo ".separator \",\"" > /tmp/sql.cmds

# Run import commands for each dataset ID number. These will only run if the relevent file is present in the download folder
 
for filename in $( ls $path/ ); do

case $filename in

	Initial.csv) #Initial Submission data
echo "DELETE FROM initial_import;" >> /tmp/sql.cmds
echo ".import $path/Initial.csv initial_import" >> /tmp/sql.cmds
echo "INSERT INTO initial SELECT * FROM initial_import WHERE initial_import.ms NOT IN (SELECT ms FROM initial);" >> /tmp/sql.cmds
echo "UPDATE initial SET initial_decision = (SELECT initial_import.initial_decision FROM initial_import WHERE initial.ms=initial_import.ms), initial_decision_dt = (SELECT initial_import.initial_decision_dt FROM initial_import WHERE initial.ms=initial_import.ms);" >> /tmp/sql.cmds
echo "Updated Initial Submissions"
	;;

	Full.csv) #Full Submission data
echo "DELETE FROM full_import;" >> /tmp/sql.cmds
echo ".import $path/Full.csv full_import" >> /tmp/sql.cmds
echo "INSERT INTO full SELECT * FROM full_import WHERE full_import.ms NOT IN (SELECT ms FROM full);" >> /tmp/sql.cmds
echo "UPDATE full SET full_decision = (SELECT full_import.full_decision FROM full_import WHERE full.ms=full_import.ms), full_decision_dt = (SELECT full_import.full_decision_dt FROM full_import WHERE full.ms=full_import.ms);" >> /tmp/sql.cmds
echo "Updated Full Submissions"
	;;

	Rev1.csv) #Rev1 Submission data
echo "DELETE FROM rev1_import;" >> /tmp/sql.cmds
echo ".import $path/Rev1.csv rev1_import" >> /tmp/sql.cmds
echo "insert INTO rev1 SELECT * FROM rev1_import WHERE rev1_import.ms NOT IN (SELECT ms FROM rev1);" >> /tmp/sql.cmds
echo "UPDATE rev1 SET rev1_decision = (SELECT rev1_import.rev1_decision FROM rev1_import WHERE rev1.ms=rev1_import.ms), rev1_decision_dt = (SELECT rev1_import.rev1_decision_dt FROM rev1_import WHERE rev1.ms=rev1_import.ms);" >> /tmp/sql.cmds
echo "Updated Rev1 Submissions"
	;;

	Rev2.csv) #Rev2 Submission data
echo "DELETE FROM rev2_import;" >> /tmp/sql.cmds
echo ".import $path/Rev2.csv rev2_import" >> /tmp/sql.cmds
echo "insert INTO rev2 SELECT * FROM rev2_import WHERE rev2_import.ms NOT IN (SELECT ms FROM rev2);" >> /tmp/sql.cmds
echo "UPDATE rev2 SET rev2_decision = (SELECT rev2_import.rev2_decision FROM rev2_import WHERE rev2.ms=rev2_import.ms), rev2_decision_dt = (SELECT rev2_import.rev2_decision_dt FROM rev2_import WHERE rev2.ms=rev2_import.ms);" >> /tmp/sql.cmds
echo "Updated Rev2 Submissions"
	;;

	Rev3.csv) #Rev3 Submission data
echo "DELETE FROM rev3_import;" >> /tmp/sql.cmds
echo ".import $path/Rev3.csv rev3_import" >> /tmp/sql.cmds
echo "insert INTO rev3 SELECT * FROM rev3_import WHERE rev3_import.ms NOT IN (SELECT ms FROM rev3);" >> /tmp/sql.cmds
echo "UPDATE rev3 SET rev3_decision = (SELECT rev3_import.rev3_decision FROM rev3_import WHERE rev3.ms=rev3_import.ms), rev3_decision_dt = (SELECT rev3_import.rev3_decision_dt FROM rev3_import WHERE rev3.ms=rev3_import.ms);" >> /tmp/sql.cmds
echo "Updated Rev3 Submissions"
	;;

	Rev4.csv) #Rev4 Submission data
echo "DELETE FROM rev4_import;" >> /tmp/sql.cmds #
echo ".import $path/Rev4.csv rev4_import" >> /tmp/sql.cmds #
echo "INSERT INTO rev4 SELECT * FROM rev4_import WHERE rev4_import.ms NOT IN (SELECT ms FROM rev4);" >> /tmp/sql.cmds #
echo "UPDATE rev4 SET rev4_decision = (SELECT rev4_import.rev4_decision FROM rev4_import WHERE rev4.ms=rev4_import.ms), rev4_decision_dt = (SELECT rev4_import.rev4_decision_dt FROM rev4_import WHERE rev4.ms=rev4_import.ms);" >> /tmp/sql.cmds #
echo "Updated Rev4 Submissions"
	;;

	Types.csv) #Type data - combined into one case in order to import information in correct order to account for changes in type through progress
	#Rev3 Type data
echo "DELETE FROM type_import_rev3;" >> /tmp/sql.cmds #
echo ".import $path/Types_Rev3.csv type_import_rev3" >> /tmp/sql.cmds #
echo "insert INTO type SELECT * FROM type_import_rev3 WHERE type_import_rev3.ms NOT IN (SELECT ms FROM type);" >> /tmp/sql.cmds #
echo "Updated Rev3 Type codes"
	
	#Rev2 Type data
echo "DELETE FROM type_import_rev2;" >> /tmp/sql.cmds #
echo ".import $path/Types_Rev2.csv type_import_rev2" >> /tmp/sql.cmds #
echo "insert INTO type SELECT * FROM type_import_rev2 WHERE type_import_rev2.ms NOT IN (SELECT ms FROM type);" >> /tmp/sql.cmds #
echo "Updated Rev2 Type codes"
	
	#Rev1 Type data
echo "DELETE FROM type_import_rev1;" >> /tmp/sql.cmds #
echo ".import $path/Types_Rev1.csv type_import_rev1" >> /tmp/sql.cmds #
echo "insert INTO type SELECT * FROM type_import_rev1 WHERE type_import_rev1.ms NOT IN (SELECT ms FROM type);" >> /tmp/sql.cmds #
echo "Updated Rev1 Type codes"
	
	#Full Type data
echo "DELETE FROM type_import_full;" >> /tmp/sql.cmds #
echo ".import $path/Types_Full.csv type_import_full" >> /tmp/sql.cmds #
echo "insert INTO type SELECT * FROM type_import_full WHERE type_import_full.ms NOT IN (SELECT ms FROM type);" >> /tmp/sql.cmds #
echo "Updated Full Type codes"

	#Initial Type data
echo "DELETE FROM type_import;" >> /tmp/sql.cmds #
echo ".import $path/Types.csv type_import" >> /tmp/sql.cmds #
echo "insert INTO type SELECT * FROM type_import WHERE type_import.ms NOT IN (SELECT ms FROM type);" >> /tmp/sql.cmds #
echo "Updated Type codes"
	;;
	
	Country_1.csv) #Country data - combined into one case in order to import information in correct order to account for changes in type through progress
	#Other Country data
echo "DELETE FROM country_import_other;" >> /tmp/sql.cmds #
echo ".import $path/Country_3.csv country_import_other" >> /tmp/sql.cmds #
echo "insert INTO country SELECT * FROM country_import_other WHERE country_import_other.ms NOT IN (SELECT ms FROM country);" >> /tmp/sql.cmds #
echo "Updated Other Countries"

echo "DELETE FROM country_import_full;" >> /tmp/sql.cmds #
echo ".import $path/Country_2.csv country_import_full" >> /tmp/sql.cmds #
echo "insert INTO country SELECT * FROM country_import_full WHERE country_import_full.ms NOT IN (SELECT ms FROM country);" >> /tmp/sql.cmds #
echo "Updated Full Countries"

echo "DELETE FROM country_import;" >> /tmp/sql.cmds #
echo ".import $path/Country_1.csv country_import" >> /tmp/sql.cmds #
echo "insert INTO country SELECT * FROM country_import WHERE country_import.ms NOT IN (SELECT ms FROM country);" >> /tmp/sql.cmds #
echo "Updated Initial Countries"
	;;

	Institution_1.csv) #Institution data - combined into one case in order to import information in correct order to account for changes in type through progress
	#Other Institution data
echo "DELETE FROM institution_import_other;" >> /tmp/sql.cmds #
echo ".import $path/Institution_3.csv institution_import_other" >> /tmp/sql.cmds #
echo "insert INTO institution SELECT * FROM institution_import_other WHERE institution_import_other.ms NOT IN (SELECT ms FROM institution);" >> /tmp/sql.cmds #
echo "Updated Other Institutions"

echo "DELETE FROM institution_import_full;" >> /tmp/sql.cmds #
echo ".import $path/Institution_2.csv institution_import_full" >> /tmp/sql.cmds #
echo "insert INTO institution SELECT * FROM institution_import_full WHERE institution_import_full.ms NOT IN (SELECT ms FROM institution);" >> /tmp/sql.cmds #
echo "Updated Full Institutions"

echo "DELETE FROM institution_import;" >> /tmp/sql.cmds #
echo ".import $path/Institution_1.csv institution_import" >> /tmp/sql.cmds #
echo "insert INTO institution SELECT * FROM institution_import WHERE institution_import.ms NOT IN (SELECT ms FROM institution);" >> /tmp/sql.cmds #
echo "Updated Initial Institutions"
	;;

	Senior_Editor_1.csv) #Senior editor data

echo "DELETE FROM senior_editor_import_3;" >> /tmp/sql.cmds #
echo ".import $path/Senior_Editor_3.csv senior_editor_import_3" >> /tmp/sql.cmds #
echo "insert INTO senior_editor SELECT * FROM senior_editor_import_3 WHERE senior_editor_import_3.ms NOT IN (SELECT ms FROM senior_editor);" >> /tmp/sql.cmds #
echo "Updated Senior Editors 3"

echo "DELETE FROM senior_editor_import_2;" >> /tmp/sql.cmds #
echo ".import $path/Senior_Editor_2.csv senior_editor_import_2" >> /tmp/sql.cmds #
echo "insert INTO senior_editor SELECT * FROM senior_editor_import_2 WHERE senior_editor_import_2.ms NOT IN (SELECT ms FROM senior_editor);" >> /tmp/sql.cmds #
echo "Updated Senior Editors 2"

echo "DELETE FROM senior_editor_import_1;" >> /tmp/sql.cmds #
echo ".import $path/Senior_Editor_1.csv senior_editor_import_1" >> /tmp/sql.cmds #
echo "insert INTO senior_editor SELECT * FROM senior_editor_import_1 WHERE senior_editor_import_1.ms NOT IN (SELECT ms FROM senior_editor);" >> /tmp/sql.cmds #
echo "Updated Senior Editors 1"
	;;

	Reviewing_Editor.csv) #Reviewing editor data
echo "DELETE FROM reviewing_editor_import;" >> /tmp/sql.cmds #
echo ".import $path/Reviewing_Editor.csv reviewing_editor_import" >> /tmp/sql.cmds #
echo "insert INTO reviewing_editor SELECT * FROM reviewing_editor_import WHERE reviewing_editor_import.ms NOT IN (SELECT ms FROM reviewing_editor);" >> /tmp/sql.cmds #
echo "Updated Reviewing Editors"
	;;

esac

done

#Publication date data
#This is currently pulled from a manually updated file: in the future, it will hopefully be replaced with another downloaded dataset

if [ -e published-research-article-index.csv ]; then
echo "DELETE FROM published_import;" >> /tmp/sql.cmds #
echo "DELETE FROM published;" >> /tmp/sql.cmds #
echo ".import published-research-article-index.csv published_import" >> /tmp/sql.cmds #
echo "INSERT INTO published SELECT * FROM published_import WHERE published_import.ms NOT IN (SELECT ms FROM published);" >> /tmp/sql.cmds #
echo "UPDATE published SET vor_dt = (SELECT published_import.vor_dt FROM published_import WHERE published.ms=published_import.ms);" >> /tmp/sql.cmds #
echo "Publication dates updated"
fi

#Provide output CSV file containing paper histories

echo ".header on" >> /tmp/sql.cmds
echo ".mode csv" >> /tmp/sql.cmds
echo ".output paper_history${tday_out}.csv" >> /tmp/sql.cmds

echo "SELECT t.ms,
t.type,
c.country,
se.senior_editor,
i.initial_qc_dt,
i.initial_decision,
i.initial_decision_dt,
re.reviewing_editor,
f.full_qc_dt,
f.full_decision,
f.full_decision_dt,
r1.rev1_qc_dt,
r1.rev1_decision,
r1.rev1_decision_dt,
r2.rev2_qc_dt,
r2.rev2_decision,
r2.rev2_decision_dt,
r3.rev3_qc_dt,
r3.rev3_decision,
r3.rev3_decision_dt,
r4.rev4_qc_dt,
r4.rev4_decision,
r4.rev4_decision_dt,
substr(p.poa_dt,1,10) AS 'p.poa_dt',
substr(p.vor_dt,1,10) AS 'p.vor_dt'

FROM type t
LEFT JOIN initial i ON t.ms=i.ms
LEFT JOIN country c ON t.ms=c.ms
LEFT JOIN senior_editor se ON t.ms=se.ms
LEFT JOIN reviewing_editor re ON t.ms=re.ms
LEFT JOIN full f ON t.ms=f.ms
LEFT JOIN rev1 r1 ON t.ms=r1.ms
LEFT JOIN rev2 r2 ON t.ms=r2.ms
LEFT JOIN rev3 r3 ON t.ms=r3.ms
LEFT JOIN rev4 r4 ON t.ms=r4.ms
LEFT JOIN published p ON t.ms=p.ms

ORDER BY t.ms;" >> /tmp/sql.cmds #

#Provide second output CSV file containing appeal information

echo ".output paper_history${tday_out}_Appeals.csv" >> /tmp/sql.cmds

echo "SELECT t.ms,
t.type,
c.country,
se.senior_editor,
i.initial_qc_dt,
i.initial_decision,
i.initial_decision_dt,
i.appeal,
i.appeal_dt,
re.reviewing_editor,
f.full_qc_dt,
f.full_decision,
f.full_decision_dt,
f.appeal,
r1.rev1_qc_dt,
r1.rev1_decision,
r1.rev1_decision_dt,
r1.appeal,
r2.rev2_qc_dt,
r2.rev2_decision,
r2.rev2_decision_dt,
r2.appeal,
r3.rev3_qc_dt,
r3.rev3_decision,
r3.rev3_decision_dt,
r3.appeal,
r4.rev4_qc_dt,
r4.rev4_decision,
r4.rev4_decision_dt,
r4.appeal,
substr(p.poa_dt,1,10) AS 'p.poa_dt',
substr(p.vor_dt,1,10) AS 'p.vor_dt'

FROM type t
LEFT JOIN initial i ON t.ms=i.ms
LEFT JOIN country c ON t.ms=c.ms
LEFT JOIN senior_editor se ON t.ms=se.ms
LEFT JOIN reviewing_editor re ON t.ms=re.ms
LEFT JOIN full f ON t.ms=f.ms
LEFT JOIN rev1 r1 ON t.ms=r1.ms
LEFT JOIN rev2 r2 ON t.ms=r2.ms
LEFT JOIN rev3 r3 ON t.ms=r3.ms
LEFT JOIN rev4 r4 ON t.ms=r4.ms
LEFT JOIN published p ON t.ms=p.ms

ORDER BY t.ms;" >> /tmp/sql.cmds #

# Pipe SQL command file to SQLite and command SQLite to open database

cat /tmp/sql.cmds | sqlite3 elife_paper_stats.sqlite || echo "done, but with failed SQL (see output)"
echo "wrote: elife_paper_stats.sqlite"

# Remove SQL command file

rm /tmp/sql.cmds

echo
echo "done"

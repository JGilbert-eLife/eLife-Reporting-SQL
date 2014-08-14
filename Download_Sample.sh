#!/ bash/bin

# Script to download files from FTP site
# Note: terminal must be pointed to correct directory before running this script
# issue: cd before summoning script to change to correct directory
# issue: sh Download.sh to run script
# IMPORTANT: THIS IS A SAMPLE. File names and paths are generic.

# Import AWS passkey and donwload path details from configuration file

source config.cfg

# Clear download directory ahead of downloading new files

rm $path/*

# Get today's date

tday=$(date +%Y_%m_%d)

# Set up variables containing the names of the files required by eLife stats database

initialinput="XXX_XXX_XXX_query_id_209_SQL_Initial_${tday}_eLife.csv"
fullinput="XXX_XXX_XXX_query_id_210_SQL_Full_${tday}_eLife.csv"
rev1input="XXX_XXX_XXX_query_id_211_SQL_Rev1_${tday}_eLife.csv"
rev2input="XXX_XXX_XXX_query_id_212_SQL_Rev2_${tday}_eLife.csv"
rev3input="XXX_XXX_XXX_query_id_213_SQL_Rev3_${tday}_eLife.csv"
rev4input="XXX_XXX_XXX_query_id_214_SQL_Rev4_${tday}_eLife.csv"
typeinput="XXX_XXX_XXX_query_id_218_SQL_Types_${tday}_eLife.csv"
seinput="XXX_XXX_XXX_query_id_221_SQL_Senior_Editor_${tday}_eLife.csv"
reinput="XXX_XXX_XXX_query_id_222_SQL_Reviewing_Editor_${tday}_eLife.csv"

# For all the filenames listed above, download files and rename to query tool ID number

for i in ${initialinput} ${fullinput} ${rev1input} ${rev2input} ${rev3input} ${rev4input} ${typeinput} ${seinput} ${reinput}; do
	name=$(echo $i | cut -f6 -d'_')
	/opt/s3-bash.0.02/s3-get -k  $key -s $skeypath /ftp-site-location/$i > $path/$i.csv
	egrep "^\"[[:digit:]]*\"," $path/$i.csv | tr -d "\"" > $path/$name.csv
	rm $path/$i.csv
	echo "$i"
done

echo "The above files were downloaded."

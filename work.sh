#!/bin/bash
#####DELETE PREVIOUS CREATION FILES##########
rm newemployees.csv
rm orgs-employees.csv
rm listofuser.txt
rm missingEmails.txt
rm orgsuserstolower.txt
rm emailorgs.txt
rm oldEmail.txt
#############################################
sleep 2
#The dos2unix and unix2dos commands convert plain text files from DOS or Mac format to Unix, and vice versa.
dos2unix allusers.csv
# Will get the two needed column and put them on a new csv file
awk -F, ' BEGIN  {OFS=","} NR>1 {print tolower($2),$1, $7}' allusers.csv > newemployees.csv
sleep 5
dos2unix newemployees.csv
awk -i inplace '{gsub(/[^,]+/,"\"&\"")}1' newemployees.csv
# The list of email users must be on lowercase
awk '{print tolower($0)}' < usersfinal.txt > orgsuserstolower.txt
sleep 4
	# Will compare and extract the exact row where the email of orgs employees appear and store them in a new file
awk -F, -v q='"'  'NR==FNR{a[q $0 q]; next} 
                    FNR==1 || $1 in a' orgsuserstolower.txt newemployees.csv > orgs-employees.csv

dos2unix orgs-employees.csv
# Extract from orgs-employees.csv the list if username to test against github
awk -F   "\"*,\"*"   '{print $2}'   orgs-employees.csv > listofuser.txt
awk -F '\"' '{print $2}'  orgs-employees.csv > emailorgs.txt

# Will retrieve the emails that aren't part of the HR DATA will test
# Will test them against github to see if they have an account
sort orgsuserstolower.txt emailorgs.txt | uniq -c | awk '$1 == 1 {print $2}' > missingEmails.txt

sleep 3
awk '{sub(/dxc/,"old")}1' missingEmails.txt > oldEmail.txt

awk -F, -v q='"'  'NR==FNR{a[q $0 q]; next} 
                    FNR==1 || $1 in a' oldEmail.txt newemployees.csv > orgs-employees-oldmail.csv


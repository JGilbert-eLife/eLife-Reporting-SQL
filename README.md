eLife-Reporting-SQL
===================

eLife SQL database generation from existing report outputs

Currently only 'GetData.sh' needs to be run to provide the necessary output from a database created using 'CreateDatabase.sh'.

Requirement: https://github.com/cosmin/s3-bash should be installed in /opt.

Requirement: a config.cfg file in the same directory as the scripts containing:

#!/bin/bash

path="/for/stat/download/directory"

skeypath="/path/for/AWS/secretkey"

key="AWSpassword"


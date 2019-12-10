# SQL-code-to-keep-one-collation

-> During salesforce data migration project, I came across this issue.
-> Source database and Target database had different collation.
-> Even after manually changing database collation in source database, columns collation of various tables present in that database were not getting changed.
-> These columns were causing issues in later stage of data migration.
-> It was very long and tiresome process to change collation of each column which were different.
-> Hence, developed this script to automate process of changing collation of each column of table to required collation.
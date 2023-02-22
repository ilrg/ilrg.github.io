---
layout: default
title: Navigating Webmin
parent: Webmin
grand_parent: Server
nav_order: 2
---
# Navigating the Webmin Interface

[Instructions for Setting up Webmin](Server/Webmin_Setup.html)

## Cron Jobs
Located under 'System' > 'Scheduled Cron Jobs'
- Cron jobs are scheduled tasks. They execute shell scripts or commands in the background at specific times determined by the user.
- The ILRG project uses cron jobs to update the postgres server with new data from ODK Central, as well as to create backups of all the servers
- The cron jobs are set to run at different times in order to avoid overloading the server
- For example, pictured below is a cron job that is set to run every day at 1:30.

![WebminGeneralOne](/Pages/General_Assets/WebminGeneralOne.png)
- Some cron jobs are built in to Webmim already, the rest need to be manually added
- Cron jobs automatically built in:
![WebminGeneralTwo](/Pages/General_Assets/WebminGeneralTwo.png)

## PostgreSQL Databases
Located under 'System' > 'PostgreSQL Database Server'
- This page lists all the postgres databases hosted on the server
- By clicking on each database, you can view and edit different files, tables, etc. within said database

## File Manager
Located under 'Tools' > 'File Manager'
- Webmin and its file manager lets you view and download everything saved within the server, such as all the relevant sql scripts, media files, etc. 

Now that ODK Central, and Webmin are set up, the remaining infrastructure that needs to be installed is PostgreSQL with a PostGIS extension. 

**[Previous](Webmin_Setup.html)** <> **[Next](Postgres_Setup.html)**
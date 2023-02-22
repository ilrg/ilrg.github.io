---
layout: default
title: Adding Users
parent: Open Data Kit
nav_order: 1
---
# Adding Users
Users added to ODK Central serve as administrators, who can upload and change forms and forms permissions. [Adding ODK Collect users to each form](ODK_Collect.html) is a different process, and will be covered later on. 

To add new users to ODK Central, you must first create them in the Docker command line (there is a bug in ODK Central which means users cannot be added on the central site). Then you can change their roles and permissions on the ODK Central site.

- Log into the EC2 server we installed and set up in a [previous step](../Server/ODK_Central_Setup.html)
- Make sure you have logged onto the server as someone with administrative permissions
- Create a new user profile:
```
docker-compose exec service odk-cmd --email YOUREMAIL@ADDRESSHERE.com user-create
```
- You will be prompted to enter a password for the user
- The new user can now log onto ODK Central through the domain name that ODK Central was set up with
- To make the new user an administrator:
```
docker-compose exec service odk-cmd --email YOUREMAIL@ADDRESSHERE.com user-promote
```
The next section covers the ODK Central interface, and how to use it. 

**[Previous](Open_Data_Kit.html) <> [Next](NavigatingODKCentral.html)**
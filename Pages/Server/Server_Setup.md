---
layout: default
title: Server
nav_order: 2
has_children: true
---
# Instructions for Server Setup

The first step in our MAST implementaion is to set up the Amazon EC2 instance that will host our ODK Central, Webmin, and PostgreSQL databases and schemas. These services allow us to store and manage all the data needed for producing land certificates.

ODK’s infrastructure collects our data, but is not a good place to manage the data. We push out the data we collect with ODK to another database, where we validate, store, analyze and produce certificates. This requires 2 database schemas, the first is an intermediary database (update schema) that holds all the incoming data, the second database has only validated data (public schema). Between the first and second database, the data is cleaned and validated through a series of SQL scripts. The public schema holds the checked and validated data. 

This section will go over how to set up a Amazon EC2 instance running Ubuntu and how to log into your server instance using PuTTY. Then the instructions will go over how to install ODK Central, Webmin and PostgreSQL onto the server.

**[Previous](/index.html) <> [Next](AWS_Setup.html)**

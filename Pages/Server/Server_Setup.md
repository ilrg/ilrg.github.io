---
layout: default
title: Server
nav_order: 2
has_children: true
---
# Instructions for Server Setup
ODK’s infrastructure collects our data, but is not a good place to manage the data. We push out the data we collect with ODK to another database, where we validate, store, analyze and produce certificates. This requires 2 database schemas, the first is an intermediary database that holds all the incoming data, the second database has only validated data. Between the first and second database, the data is cleaned and validated through a series of SQL scripts.

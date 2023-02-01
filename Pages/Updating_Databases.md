---
layout: default
title: Updating Databases
nav_order: 6
---
# Updating and Communicating Between Databases

## Script Overview for Updating Databases
There are serveral shell scripts and SQL queries run as cron jobs (automatically run scripts). These scripts automatically update databases by pulling data from ODK Central.

### [odk_to_update.sh](General_Assets/odk_to_update.sh)
- This is a bash script that automates API calls to ODK Central, unpacks CSV files and calls an SQL script to load the data onto the update schema. This shell script is run as a cron job twice per day.
- The script must be updated to include the correct project and form ids. Where the API calls ODK Central, the API endpoint should follow the following format:
```
https://ilrg.ddns.net/v1/projects/[project_ID]/forms/[XML_form_ID]/submissions.csv.zip?attachments=false
```

    ex:
    ```
    https://ilrg.ddns.net/v1/projects/3/forms/Village_Governance_v4/submissions.csv.zip?attachments=false
    ```
- The API calls for forms with images in them will look slightly different, as the `attachment=false` is no longer true:
```
https://ilrg.ddns.net/v1/projects/[project_ID]/forms/[XML_form_ID]/submissions.csv.zip?
```

    ex:
    ```
    https://ilrg.ddns.net/v1/projects/3/forms/Claims/submissions.csv.zip?
    ```
- _You can find the project ID and XML form ID by going to ODK Central, opening the form and looking at the URL in the address bar, it will look similar to the URL above_

### [ilrg_fzs.sh](General_Assets/ilrg_fzs.sh)
- connects to the ilrg_fzs database and runs all of the update SQL scripts (described below), then commits those changes to the ilrg_fzs database
- run as a cron job 5 times per day

### [update_form...sql Scripts](General_Assets/updateSQLScripts)
- Update SQL scripts exist for each ODK form. The SQL scripts loads new CSV data into the relevant table and does some light processing. All of the update scripts take data from the update schema, and inserts the cleaned data into the public schema
- [Updating parcels](Data_Handling/Parcel_Handling.html) and [handling images](Data_Handling/Image_Handling.html) requires a bit more code, but all of the update sql scripts follow the same general format
- All of the update scripts are called in the [ilrg_fzs.sh](General_Assets/ilrg_fzs.sh) shell script
- The following are all the update sql scripts:
    - [update_form_a1_village_identification.sql](General_Assets/updateSQLScripts/update_form_a1_village_identification.sql)
    - [update_form_b_village_governance.sql](General_Assets/updateSQLScripts/update_form_b_village_governance.sql)
    - [update_form_d1_points_of_interest.sql](General_Assets/updateSQLScripts/update_form_d1_points_of_interest.sql)
    - [update_form_d2_shared_resources.sql](General_Assets/updateSQLScripts/update_form_d2_shared_resources.sql)
    - [update_form_e1_demarcation_witness.sql](General_Assets/updateSQLScripts/update_form_e1_demarcation_witness.sql)
    - [update_form_e1_demarcation.sql](General_Assets/updateSQLScripts/update_form_e1_demarcation.sql)
    - [update_form_e2_claims_parties.sql](General_Assets/updateSQLScripts/update_form_e2_claims_parties.sql)
    - [update_form_e2_claims.sql](General_Assets/updateSQLScripts/update_form_e2_claims.sql)
    - [update_form_f1_occ.sql](General_Assets/updateSQLScripts/update_form_f1_occ.sql)
    - [update_form_i1_meeting.sql](General_Assets/updateSQLScripts/update_form_i1_meeting.sql)

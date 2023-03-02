---
layout: default
title: XLSForms
parent: Open Data Kit
nav_order: 3
---
# Guide to XLSForms
XLSForms are how forms in ODK Central are formatted and detailed. They have several requirements but also provide flexibility in form choices and outputs. This page will first go over the ILRG XLSForms, and then how to create an XLSForm from scratch. 

## ILRG XLSForms
Below you will find links to all of the XLSForms currently used by ILRG (as of June, 2021). They are configured to collect all of the data necessary to complete the customary land documentation process, from village identification to Objection, Correction and Confirmation. Below the link to each form is also a description of the form as well as things to keep in mind when collecting the relevant data.
- [Form A1 Village Identification](/Pages/ODK/ODKAssets/A1_Village_Identification.xlsx)
    - Collects basic information about a village, including a GPS point which should be collected in the village 'center' or village meeting point
    - Villages are legally recognized per the 1972 Villages Act and do not have a strict size that they need to be, but they do need to be recognized by the Chief
    - There is an option to add an 'other' village if it is not in the list that was gathered before data collection (a list of villages from the chief)
    - Individual farms do not count as 'villages'
    - Ensure that the first letter of the village name is capitalized
     - If a village needs to be added to the long-term choice list, confirm with the chief that any proposed new village is recognized by the chief (per the 1972 Village Act)
- [Form B Village Governance](/Pages/ODK/ODKAssets/B_Village_Governance.xlsx)
    - Village governance forms provide information on consent to move forward with the work, as well as contact details for follow up. Your organization needs to know what additional NGOs and organizations are active within the community in order to coordinate and deliver services.
    - Village registers, if there is a register, the form will prompt the data collector to take photos of the pages of it, if there is not a register, enlist the headperson, induna, or a village member to collect a register 
- [Form D1 Points of Interest](/Pages/ODK/ODKAssets/D1_Shared_Resources_Points.xlsx)
    - Form requires a point to be taken to geolocate the infrastructure
    - The point of interest also needs to be categorized, check that the category is not present before selecting 'other'
    - Points of interest should include mobile money booths/providers, agricultural aggregators or other services. Overall they should capture the economic and social points of interest within each community. 
- [Form D2 Shared Resources](/Pages/ODK/ODKAssets/D2_Shared_Resources_Areas.xlsx)
    - Used to capture information about shared resources in each area
    - There are two ways in which the form can be used:
        - 'Online' - You can use the form to mark the GPS coordinates of the boundaries of a shared resource in the field; when you are at the site of the resource, you can open this form to capture the GPS coordinates, describe the area, and indicate who has use and access.
        - 'Offline' - You can use the form to capture information about shared resource areas that have been identified on the printed mapsheets. Once the map is complete, with all the areas clearly identified and coded, you can use this form to register each one and record its reference code from the map. If the area is possible to identify on the imagery within the form, you can also choose to mark it on this imagery.
    - Note, always draw on the hard copy map, even if you are walking the boundaries.
- [Form E1 Demarcations](/Pages/ODK/ODKAssets/E1_Demarcation.xlsx)
    - Records demarcation boundaries of parcels including parcel access information and the corresponding map sheet (where parcels are hand drawn)
    - The parcel boundary can be recorded three ways:
        - Boundary drawn on map only 
        - Partial boundary drawn on device / part drawn on map
        - Full boundary area collected on device 
- [Form E2 Claims](/Pages/ODK/ODKAssets/E2_Claims.xlsx)
    - Claims attach people to the parcels and allow people to be registered locally
    - Collect all details for all individuals unless they have already been fully registered and have their NRC details checked with photographs 
    - It is extremely important that NRCs are recorded and that phone numbers are recorded
- [Form F1 OCC](/Pages/ODK/ODKAssets/F1_Objections_Corrections.xlsx)
    - Collects data on Objections, Corrections and Confirmation to the validated data from phase one. 
    - Four options for each parcel:
        - Ready to certify - all signed, no changes
        - NOT ready to certify, and needs corrections
        - NOT ready to certify, needs a claim
        - NOT ready to certify 
- [Form G1 Disputes](/Pages/ODK/ODKAssets/G1_Disputes.xlsx)
    - Dispute and conflict resolution is one of the major objectives of land documentation processes, and often times the process opens up disputes. These need to be tracked, with respect to how disputes arise and what the team is doing to solve them. 
- [Form I1 Meeting](/Pages/ODK/ODKAssets/I1_Meeting.xlsx)
    - This form is used to capture information regarding community meetings. 

## XLSForm Creation
- Start with [ODK's form definition template](https://docs.google.com/spreadsheets/d/1v9Bumt3R0vCOGEKQI6ExUf2-8T72-XXp_CbKKTACuko/edit#gid=0) as it contains all the required sheets and columns

#### **Survey Sheet**
- The form must have a survey sheet that includes:
    - `type`: type of field in each row, such as `select_one`, `select_one_external`, `text`, `geopoint`
    - `name`: name of the field represented in each row, no spaces, should be short and descriptive
    - `label`: the visible question text for the viewer of the form
    - other columns in the survey sheet can be used for different question types and form logic
        - for example: `appearance` and `text` columns can be used to change the display of the questions
        - [more info on question types](https://docs.getodk.org/form-question-types/)
        - [more info on form logic](https://docs.getodk.org/form-logic/)
- To use a variable in a form, put the question's name in brackets, preceded by a dollar sign
    - ex: `${question-name}`

#### Survey Sheet Columns in ILRG Forms
- `choice_filter`: limits the options in a select question based on the answer to a previous question, specify an expression in this column, the expression should reference one or more columns in the choice sheet (see below for details on the choice sheet)
    - ex: `organization=${organization}`
- `repeat_count`: defines the number of times a question will repeat, it can reference previous responses
    - ex: `${number_of_children}`
        - this ensures that the relevant question will be asked for each child
- `hint`: extra instructions, such as 'select all that apply'
- `relevant`: used to show or hide questions based on previous responses, if the expression evaluates to true, the question appears
    - ex: `${organization}='other'`
        - if someone chooses other as the organization name, this question will appear
- `constraint`: validates and restricts response values, if the expression evaluates to true the form advances, if the expression evaluates to false the form does not advance and the constraint message is displayed
    - ex: `regex(.,'[0-9]{9}')`
        - true if the response contains numbers, false if the response contains anything else
- `constraint_message`: displayed when the expression in the constraint column evaluates to false
- `required`: specifies if field is required or not, to make a question required, put yes, otherwise, leave it blank
- `default`: provides a default response to a question, they can be fixed values or based on an expression
- `appearance`: determines the style of the form question
    - ex: `minimal`, `field-list`, `numbers`
- `calculation`: used to evaluate complex expressions
- `parameters`: specifies columns to use in a dataset from another source
- `media::image`: specifies image to be displayed with form question
    - ex: `hands.png`
- `media::video`: specifies video to be displayed with the form question

#### **Settings Sheet**
Used to uniquely identify your form and its current version.
- `form_title`:
    - ex: `A1 - Village Identification`
- `form_id`: The unique ID that identifies this form to tools that use it. It may not contain spaces and must start with a letter or underscore. Use a short and descriptive name.
    - ex: `Village_Identification_v2`
- `version`: The unique version code that identifies the current state of the form. A common convention is to use a format like `yyyymmddrr`
    - ex: `20190620`
- `instance_name`: An expression that will be used to represent a specific filled form created from this form definition
    - ex: `concat('Village Identification','-',${jurisdiction},'-',${village_id},'-',${date})`

#### **Choices Sheet**
Specifies choices for multiple choice questions.
- `list_name`: unique id to identify a list of choices, no spaces
    - should have multiple rows for each list name, one for each unique name
- `name`: name of the field represented by each row, no spaces
- `label`: user visible text for each row

#### **External Choices Sheet**
If a form has selects with a large number of choices (e.g., hundreds or thousands), that form can slow down form loading and navigation. The best workaround to this issue is to use external selects.
- Has at least three columns:
    - `list_name`: unique id to identify a list of choices, no spaces
        - should have multiple rows for each list name, one for each unique name
    - `name`: name of the field represented by each row, no spaces
    - `label`: user visible text for each row
- Instead of select_one in the prompt type, use **`select_one_external`** followed by the list_name in your external_choices sheet

The last Open Data Kit section goes over how to create and configure ODK Collect. It is the final step in setting up the ODK system from installing ODK Central onto our server, to populating ODK with users and forms. 

**[Previous](NavigatingODKCentral.html) <> [Next](ODK_Collect.html)**
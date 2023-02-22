---
layout: default
title: XLSForms
parent: Open Data Kit
nav_order: 3
---
# Guide to XLSForms
XLSForms are how forms in ODK Central are formatted and detailed. They have several requirements but also provide flexibility in form choices and outputs.

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
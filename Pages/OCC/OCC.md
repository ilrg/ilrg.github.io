---
layout: default
title: Objection, Correction and Confirmation
nav_order: 6
has_children: true
---
# Objection, Correction and Confirmation (OCC)

## OCC Register
- Village registers are the final product before OCC begins
    - Each village register has a map with each parcel number as well as the initials and surnames of the landowner displayed
    - The register also comes with a list that includes the parcel number paired with any landholders, persons of interest, witnesses, etc.
- Changes are made directly on the printed OCC Register, such as name changes, deleting persons or adding new persons
- The registers are produced in zones (grouped). At the end of the OCC process, certificates are produced based on the same zones, so the certificate can be double checked against the OCC register

## F1 - OCC Form
- Records the result of the OCC for each parcel:
    - Ready to certify
    - NOT ready to certify and needs corrections
    - Not ready to certify, needs a claim
    - NOT ready to certify
- If the parcel boundary needs to be changed, the enumerator is required to draw or walk the full boundary  

### [update_form_f1_occ.sql](../General_Assets/update_form_f1_occ.sql)
- Run as a cron job
- Takes submissions of the F1 Form from ODK Central
- Inserts the form data into the public schema if the parcel is 'ready to certify - all signed, no changes'
    - Automatically sets the 'checked' column to 'yes'
- Otherwise, the form data is put into the update schema, until the checked column is set to 'yes', then the data is moved to the public schema

### [update_occ_add_parties.sql](../General_Assets/update_occ_add_parties.sql)
- Run as a cron job
- Repleaces information in form_e2_claims_parties with updated information and adds party infromation that was missing before
- Sets the 'checked' column in form_e2_claims_parties to 'no' so the data can be manually checked before it is moved into the public schema 

---
layout: default
title: Image Handling
parent: Data Processing and Handling
nav_order: 1
---

# Image Handling
Images are uploaded in ODK Forms, and are then processed and uploaded to the server through a set of SQL and shell scripts. Images are a key part of the georeferencing and documentation process, as pictures of map sheets submitted in forms are used to document parcels and shared resources.

### In [odk_to_update.sh](../General_Assets/odk_to_update.sh):
- Submissions data is pulled from ODK Central onto the update schema. The script first pulls data without images. Then for forms with images, the attachments (images) are pulled, zipped into a folder on the update schema, and then unzipped as a media folder and moved to a media folder on the server (/srv/media/fzs/formID).
    - The end of the file path, 'formID', changes based on the form.
- Example for update_form_e1_demarcation (demarcation data):
    - Fetch form data, unzip, remove zip:
```
curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Demarcation/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_e1_demarcation/Demarcation.zip
unzip -o /home/ubuntu/fzs/form_e1_demarcation/Demarcation.zip -d /home/ubuntu/fzs/form_e1_demarcation/
```
    - csvcut removes unneeded ODK Central fields from core and makes sure file is regular:
```
csvcut -C SubmissionDate,start,my_form_name,text,village_name-searchtext,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_e1_demarcation/Demarcation.csv > /home/ubuntu/fzs/form_e1_demarcation/form_e1_demarcation_cut.csv
```
    - Pull new images from only last day and unzip onto the server so it can be accessed via a URL:
```
curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Demarcation/submissions.csv.zip? > /home/ubuntu/fzs/form_e1_demarcation/e1_img.zip
unzip -n /home/ubuntu/fzs/form_e1_demarcation/e1_img.zip "media/*" -d /home/ubuntu/fzs/form_e1_demarcation/
mv /home/ubuntu/fzs/form_e1_demarcation/media/* /srv/media/fzs/e1/
```

### In [update_form....sql scripts](../General_Assets/updateSQLScripts):
- In each form where images are uploaded, the update sql scripts set the image URLs by concatenating the server address with the name of each image.
    - The images were moved onto the server in odk_to_update.sh
- For example, in [update_form_e1_demarcation.sql](../General_Assets/updateSQLScripts/update_form_e1_demarcation), image URLs are created for witness, receipt and map sheet images:
    - Set image URLs where they exist:

    ```
    update update.form_e1_demarcation
    set witnesses_image = concat('http://13.244.91.45:90/media/fzs/e1/'||witnesses_image)
    where length(witnesses_image) = 17;

    update update.form_e1_demarcation
    set receipt_image = concat('http://13.244.91.45:90/media/fzs/e1/'||receipt_image)
    where length(receipt_image) = 17;

    update update.form_e1_demarcation
    set map_sheet_image = concat('http://13.244.91.45:90/media/fzs/e1/'||map_sheet_image)
    where length(map_sheet_image) = 17;
    ```
**[Previous](Data_Processing.html) <> [Next](Parcel_Handling.html)**

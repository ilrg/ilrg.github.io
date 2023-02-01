#!/bin/bash

#variables
yest=$(date -d "-1day" +%Y-%m-%d)

#Village ID
#Fetch form data, unzip, remove zip
#curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Village_Identification_v3/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_a1_village_identification/village_identification.zip
#unzip -o /home/ubuntu/fzs/form_a1_village_identification/village_identification.zip -d /home/ubuntu/fzs/form_a1_village_identification/
# csvcut removes unneeded ODK Central fields and makes sure file is regular
#csvcut -C SubmissionDate,start,searchtext,intronote,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_a1_village_identification/Village_Identification_v3.csv > /home/ubuntu/fzs/form_a1_village_identification/Village_Identification_v3_cut.csv
#Run load script
#psql -h localhost -d ilrg_fzs -U ilrg_fzs -f update_form_a1_village_identification.sql
#cleanup
#rm /home/ubuntu/fzs/form_a1_village_identification/village_identification.zip


#Village governance - 4 CSVs
#Fetch form data, unzip, remove zip
#curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Village_Governance_v4/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_b_village_governance/village_governance.zip
#unzip -o /home/ubuntu/fzs/form_b_village_governance/village_governance.zip -d /home/ubuntu/fzs/form_b_village_governance/
# csvcut removes unneeded ODK Central fields from core and makes sure file is regular
#csvcut -C SubmissionDate,start,intronote,searchtext,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_b_village_governance/Village_Governance_v4.csv > /home/ubuntu/fzs/form_b_village_governance/Village_Governance_v4_cut.csv

#pull images from only last day and unzip into server dir for nginx
#curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Village_Governance_v4/submissions.csv.zip? > /home/ubuntu/fzs/form_b_village_governance/b_img.zip
#unzip -n /home/ubuntu/fzs/form_b_village_governance/b_img.zip "media/*" -d /home/ubuntu/fzs/form_b_village_governance/
#mv /home/ubuntu/fzs/form_b_village_governance/media/* /srv/media/fzs/b/

#Run load script
#psql -h localhost -d ilrg_fzs -U ilrg_fzs -f update_form_b_village_governance.sql
#cleanup
#rm /home/ubuntu/fzs/form_b_village_governance/village_governance.zip
#rm /home/ubuntu/fzs/form_b_village_governance/b_img.zip

#Points of Interest
#Fetch form data, unzip, remove zip
#curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Points_of_Interest_V3/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_d1_points_of_interest/points_of_interest.zip
#unzip -o /home/ubuntu/fzs/form_d1_points_of_interest/points_of_interest.zip -d /home/ubuntu/fzs/form_d1_points_of_interest/
# csvcut removes unneeded ODK Central fields and makes sure file is regular
#csvcut -C SubmissionDate,start,intronote,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_d1_points_of_interest/Points_of_Interest_V3.csv > /home/ubuntu/fzs/form_d1_points_of_interest/Points_of_Interest_V3_cut.csv

#pull images from only last day and unzip into server dir for nginx
#curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Points_of_Interest_V3/submissions.csv.zip?> /home/ubuntu/fzs/form_d1_points_of_interest/d1_img.zip
#unzip -n /home/ubuntu/fzs/form_d1_points_of_interest/d1_img.zip "media/*" -d /home/ubuntu/fzs/form_d1_points_of_interest/
#mv /home/ubuntu/fzs/form_d1_points_of_interest/media/* /srv/media/fzs/d1/
#Run load script
#psql -h localhost -d ilrg_fzs -U ilrg_fzs -f update_form_d1_points_of_interest.sql
#cleanup
#rm /home/ubuntu/fzs/form_d1_points_of_interest/points_of_interest.zip
#rm /home/ubuntu/fzs/form_d1_points_of_interest/d1_img.zip

#Shared Resources
#Fetch form data, unzip, remove zip
#curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Shared_Resources_Areas_V4/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_d2_shared_resources/shared_resources.zip
#unzip -o /home/ubuntu/fzs/form_d2_shared_resources/shared_resources.zip -d /home/ubuntu/fzs/form_d2_shared_resources/
# csvcut removes unneeded ODK Central fields and makes sure file is regular
#csvcut -C SubmissionDate,start,intronote,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_d2_shared_resources/Shared_Resources_Areas_V4.csv > /home/ubuntu/fzs/form_d2_shared_resources/Shared_Resources_Areas_V4_cut.csv
#Run load script
#psql -h localhost -d ilrg_fzs -U ilrg_fzs -f update_form_d2_shared_resources.sql
#cleanup
#rm /home/ubuntu/fzs/form_d2_shared_resources/shared_resources.zip


## TODO: demarcation, claim, evidence, dispute

#Shared Resources
#Fetch form data, unzip, remove zip
curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Meeting_v2/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_i1_meeting/meeting.zip
unzip -o /home/ubuntu/fzs/form_i1_meeting/meeting.zip -d /home/ubuntu/fzs/form_i1_meeting/
# csvcut removes unneeded ODK Central fields and makes sure file is regular
csvcut -C SubmissionDate,start,intronote,searchtext,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_i1_meeting/Meeting_v2.csv > /home/ubuntu/fzs/form_i1_meeting/Meeting_v2_cut.csv
#pull images from only last day and unzip into server dir for nginx
curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Meeting_v2/submissions.csv.zip?> /home/ubuntu/fzs/form_i1_meeting/i1_img.zip
unzip -n /home/ubuntu/fzs/form_i1_meeting/i1_img.zip "media/*" -d /home/ubuntu/fzs/form_i1_meeting/
mv /home/ubuntu/fzs/form_i1_meeting/media/* /srv/media/fzs/i/
#Run load script
#psql -h localhost -d ilrg_fzs -U ilrg_fzs -f update_form_i1_meeting.sql
#cleanup
rm /home/ubuntu/fzs/form_i1_meeting/meeting.zip
rm /home/ubuntu/fzs/form_i1_meeting/i1_img.zip

#Shared Resources
#Fetch form data, unzip, remove zip
curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Demarcation/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_e1_demarcation/Demarcation.zip
unzip -o /home/ubuntu/fzs/form_e1_demarcation/Demarcation.zip -d /home/ubuntu/fzs/form_e1_demarcation/
# csvcut removes unneeded ODK Central fields from core and makes sure file is regular
csvcut -C SubmissionDate,start,my_form_name,text,village_name-searchtext,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_e1_demarcation/Demarcation.csv > /home/ubuntu/fzs/form_e1_demarcation/form_e1_demarcation_cut.csv

#pull images from only last day and unzip into server dir for nginx
curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Demarcation/submissions.csv.zip? > /home/ubuntu/fzs/form_e1_demarcation/e1_img.zip
unzip -n /home/ubuntu/fzs/form_e1_demarcation/e1_img.zip "media/*" -d /home/ubuntu/fzs/form_e1_demarcation/
mv /home/ubuntu/fzs/form_e1_demarcation/media/* /srv/media/fzs/e1/

#Run load script
#psql -h localhost -d ilrg_fzs -U ilrg_fzs -f form_e1_demarcation.sql
#cleanup
rm /home/ubuntu/fzs/form_e1_demarcation/Demarcation.zip
rm /home/ubuntu/fzs/form_e1_demarcation/e1_img.zip


curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Claims/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_e2_claims/claims.zip
unzip -o /home/ubuntu/fzs/form_e2_claims/claims.zip -d /home/ubuntu/fzs/form_e2_claims/
# csvcut removes unneeded ODK Central fields from core and makes sure file is regular
csvcut -C SubmissionDate,start,my_form_name,text,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_e2_claims/Claims.csv > /home/ubuntu/fzs/form_e2_claims/Claims_cut.csv

#pull images from only last day and unzip into server dir for nginx
curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/Claims/submissions.csv.zip? > /home/ubuntu/fzs/form_e2_claims/e2_img.zip
unzip -n /home/ubuntu/fzs/form_e2_claims/e2_img.zip "media/*" -d /home/ubuntu/fzs/form_e2_claims/
mv /home/ubuntu/fzs/form_e2_claims/media/* /srv/media/fzs/e2/

#Run load script
#psql -h localhost -d ilrg_fzs -U ilrg_fzs -f form_e2_claims.sql
#cleanup
rm /home/ubuntu/fzs/form_e2_claims/claims.zip
rm /home/ubuntu/fzs/form_e2_claims/e2_img.zip

#OCC data
#curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/OCC_v2/submissions.csv.zip?attachments=false > /home/ubuntu/fzs/form_f1_occ/OCC_v1.zip
#unzip -o /home/ubuntu/fzs/form_f1_occ/OCC_v1.zip -d /home/ubuntu/fzs/form_f1_occ/
# csvcut removes unneeded ODK Central fields from core and makes sure file is regular
#csvcut -C SubmissionDate,my_form_name,text,start,searchtext_3,end,"meta-instanceID","meta-instanceName",SubmitterID,SubmitterName,AttachmentsPresent,AttachmentsExpected,Status,DeviceID,Edits /home/ubuntu/fzs/form_f1_occ/OCC_v1.csv > /home/ubuntu/fzs/form_f1_occ/occ_cut.csv

#pull images from only last day and unzip into server dir for nginx
#curl -u na@noemail.com:ilrgviewer https://ilrg.ddns.net/v1/projects/3/forms/OCC_v2/submissions.csv.zip? > /home/ubuntu/fzs/form_f1_occ/f1_img.zip
#unzip -n /home/ubuntu/fzs/form_f1_occ/f1_img.zip "media/*" -d /home/ubuntu/fzs/form_f1_occ/
#mv /home/ubuntu/fzs/form_f1_occ/media/* /srv/media/fzs/f1/

#Run load script
#psql -h localhost -d ilrg_fzs -U ilrg_fzs -f form_f1_occ.sql
#cleanup
#rm /home/ubuntu/fzs/form_f1_occ/OCC_v1.zip
#rm /home/ubuntu/fzs/form_f1_occ/f1_img.zip
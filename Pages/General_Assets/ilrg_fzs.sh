#!/bin/sh

psql --host=localhost --port=5432 --dbname=ilrg_fzs --username=kaoma     <<OMG
BEGIN;

\i /home/ubuntu/fzs/update_form_b_village_governance.sql

\i /home/ubuntu/fzs/update_form_a1_village_identification.sql

\i /home/ubuntu/fzs/update_form_d1_points_of_interest.sql

\i /home/ubuntu/fzs/update_form_d2_shared_resources.sql

\i /home/ubuntu/fzs/update_form_i1_meeting.sql

\i /home/ubuntu/fzs/update_form_e1_demarcation.sql

\i /home/ubuntu/fzs/update_form_e1_demarcation_witness.sql

\i /home/ubuntu/fzs/update_form_e2_claims.sql

\i /home/ubuntu/fzs/update_form_e2_claims_parties.sql



COMMIT;
OMG
#eof
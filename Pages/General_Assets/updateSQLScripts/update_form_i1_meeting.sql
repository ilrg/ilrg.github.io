CREATE TABLE "update".meeting_temp (
	geom geometry(point, 4326) NULL,
	organization text NULL,
	organization_other text NULL,
	tec_name text NULL,
    tec_given_name text NULL,
    tec_family_name text NULL,
	"date" timestamp NULL,
	jurisdiction text NULL,
    jur_other text NULL,
	village text NULL,
    village_other text NULL,
    latitude numeric(38, 10) NULL,
    longitude numeric(38, 10) NULL,
	altitude numeric(38, 10) NULL,
	accuracy numeric(38, 10) NULL,
	meeting_category text NULL,
	meeting_type text NULL,
	meeting_type_other text NULL,
    meeting_title text NULL,
    meeting_days text NULL,
	has_conflict text NULL,
	includes_gender text NULL,
    includes_bio_wildlife  text NULL,
    includes_forest_mgmt  text NULL,
    includes_micro_ent text NULL,
    includes_land_based  text NULL,
	conflict_details text NULL,
    conflict_groups text NULL,
	gender_details text NULL,
	female_attending int4 NULL,
	male_attending int4 NULL,
	female_youth_attending int4 NULL,
	male_youth_attending int4 NULL,
    training_curriculum text NULL,
    training_goals text NULL,
    training_objectives text NULL,
    training_objectives_no text NULL,
	photo_meeting text NULL,
	observation  text NULL,
	"key" varchar(80) NOT NULL,
    ReviewState text NULL
);

-- Copy data from CSV export
-- Column names here must correspond to the CSV export columns IN ORDER. There is some variance in column names from the ODK exports, which should mirror database standards under Phase 1
copy "update".meeting_temp(organization, organization_other, tec_name, tec_given_name, tec_family_name, date, jurisdiction, jur_other, village, village_other, latitude, longitude, altitude, accuracy, meeting_category, meeting_type, meeting_type_other, meeting_title, meeting_days, has_conflict, includes_gender, includes_bio_wildlife, includes_forest_mgmt, includes_micro_ent, includes_land_based, conflict_details, conflict_groups, gender_details, female_attending, male_attending, female_youth_attending, male_youth_attending, training_curriculum, training_goals, training_objectives, training_objectives_no, photo_meeting, observation, key, ReviewState)
from '/home/ubuntu/fzs/form_i1_meeting/Meeting_v2_cut.csv'
DELIMITER ','
CSV HEADER;

-- Insert only new items
-- Same column names as above, same order
INSERT INTO update.form_i1_meeting(
	geom, organization, tec_name, date, jurisdiction, village, latitude, longitude, altitude, accuracy, meeting_category, meeting_type, meeting_title, meeting_days, has_conflict, includes_gender, includes_bio_wildlife, includes_forest_mgmt, includes_micro_ent, includes_land_based, conflict_details, conflict_groups, gender_details, female_attending, male_attending, female_youth_attending, male_youth_attending, training_curriculum, training_goals, training_objectives, training_objectives_no, photo_meeting, observation, key, reviewstate)
	
SELECT
	geom,
	
	CASE WHEN  meeting_temp.organization::text = 'other' THEN meeting_temp.organization_other
	 ELSE table_org.org_label::text 
	 END AS organization,
	 
	table_enumerator.name::text,
	date::date,
	
	CASE WHEN  meeting_temp.jurisdiction::text = 'other' THEN meeting_temp.jur_other
	 ELSE tj.jurisdiction_label::text 
	 END AS jurisdiction,
	 
	CASE WHEN  meeting_temp.village::text = '1' THEN meeting_temp.village_other
	 ELSE tv.village::text 
	 END AS village,
	
	latitude,
	longitude,
	altitude,
	accuracy,
	
	table_meeting_category.meeting_label::text,
	
	CASE WHEN  meeting_temp.meeting_type::text = 'other' THEN meeting_temp.meeting_type_other
	 ELSE table_meeting_type.meeting_type_label::text 
	 END AS meeting_type,
	 
	meeting_title::text,
	table_days.days_label::text,
	has_conflict::text,
	includes_gender::text,
	includes_bio_wildlife::text,
	includes_forest_mgmt::text,
	includes_micro_ent::text,
	includes_land_based::text,
	conflict_details::text,
	conflict_groups::text,
	gender_details::text,
	female_attending::integer,
	male_attending::integer,
	female_youth_attending::integer,
	male_youth_attending::integer,
	training_curriculum::text,
	training_goals::text,
	training_objectives::text,
	training_objectives_no::text,
	photo_meeting::text,
	observation::text,
	key::text,
	reviewstate::text
FROM update.meeting_temp
	LEFT OUTER JOIN "update".table_org ON ( meeting_temp.organization = table_org.org_name  )
	LEFT OUTER JOIN "public".table_enumerator ON ( meeting_temp.tec_name = table_enumerator.code  )
	LEFT OUTER JOIN "update".table_jurisdiction tj ON ( meeting_temp.jurisdiction = tj.jurisdiction_name  )
	LEFT OUTER JOIN "public".table_village tv ON ( meeting_temp.village = tv.code  )
	LEFT OUTER JOIN "update".table_meeting_category ON ( meeting_temp.meeting_category = table_meeting_category.meeting_name  )
	LEFT OUTER JOIN "update".table_meeting_type ON ( meeting_temp.meeting_type = table_meeting_type.meeting_type_name  )
	LEFT OUTER JOIN "update".table_days ON ( meeting_temp.meeting_days = table_days.days_name  )
WHERE meeting_temp.key NOT IN (SELECT KEY FROM "update".form_i1_meeting) AND meeting_temp.key NOT IN (SELECT KEY FROM public.form_i1_meeting);

-- Set photo URLs where they exists
/*update "update".form_i1_meeting
set photo_meeting = concat('http://13.244.91.45:90/media/fzs/i/',photo_meeting)
where length(photo_meeting) = 17;*/
update "update".form_b_governance_village_register
set photo = concat('http://13.244.91.45:90/media/fzs/i/'||photo)
where length(photo) = 17;

update update.form_i1_meeting
set photo_meeting = concat('http://13.244.91.45:90/media/fzs/i/'||photo_meeting)
where length(photo_meeting) = 17;

-- Drop temp
drop table "update".meeting_temp;

update "update".form_i1_meeting
set geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
where geom is NULL;

--update public schema meeting table
INSERT INTO public.form_i1_meeting(
	geom, organization, tec_name, date, jurisdiction, village, latitude, longitude, altitude, accuracy, meeting_category, meeting_type, meeting_title, meeting_days, has_conflict, includes_gender, includes_bio_wildlife, includes_forest_mgmt, includes_micro_ent, includes_land_based, conflict_details, conflict_groups, gender_details, female_attending, male_attending, female_youth_attending, male_youth_attending, training_curriculum, training_goals, training_objectives, training_objectives_no, photo_meeting, observation, key)

SELECT geom, organization, tec_name, date, jurisdiction, village, latitude, longitude, altitude, accuracy, meeting_category, meeting_type, meeting_title, meeting_days, has_conflict, includes_gender, includes_bio_wildlife, includes_forest_mgmt, includes_micro_ent, includes_land_based, conflict_details, conflict_groups, gender_details, female_attending, male_attending, female_youth_attending, male_youth_attending, training_curriculum, training_goals, training_objectives, training_objectives_no, photo_meeting, observation, key
	FROM update.form_i1_meeting
	WHERE form_i1_meeting.key NOT IN (SELECT KEY FROM public.form_i1_meeting);
	
DELETE FROM update.form_i1_meeting
USING public.form_i1_meeting
WHERE update.form_i1_meeting.key = public.form_i1_meeting.key;

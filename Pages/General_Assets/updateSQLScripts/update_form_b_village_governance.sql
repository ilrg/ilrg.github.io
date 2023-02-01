-- Core Governance table
-- Build temp table
CREATE TABLE "update".governance_temp (
    tec_name text NULL,
	"date" date NULL,
	jurisdiction text NULL,
    jur_other text NULL,
	vag text null,
	vag_other text null,
	village text NULL,
	village_other text NULL,
	district text NULL,
	district_other text NULL,
	ward text NULL,
	ward_other varchar NULL,
	induna_given_name text NULL,
	induna_family_name text NULL,
	induna_gender text null,
	induna_contact text null,
	induna_head_year text NULL,
	headman_given_name text NULL,
	headman_family_name text NULL,
	gender text NULL,
	contact_number text NULL,
	headperson_year_appointed date NULL,
	village_register text NULL,
	village_household_number text NULL,
	year_village_established date NULL,
	reason_establish text NULL,
	village_moved text NULL,
	village_divided text NULL,
	village_moved_when date NULL,
	village_reason_moved text NULL,
	village_reason_divided text NULL,
	community_conflict text NULL,
	neighbour_conflict text NULL,
	government_conflict text NULL,
	investor_conflict text NULL,
	village_recognized text NULL,
	community_conflict_reason text NULL,
	neighbour_conflict_reason text NULL,
	government_conflict_reason text NULL,
	investor_conflict_reason text NULL,
	community_agric_expansion text NULL,
	forest_governance text NULL,
	commitee_or_groups text NULL,
	resource_mapping_consent text NULL,
	household_land_certification_consent text NULL,
	land_use_planning_consent text NULL,
	data_use_consent text NULL,
	national_sys text NULL,
	community_representative_consent text NULL,
	signature text NULL,
	resource_mapping_no_consent_reason text NULL,
	household_land_certification_no_consent_reason text NULL,
	land_use_planning_no_consent_reason text NULL,
	data_use_no_consent_reason text NULL,
	community_representative_no_consent_reason text NULL,
	map_group_narrative text NULL,
    map_state_land text NULL,
    map_state_land_desc text NULL,
    map_private_land text NULL,
    map_private_land_desk text NULL,
    participate_men text NULL,
    participate_women text NULL,
    participate_youth_men text NULL,
    participate_youth_women text NULL,
    headperson_supportive text NULL,
    gender_supportive text NULL,
    inclusion_support text NULL,
    youth_supportive text NULL,
	"comment" text NULL,
	meeting_image text NULL,
	"key" varchar(80) NOT NULL,
	ReviewState text NULL
);


-- Copy data from CSV export
-- Column names here must correspond to the CSV export columns IN ORDER. There is some variance in column names from the ODK exports, which should mirror database standards under Phase 1
copy "update".governance_temp(tec_name,"date",jurisdiction,jur_other,vag,vag_other,village,village_other,district,district_other,ward,ward_other,induna_given_name,induna_family_name,induna_gender, induna_contact, induna_head_year,headman_given_name,headman_family_name,gender,contact_number,headperson_year_appointed,village_register,village_household_number,year_village_established,reason_establish,village_moved,village_divided,village_moved_when,village_reason_moved,village_reason_divided,community_conflict,neighbour_conflict,government_conflict,investor_conflict,village_recognized,community_conflict_reason,neighbour_conflict_reason,government_conflict_reason,investor_conflict_reason,community_agric_expansion,forest_governance,commitee_or_groups,resource_mapping_consent,household_land_certification_consent,land_use_planning_consent,data_use_consent,national_sys,community_representative_consent,signature,resource_mapping_no_consent_reason,household_land_certification_no_consent_reason,land_use_planning_no_consent_reason,data_use_no_consent_reason,community_representative_no_consent_reason,map_group_narrative,map_state_land,map_state_land_desc,map_private_land,map_private_land_desk,participate_men,participate_women,participate_youth_men,participate_youth_women,headperson_supportive,gender_supportive,inclusion_support,youth_supportive,"comment",meeting_image,"key", ReviewState)
FROM '/home/ubuntu/fzs/form_b_village_governance/Village_Governance_v4_cut.csv'
DELIMITER ','
CSV HEADER;

-- Insert only new items
-- Same column names as above, same order
INSERT INTO update.form_b_village_governance(
	tec_name, date, jurisdiction, vag, village, district, ward, induna_given_name, induna_family_name, induna_gender, induna_contact, induna_head_year, headman_given_name, headman_family_name, gender, contact_number, headperson_year_appointed, village_register, village_household_number, year_village_established, reason_establish, village_moved, village_divided, village_moved_when, village_reason_moved, village_reason_divided, community_conflict, neighbour_conflict, government_conflict, investor_conflict, village_recognized, community_conflict_reason, neighbour_conflict_reason, government_conflict_reason, investor_conflict_reason, community_agric_expansion, forest_governance, commitee_or_groups, resource_mapping_consent, household_land_certification_consent, land_use_planning_consent, data_use_consent, national_sys, community_representative_consent, signature, resource_mapping_no_consent_reason, household_land_certification_no_consent_reason, land_use_planning_no_consent_reason, data_use_no_consent_reason, community_representative_no_consent_reason, map_group_narrative, map_state_land, map_state_land_desc, map_private_land, map_private_land_desk, participate_men, participate_women, participate_youth_men, participate_youth_women, headperson_supportive, gender_supportive, inclusion_support, youth_supportive, comment, meeting_image, key, reviewstate)
	

SELECT 
	 te.name,
	 gt."date"::date as date,
		 
	 CASE WHEN  gt.jurisdiction::text = 'other' THEN gt.jur_other
	 ELSE tj.jurisdiction_label::text 
	 END AS jurisdiction,
	 
	 CASE WHEN  gt.vag::text = 'other' THEN gt.vag_other
	 ELSE gt.vag::text 
	 END AS vag,
	 
	 CASE WHEN  gt.village::text = '1' THEN gt.village_other
	 ELSE tv.village::text 
	 END AS village,
	 
	 CASE WHEN  gt.district::text = 'other' THEN gt.district_other
	 ELSE gt.district::text 
	 END AS district,
	 
	 CASE WHEN  gt.ward::text = 'other' THEN gt.ward_other
	 ELSE gt.ward::text 
	 END AS ward,
	 
	 gt.induna_given_name::text as induna_given_name,
	 gt.induna_family_name::text as induna_family_name,
	 tg.gender_label::text induna_gender,
	 gt.induna_contact::integer as induna_contact,
	 gt.induna_head_year::date as induna_appointed_year,
	 gt.headman_given_name::text as headperson_given_name,
	 gt.headman_family_name::text as headperson_given_name,
	 tg1.gender_label::text as headperson_gender,
	 gt.contact_number::text as headperson_contact,
	 gt.headperson_year_appointed::date as headperson_year_appointed,
	 gt.village_register::text as village_register,
	 gt.village_household_number::integer as household_number,
	 gt.year_village_established::date as village_year_established,
	 gt.reason_establish::text as reason_establish,
	 gt.village_moved::text as village_moved,
	 gt.village_divided::text as village_divided,
	 gt.village_moved_when::date as village_moved,
	 gt.village_reason_moved::text as reason_moved,
	 gt.village_reason_divided::text as reason_divided,
	 gt.community_conflict::text as community_conflict, 
	 gt.neighbour_conflict::text as neighbour_conflict,
	 gt.government_conflict::text as government_conflict,
	 gt.investor_conflict::text as investor_conflict,
	 gt.village_recognized::text as village_recognized,
	 gt.community_conflict_reason::text as community_conflict_reason,
	 gt.neighbour_conflict_reason::text neighbour_conflict_reason,
	 gt.government_conflict_reason::text government_conflict_reason,
	 gt.investor_conflict_reason::text as investor_conflict_reason,
	 gt.community_agric_expansion::text as community_agric_expansion,
	 gt.forest_governance::text as forest_governance,
	 gt.commitee_or_groups::text as committee,
	 gt.resource_mapping_consent::text as resource_mapping_consent,
	 gt.household_land_certification_consent::text as household_land_certification_consent,
	 gt.land_use_planning_consent::text as land_use_planning_consent,
	 gt.data_use_consent::text as data_use_consent,
	 gt.national_sys::text as national_sys,
	 gt.community_representative_consent::text as community_representative_consent,
	 gt.signature::text as signature,
	 gt.resource_mapping_no_consent_reason::text as resource_mapping_no_consent_reason,
	 gt.household_land_certification_no_consent_reason::text as certification_no_consent_reason,
	 gt.land_use_planning_no_consent_reason::text as land_use_planning_no_consent_reason,
	 gt.data_use_no_consent_reason::text as data_use_no_consent_reason,
	 gt.community_representative_no_consent_reason::text as repressentative_no_consent_reason,
	 gt.map_group_narrative::text as map_group_narrative,
	 gt.map_state_land::text as state_land,
	 gt.map_state_land_desc::text as state_land_description,
	 gt.map_private_land::text as private_land,
	 gt.map_private_land_desk::text as private_land_desk,
	 tp.participation_label::text as men_participation,
	 tp1.participation_label::text as women_participation,
	 tp2.participation_label::text as youth_men_participation,
	 tp3.participation_label::text as youth_women_participation,
	 ts.supportive_label::text as headperson_supportive,
	 ts1.supportive_label::text as headperson_gender_supportive,
	 ts2.supportive_label::text as inclusion_support,
	 ts3.supportive_label::text as youth_supportive,
	 gt."comment",
	 gt.meeting_image,
	 gt."key",
	 gt.reviewstate
FROM "update".governance_temp gt 
	LEFT OUTER JOIN "public".table_enumerator te ON ( gt.tec_name = te.code  )  
	LEFT OUTER JOIN "update".table_jurisdiction tj ON ( gt.jurisdiction = tj.jurisdiction_name  )  
	LEFT OUTER JOIN "public".table_village tv ON ( gt.village = tv.code  )  
	LEFT OUTER JOIN "update".table_gender tg ON ( gt.induna_gender = tg.gender_name  )  
	LEFT OUTER JOIN "update".table_gender tg1 ON ( gt.gender = tg1.gender_name  )  
	LEFT OUTER JOIN "update".table_participation tp ON ( gt.participate_men = tp.participation_name  )  
	LEFT OUTER JOIN "update".table_participation tp1 ON ( gt.participate_women = tp1.participation_name  )  
	LEFT OUTER JOIN "update".table_participation tp2 ON ( gt.participate_youth_men = tp2.participation_name  )  
	LEFT OUTER JOIN "update".table_participation tp3 ON ( gt.participate_youth_women = tp3.participation_name  )  
	LEFT OUTER JOIN "update".table_supportive ts ON ( gt.headperson_supportive = ts.supportive_name  )  
	LEFT OUTER JOIN "update".table_supportive ts1 ON ( gt.gender_supportive = ts1.supportive_name  )  
	LEFT OUTER JOIN "update".table_supportive ts2 ON ( gt.inclusion_support = ts2.supportive_name  )  
	LEFT OUTER JOIN "update".table_supportive ts3 ON ( gt.youth_supportive = ts3.supportive_name  )  
WHERE  gt.key NOT IN (SELECT KEY FROM "update".form_b_village_governance) AND gt.key NOT IN (SELECT KEY FROM public.form_b_village_governance);

-- Drop temp
DROP TABLE "update".governance_temp;

----------------------------------
-- Governance development subtable
-- Temp table
CREATE TABLE "update".development_temp (
	development_actors text NULL,
	development_actors_other text NULL,
	village_actor_issues text NULL,
	relation_dev int8 null,
	village text NULL,
	parent_key varchar(80) NULL,
	"key" varchar(80) NOT NULL
);
-- Copy from CSV
copy "update".development_temp(development_actors, development_actors_other, village_actor_issues, relation_dev, village, parent_key, key)
from '/home/ubuntu/fzs/form_b_village_governance/Village_Governance_v4-development.csv'
DELIMITER ','
CSV HEADER;

-- remove chi_ and chf_ from the village code.
UPDATE update.development_temp
SET village = SUBSTRING (update.development_temp.village, 5, 50);

--alter column relation_dev to character varying
ALTER TABLE update.development_temp ALTER COLUMN relation_dev TYPE CHARACTER VARYING USING relation_dev::CHARACTER VARYING;

-- Insert only new items
insert into "update".form_b_governance_development(development_actors, development_actors_other, village_actor_issues, village, parent_key, key)
SELECT 
	 CASE WHEN  dt.development_actors::text = 'other' THEN dt.development_actors_other
	 ELSE td.development_label::text 
	 END AS development_actors,
	 
	 dt.village_actor_issues,
	 tdr.development_relate_label,
	 
	 CASE WHEN  dt.village::text NOT IN (SELECT CODE FROM "public".table_village) THEN dt.village
	 ELSE tv.village::text 
	 END AS village,
	
	 dt.parent_key,
	 dt."key"
	 
FROM "update".development_temp dt 
	LEFT OUTER JOIN "update".table_development td ON ( dt.development_actors = td.development_name  )  
	LEFT OUTER JOIN "update".table_development_relate tdr ON ( dt.relation_dev = tdr.development_relate_name  )  
	LEFT OUTER JOIN "public".table_village tv ON ( dt.village = tv.code  )
WHERE  dt.key NOT IN (SELECT KEY FROM "update".form_b_governance_development) AND  dt.key NOT IN (SELECT KEY FROM public.form_b_governance_development);

-- Remove 1 from all new villages
UPDATE update.form_b_governance_development
SET village = SUBSTRING (update.form_b_governance_development.village, 2, 50)
WHERE village LIKE '%1%';

-- Drop temp
drop table "update".development_temp;

---------------------------
-- Governance maps subtable
-- Temp table
CREATE TABLE "update".map_temp (
	map_notes text NULL,
	photo text NULL,
	map_author text NULL,
	parent_key varchar(80) NULL,
	"key" varchar(80) NOT NULL
);
-- Copy from CSV
copy "update".map_temp(map_notes, photo, map_author, parent_key, key)
from '/home/ubuntu/fzs/form_b_village_governance/Village_Governance_v4-maps.csv'
DELIMITER ','
CSV HEADER;
-- Insert only new items
insert into "update".form_b_governance_group_maps(photo, map_notes, map_author, parent_key, key)

SELECT 
	mt.photo,
	mt.map_notes,
	tm.maps_label,
	mt.parent_key,
	mt."key"
FROM "update".map_temp mt
	LEFT OUTER JOIN "update".table_maps tm ON (mt.map_author = tm.maps_name)
WHERE mt."key" NOT IN (SELECT KEY FROM "update".form_b_governance_group_maps) AND  mt.key NOT IN (SELECT KEY FROM public.form_b_governance_group_maps);	

-- Add image URLs where they don't exist
update update.form_b_governance_group_maps
set photo = concat('http://13.244.91.45:90/media/fzs/b/'||photo)
where length(photo) = 17;
-- Drop temp
drop table "update".map_temp;

---------------------------------------
-- Governance village register subtable
-- Temp table
CREATE TABLE "update".register_temp (
	register_notes text NULL,
	village text NULL,
	photo text NULL,
	"key" varchar(80) NOT NULL,
	parent_key varchar(80) NULL
);
-- Copy from CSV
copy "update".register_temp(register_notes, village, photo, parent_key, key)
from '/home/ubuntu/fzs/form_b_village_governance/Village_Governance_v4-register.csv'
DELIMITER ','
CSV HEADER;

-- remove chi_ and chf_ from the village code.
UPDATE update.register_temp
SET village = SUBSTRING (update.register_temp.village, 5, 50);


-- Insert only new items
insert into "update".form_b_governance_village_register(register_notes, village, photo, parent_key, key)

SELECT
register_notes,

CASE WHEN  register_temp.village::text NOT IN (SELECT CODE FROM "public".table_village) THEN register_temp.village
	 ELSE tv.village::text 
	 END AS village,
	 
photo,
parent_key,
key

FROM "update".register_temp
LEFT OUTER JOIN "public".table_village tv ON ( register_temp.village = tv.code  )
WHERE  update.register_temp.key NOT IN (SELECT KEY FROM update.form_b_governance_village_register) AND  update.register_temp.key NOT IN (SELECT KEY FROM public.form_b_governance_village_register);

-- Remove 1 from all new villages
UPDATE update.form_b_governance_village_register
SET village = SUBSTRING (update.form_b_governance_village_register.village, 2, 50)
WHERE village LIKE '%1%';

-- Add image URLs where they don't exist
/*update "update".form_b_governance_village_register
set photo = concat('https/ilrg.ddns.net/v1/projects/3/forms/Village_Governance_v4/submissions/',parent_key,'/attachments/',photo)
where length(photo) = 17;*/
update update.form_b_village_governance
set signature = concat('http://13.244.91.45:90/media/fzs/b/'||signature)
where length(signature) = 17;

update update.form_b_village_governance
set meeting_image = concat('http://13.244.91.45:90/media/fzs/b/'||meeting_image)
where length(meeting_image) = 17;

-- Drop temp
drop table "update".register_temp;

--update public schema governance table
INSERT INTO public.form_b_village_governance(
	tec_name, date, jurisdiction, vag, village, district, ward, induna_given_name, induna_family_name, induna_gender, induna_contact, induna_head_year, headman_given_name, headman_family_name, gender, contact_number, headperson_year_appointed, village_register, village_household_number, year_village_established, reason_establish, village_moved, village_divided, village_moved_when, village_reason_moved, village_reason_divided, community_conflict, neighbour_conflict, government_conflict, investor_conflict, village_recognized, community_conflict_reason, neighbour_conflict_reason, government_conflict_reason, investor_conflict_reason, community_agric_expansion, forest_governance, commitee_or_groups, resource_mapping_consent, household_land_certification_consent, land_use_planning_consent, data_use_consent, national_sys, community_representative_consent, signature, resource_mapping_no_consent_reason, household_land_certification_no_consent_reason, land_use_planning_no_consent_reason, data_use_no_consent_reason, community_representative_no_consent_reason, map_group_narrative, map_state_land, map_state_land_desc, map_private_land, map_private_land_desk, participate_men, participate_women, participate_youth_men, participate_youth_women, headperson_supportive, gender_supportive, inclusion_support, youth_supportive, comment, meeting_image, key)

SELECT tec_name, date, jurisdiction, vag, village, district, ward, induna_given_name, induna_family_name, induna_gender, induna_contact, induna_head_year, headman_given_name, headman_family_name, gender, contact_number, headperson_year_appointed, village_register, village_household_number, year_village_established, reason_establish, village_moved, village_divided, village_moved_when, village_reason_moved, village_reason_divided, community_conflict, neighbour_conflict, government_conflict, investor_conflict, village_recognized, community_conflict_reason, neighbour_conflict_reason, government_conflict_reason, investor_conflict_reason, community_agric_expansion, forest_governance, commitee_or_groups, resource_mapping_consent, household_land_certification_consent, land_use_planning_consent, data_use_consent, national_sys, community_representative_consent, signature, resource_mapping_no_consent_reason, household_land_certification_no_consent_reason, land_use_planning_no_consent_reason, data_use_no_consent_reason, community_representative_no_consent_reason, map_group_narrative, map_state_land, map_state_land_desc, map_private_land, map_private_land_desk, participate_men, participate_women, participate_youth_men, participate_youth_women, headperson_supportive, gender_supportive, inclusion_support, youth_supportive, comment, meeting_image, key
	FROM update.form_b_village_governance
	WHERE  update.form_b_village_governance.key NOT IN (SELECT KEY FROM public.form_b_village_governance);

DELETE FROM update.form_b_village_governance
USING public.form_b_village_governance
WHERE update.form_b_village_governance.key = public.form_b_village_governance.key;


--update public schema development table
INSERT INTO public.form_b_governance_development(
	development_actors, development_actors_other, village_actor_issues, village, parent_key, key, relation_dev)

SELECT development_actors, development_actors_other, village_actor_issues, village, parent_key, key, relation_dev
	FROM update.form_b_governance_development
	WHERE  update.form_b_governance_development.key NOT IN (SELECT KEY FROM public.form_b_governance_development);

DELETE FROM update.form_b_governance_development
USING public.form_b_governance_development
WHERE update.form_b_governance_development.key = public.form_b_governance_development.key;
	
--update public schema maps table
INSERT INTO public.form_b_governance_group_maps(
	photo, map_notes, map_author, key, parent_key)

SELECT photo, map_notes, map_author, key, parent_key
	FROM update.form_b_governance_group_maps
	WHERE  update.form_b_governance_group_maps.key NOT IN (SELECT KEY FROM public.form_b_governance_group_maps);
	
DELETE FROM update.form_b_governance_group_maps
USING public.form_b_governance_group_maps
WHERE update.form_b_governance_group_maps.key = public.form_b_governance_group_maps.key;

--update public schema register table
INSERT INTO public.form_b_governance_village_register(
	register_notes, village, photo, key, parent_key)

SELECT register_notes, village, photo, key, parent_key
	FROM update.form_b_governance_village_register
	WHERE  update.form_b_governance_village_register.key NOT IN (SELECT KEY FROM public.form_b_governance_village_register);
	
DELETE FROM update.form_b_governance_village_register
USING public.form_b_governance_village_register
WHERE update.form_b_governance_village_register.key = public.form_b_governance_village_register.key;
	
	
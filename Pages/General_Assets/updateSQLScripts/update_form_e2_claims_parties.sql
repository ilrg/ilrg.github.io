-- Build temp table
CREATE TABLE "update".claims_parties_temp (
	parcel_parties text,
	party_role text,
	relationship text,
	relationship_other text,
	tenure_acquisition text,
	other_tenure_acquisition text,
	tenure_responsibilities text,
	other_responsibilities text,
	tenure_restrictions text,
	other_restrictions text,
	tenure_rights text,
	other_rights text,
	tenure_status text,
	witness_relationship text,
	other_witness text,
	prefix_name text,
	prefix_other text,
	given_name text,
	middle_name text,
	family_name text,
	suffix_name text,
	suffix_other text,
	gender text,
	civil_status text,
	age text,
	birthdate date,
	year_of_birth text,
	age_range text,
	nationality text,
	other_nationality text, 
	party_availability text,
	passport_photo text,
	id_availability text,
	id_type text,
	nrc_number text,
	passport_number text,
	driving_licence_number text,
	formal_id text,
	formal_id_number text,
	id_photo_front text,
	id_photo_back text,
	address_type text,
	province text,
	chiefdom text,
	other_chiefdom text,
	vag text,
	vag_other text,
	searchtext text,
	village_id text,
	other_village text,
	address_Line_1 text,
	address_line_2 text,
	address_town_or_city text,
	address_urban_province text,
	telephone_location_t1 text,
	telephone_main_za text,
	telephone_main_za_02 text,
	telephone_location_t2 text,
	telephone_main_zb text,
	telephone_main_ib text,
	email text,
	anp_add_parties_parcel_details text,
	PARENT_KEY text,
	KEY text
);

copy "update".claims_parties_temp FROM '/home/ubuntu/fzs/form_e2_claims/Claims-group_parties_physical.csv'
DELIMITER ','
CSV HEADER;

UPDATE update.claims_parties_temp
SET province = 'Eastern'
where province = 'ZM30';

UPDATE update.claims_parties_temp
SET chiefdom = 'Chifunda'
where chiefdom = 'CHF';

UPDATE update.claims_parties_temp
SET chiefdom = 'Chikwa'
where chiefdom = 'CHI';

--update update.form_e2_claims_parties
INSERT INTO update.form_e2_claims_parties(
	parcel_parties, party_role, relationship, tenure_acquisition, tenure_responsibilities, tenure_restrictions, tenure_rights, tenure_status, witness_relationship, prefix_name, given_name, middle_name, family_name, suffix_name, gender, civil_status, birthdate, year_of_birth, age_range, nationality, party_photo, id_type, nrc_number, passport_number, driving_licence, formal_id, formal_id_number, id_photo_front, id_photo_back, address_type, province, chiefdom, vag, village_id, address_line_1, address_line_2, address_town_or_city, address_urban_province, primary_contact_zm, primary_contact_in, secondary_contact_zm, secondary_contact_in, email, parent_key, key)
	
SELECT
    parcel_parties::text,
    table_pp_role.label::text as party_role,
	
	CASE WHEN  claims_parties_temp.relationship::text = 'other' THEN claims_parties_temp.relationship_other
	 ELSE table_relationship.label::text 
	 END AS relationship,
	 
	CASE WHEN  claims_parties_temp.tenure_acquisition::text = 'other' THEN claims_parties_temp.other_tenure_acquisition
	 ELSE table_tenure_acquisition.label::text 
	 END AS tenure_acquisition,
	 
	CASE WHEN  claims_parties_temp.tenure_responsibilities::text = 'other' THEN claims_parties_temp.other_responsibilities
	 ELSE table_responsibilities.label::text 
	 END AS tenure_responsibilities,
	 
	CASE WHEN  claims_parties_temp.tenure_restrictions::text = 'other' THEN claims_parties_temp.other_restrictions
	 ELSE table_restrictions.label::text 
	 END AS tenure_restrictions,
	 
	CASE WHEN  claims_parties_temp.tenure_rights::text = 'other' THEN claims_parties_temp.other_rights
	 ELSE table_rights.label::text 
	 END AS tenure_rights,
	 
	table_tenure_status.label::text as tenure_status,
	CASE WHEN  claims_parties_temp.witness_relationship::text = 'other' THEN claims_parties_temp.other_witness
	 ELSE table_witness_type.label::text 
	 END AS witness_relationship,
	 
	CASE WHEN  claims_parties_temp.prefix_name::text = 'other' THEN claims_parties_temp.prefix_other
	 ELSE table_prefix.label::text 
	 END AS prefix_name,
	 
    given_name::text COLLATE pg_catalog."default",
    middle_name::text COLLATE pg_catalog."default",
    family_name::text COLLATE pg_catalog."default",
	
	CASE WHEN  claims_parties_temp.suffix_name::text = 'other' THEN claims_parties_temp.suffix_other
	 ELSE table_suffix.label::text 
	 END AS suffix_name,
	 
	table_gender.gender_label::text,
	table_civil_status.label::text,
    birthdate::date,
    LEFT(year_of_birth, 4)::integer as year_of_birth,
    table_age_range.age_range_label::text as age_range,
	
	CASE WHEN  claims_parties_temp.nationality::text = 'other' THEN claims_parties_temp.other_nationality
	 ELSE claims_parties_temp.nationality::text 
	 END AS nationality,

    passport_photo::text COLLATE pg_catalog."default",
	table_documents_dem.label::text as id_type,
    nrc_number::text COLLATE pg_catalog."default",
    passport_number::text COLLATE pg_catalog."default",
    driving_licence_number::text COLLATE pg_catalog."default",
    formal_id::text COLLATE pg_catalog."default",
    formal_id_number::text COLLATE pg_catalog."default",
    id_photo_front::text COLLATE pg_catalog."default",
    id_photo_back::text COLLATE pg_catalog."default",
	table_address_type.label::text as address_type,
    province::text COLLATE pg_catalog."default",
	
	CASE WHEN  claims_parties_temp.chiefdom::text = 'other' THEN claims_parties_temp.other_chiefdom
	 ELSE claims_parties_temp.chiefdom::text 
	 END AS chiefdom,
	 
	CASE WHEN  claims_parties_temp.vag::text = 'other' THEN claims_parties_temp.vag_other
	 ELSE claims_parties_temp.vag::text 
	 END AS vag,
	 
	CASE WHEN  claims_parties_temp.village_id::text = '1' THEN claims_parties_temp.other_village
	 ELSE tv.village::text 
	 END AS village,
	 
    address_line_1::text COLLATE pg_catalog."default",
    address_line_2::text COLLATE pg_catalog."default",
    address_town_or_city::text COLLATE pg_catalog."default",
    address_urban_province::text COLLATE pg_catalog."default",
    telephone_main_za::numeric,
    telephone_main_za_02::numeric,
    telephone_main_zb::numeric ,
    telephone_main_ib::numeric ,
    email::text COLLATE pg_catalog."default",
    parent_key::text COLLATE pg_catalog."default",
    key::text COLLATE pg_catalog."default"
FROM update.claims_parties_temp
	LEFT OUTER JOIN "update".table_pp_role ON ( claims_parties_temp.party_role = table_pp_role.name  )
	LEFT OUTER JOIN "update".table_relationship ON ( claims_parties_temp.relationship = table_relationship.name  )
	LEFT OUTER JOIN "update".table_tenure_acquisition ON ( claims_parties_temp.tenure_acquisition = table_tenure_acquisition.name  )
	LEFT OUTER JOIN "update".table_responsibilities ON ( claims_parties_temp.tenure_responsibilities = table_responsibilities.name  )
	LEFT OUTER JOIN "update".table_restrictions ON ( claims_parties_temp.tenure_restrictions = table_restrictions.name  )
	LEFT OUTER JOIN "update".table_rights ON ( claims_parties_temp.tenure_rights = table_rights.name  )
	LEFT OUTER JOIN "update".table_tenure_status ON ( claims_parties_temp.tenure_status = table_tenure_status.name  )
	LEFT OUTER JOIN "update".table_witness_type ON ( claims_parties_temp.witness_relationship = table_witness_type.name  )
	LEFT OUTER JOIN "update".table_prefix ON ( claims_parties_temp.prefix_name = table_prefix.name )
	LEFT OUTER JOIN "update".table_suffix ON ( claims_parties_temp.suffix_name = table_suffix.name )
	LEFT OUTER JOIN "update".table_gender ON ( claims_parties_temp.gender = table_gender.gender_name  )
	LEFT OUTER JOIN "update".table_civil_status ON ( claims_parties_temp.civil_status = table_civil_status.name  )
	LEFT OUTER JOIN "update".table_documents_dem ON ( claims_parties_temp.id_type = table_documents_dem.name)
	LEFT OUTER JOIN "update".table_address_type ON ( claims_parties_temp.address_type = table_address_type.name)
	LEFT OUTER JOIN "public".table_village tv ON ( claims_parties_temp.village_id = tv.code  )
	LEFT OUTER JOIN "update".table_age_range ON ( claims_parties_temp.age_range = table_age_range.age_range_name)
WHERE claims_parties_temp.key NOT IN (SELECT KEY FROM "update".form_e2_claims_parties);
	
-- Set image URLs where they exists
update update.form_e2_claims_parties
set party_photo = concat('http://13.244.91.45:90/media/fzs/e2/'||party_photo)
where length(party_photo) = 17;

update update.form_e2_claims_parties
set id_photo_front = concat('http://13.244.91.45:90/media/fzs/e2/'||id_photo_front)
where length(id_photo_front) = 17;

update update.form_e2_claims_parties
set id_photo_back = concat('http://13.244.91.45:90/media/fzs/e2/'||id_photo_back)
where length(id_photo_back) = 17;

--set checked to no
update update.form_e2_claims_parties
set checked = 'no'
where checked IS NULL;

--drop temp table
DROP TABLE "update".claims_parties_temp;

--update public schema
INSERT INTO public.form_e2_claims_parties(
	parcel_parties, party_role, relationship, tenure_acquisition, tenure_responsibilities, tenure_restrictions, tenure_rights, tenure_status, witness_relationship, prefix_name, given_name, middle_name, family_name, suffix_name, gender, civil_status, birthdate, year_of_birth, age_range, nationality, party_photo, id_type, nrc_number, passport_number, driving_licence, formal_id, formal_id_number, id_photo_front, id_photo_back, address_type, province, chiefdom, vag, village_id, address_line_1, address_line_2, address_town_or_city, address_urban_province, primary_contact_zm, primary_contact_in, secondary_contact_zm, secondary_contact_in, email, parent_key, key, date_checked)
	
SELECT parcel_parties, party_role, relationship, tenure_acquisition, tenure_responsibilities, tenure_restrictions, tenure_rights, tenure_status, witness_relationship, prefix_name, given_name, middle_name, family_name, suffix_name, gender, civil_status, birthdate, year_of_birth, age_range, nationality, party_photo, id_type, nrc_number, passport_number, driving_licence, formal_id, formal_id_number, id_photo_front, id_photo_back, address_type, province, chiefdom, vag, village_id, address_line_1, address_line_2, address_town_or_city, address_urban_province, primary_contact_zm, primary_contact_in, secondary_contact_zm, secondary_contact_in, email, parent_key, key, date_checked
FROM update.form_e2_claims_parties
WHERE update.form_e2_claims_parties.key NOT IN (SELECT key from public.form_e2_claims_parties) AND update.form_e2_claims_parties.checked = 'yes';

DELETE FROM update.form_e2_claims_parties
USING public.form_e2_claims_parties
WHERE update.form_e2_claims_parties.key = public.form_e2_claims_parties.key;


INSERT INTO public.occ_party(
	jurisdiction, vag, village, parcel_id, map_sheet_number, parcel_parties, party_role, relationship, prefix_name, given_name, middle_name, family_name, suffix_name, gender, civil_status, birthdate, year_of_birth, age_range, nrc_number, primary_contact_zm, parent_key, key, zone)
	
SELECT DISTINCT ON (fecp."key")
 fed.jurisdiction,
 fed.vag,
 fed.village,
 fed.parcel_id,
 fed.map_sheet_number,
 fecp.parcel_parties,
 fecp.party_role,
 fecp.relationship,
 fecp.prefix_name,
 fecp.given_name,
 fecp.middle_name,
 fecp.family_name,
 fecp.suffix_name,
 fecp.gender,
 fecp.civil_status,
 fecp.birthdate,
 fecp.year_of_birth::text,
 fecp.age_range,
 fecp.nrc_number,
 fecp.primary_contact_zm,
 fecp.parent_key,
 fecp."key",
 fed."zone"
FROM "public".form_e1_demarcation fed 
	LEFT OUTER JOIN "public".form_e2_claims_parties fecp ON ( fed.parcel = fecp.parcel_parties  )
WHERE fecp."key" NOT IN (SELECT KEY FROM "public".occ_party) AND fed."zone" IS NOT NULL;

 UPDATE public.occ_party
 SET year_of_birth = to_char(birthdate, 'yyyy')::text
 WHERE year_of_birth IS NULL;
 
 UPDATE public.occ_party
 SET year_of_birth = age_range
 WHERE year_of_birth IS NULL;
 

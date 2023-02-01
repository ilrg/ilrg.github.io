CREATE TABLE "update".witness_temp (
	party_role text,
	prefix_name text ,
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
	pjp_vag text,
	pjp_vag_other text,
	address_searchtext text,
	address_village_id text,
	address_other_village text,
	address_line_1 text,
	address_line_2 text,
	address_town_or_city text,
	address_urban_province text,
	telephone_location_t1 text,
	telephone_main_za decimal,
	telephone_main_za_02 decimal,
	email text,
	witness_relation text,
	add_witness text,
	PARENT_KEY text,
	KEY text
);

copy "update".witness_temp from '/home/ubuntu/fzs/form_e1_demarcation/Demarcation-witness_details.csv'
DELIMITER ','
CSV HEADER;

UPDATE update.witness_temp
SET province = 'Eastern'
where province = 'ZM30';

UPDATE update.witness_temp
SET chiefdom = 'Chifunda'
where chiefdom = 'CHF';

UPDATE update.witness_temp
SET chiefdom = 'Chikwa'
where chiefdom = 'CHI';

--update update.form_e1_demarcation_witness
INSERT INTO update.form_e1_demarcation_witness(
	prefix, given_name, middle_name, family_name, suffix, gender, civil_status, birthdate, year_of_birth, age_range, nationality, witness_photo, id_type, nrc_number, passport_number, driving_licence, formal_id, formal_id_number, id_photo_front, id_photo_back, address_type, province, chiefdom, pjp_vag, address_village_id, address_line_1, address_line_2, address_town_or_city, address_urban_province, primary_contact, secondary_contact, email, witness_relationship, parent_key, key)

SELECT
	CASE WHEN  witness_temp.prefix_name::text = 'other' THEN witness_temp.prefix_other
	 ELSE table_prefix.label::text 
	 END AS prefix_name,
	
    given_name::text COLLATE pg_catalog."default",
    middle_name::text COLLATE pg_catalog."default",
    family_name::text COLLATE pg_catalog."default",
	
	CASE WHEN  witness_temp.suffix_name::text = 'other' THEN witness_temp.suffix_other
	 ELSE table_suffix.label::text 
	 END AS suffix_name,
	
	table_gender.gender_label::text COLLATE pg_catalog."default",
	table_civil_status.label::text COLLATE pg_catalog."default",
    birthdate::date,
    LEFT(year_of_birth, 4)::integer as year_of_birth,
    table_age_range.age_range_label::text as age_range,
	
	CASE WHEN  witness_temp.nationality::text = 'other' THEN witness_temp.other_nationality
	 ELSE witness_temp.nationality::text 
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
	
	CASE WHEN  witness_temp.chiefdom::text = 'other' THEN witness_temp.other_chiefdom
	 ELSE witness_temp.chiefdom::text 
	 END AS chiefdom,
	 
	CASE WHEN  witness_temp.pjp_vag::text = 'other' THEN witness_temp.pjp_vag_other
	 ELSE witness_temp.pjp_vag::text 
	 END AS vag,
    
	CASE WHEN  witness_temp.address_village_id::text = '1' THEN witness_temp.address_other_village
	 ELSE tv.village::text 
	 END AS village,
	 
    address_line_1::text COLLATE pg_catalog."default",
    address_line_2::text COLLATE pg_catalog."default",
    address_town_or_city::text COLLATE pg_catalog."default",
    address_urban_province::text COLLATE pg_catalog."default",
    telephone_main_za::numeric,
    telephone_main_za_02::numeric,
    email::text COLLATE pg_catalog."default",
    table_witness_relation.label::text as witness_relation,
    parent_key::text COLLATE pg_catalog."default",
    key::text COLLATE pg_catalog."default"
FROM update.witness_temp
	LEFT OUTER JOIN "update".table_prefix ON ( witness_temp.prefix_name = table_prefix.name )
	LEFT OUTER JOIN "update".table_suffix ON ( witness_temp.suffix_name = table_suffix.name )
	LEFT OUTER JOIN "update".table_gender ON ( witness_temp.gender = table_gender.gender_name  )
	LEFT OUTER JOIN "update".table_civil_status ON ( witness_temp.civil_status = table_civil_status.name  )
	LEFT OUTER JOIN "update".table_age_range ON ( witness_temp.age_range = table_age_range.age_range_name)
	LEFT OUTER JOIN "update".table_address_type ON ( witness_temp.address_type = table_address_type.name)
	LEFT OUTER JOIN "public".table_village tv ON ( witness_temp.address_village_id = tv.code  )
	LEFT OUTER JOIN "update".table_witness_relation ON ( witness_temp.witness_relation = table_witness_relation.name)
	LEFT OUTER JOIN "update".table_documents_dem ON ( witness_temp.id_type = table_documents_dem.name)
WHERE witness_temp.key NOT IN (SELECT KEY FROM "update".form_e1_demarcation_witness);

--drop temp table
DROP TABLE "update".witness_temp;
	
-- Set image URLs where they exists
update update.form_e1_demarcation_witness
set witness_photo = concat('http://13.244.91.45:90/media/fzs/e1/'||witness_photo)
where length(witness_photo) = 17;

update update.form_e1_demarcation_witness
set id_photo_front = concat('http://13.244.91.45:90/media/fzs/e1/'||id_photo_front)
where length(id_photo_front) = 17;

update update.form_e1_demarcation_witness
set id_photo_back = concat('http://13.244.91.45:90/media/fzs/e1/'||id_photo_back)
where length(id_photo_back) = 17;    

--update the public schema
INSERT INTO public.form_e1_demarcation_witness(
	prefix, given_name, middle_name, family_name, suffix, gender, civil_status, birthdate, year_of_birth, age_range, nationality, witness_photo, id_type, nrc_number, passport_number, driving_licence, formal_id, formal_id_number, id_photo_front, id_photo_back, address_type, province, chiefdom, pjp_vag, address_village_id, address_line_1, address_line_2, address_town_or_city, address_urban_province, primary_contact, secondary_contact, email, witness_relationship, parent_key, key)

SELECT prefix, given_name, middle_name, family_name, suffix, gender, civil_status, birthdate, year_of_birth, age_range, nationality, witness_photo, id_type, nrc_number, passport_number, driving_licence, formal_id, formal_id_number, id_photo_front, id_photo_back, address_type, province, chiefdom, pjp_vag, address_village_id, address_line_1, address_line_2, address_town_or_city, address_urban_province, primary_contact, secondary_contact, email, witness_relationship, parent_key, key
FROM update.form_e1_demarcation_witness
WHERE update.form_e1_demarcation_witness.key NOT IN (SELECT key from public.form_e1_demarcation_witness);

DELETE FROM update.form_e1_demarcation_witness
USING public.form_e1_demarcation_witness
WHERE update.form_e1_demarcation_witness.key = public.form_e1_demarcation_witness.key;
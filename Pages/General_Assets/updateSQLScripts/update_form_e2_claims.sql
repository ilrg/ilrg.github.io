-- Build temp table
CREATE TABLE "update".claims_temp (
	tec_name text,
	tec_given_name text,
	tec_family_name text,
	date date,
	jurisdiction text,
	jur_other text,
	vag text,
	vag_other text,
	parcel_id integer,
	parcel_id_chk integer,
	parcel text,
	land_category text,
	juridical_parcel text,
	pj_entity_name text,
	pj_entity_type text,
	pj_other_entity_type text,
	pj_party_role text,
	pj_tenure_acquisition_gained text,
	pj_tenure_not_previously_listed text,
	pj_tenure_responsibilities_001 text,
	pj_other_tenure_responsibilities_001 text,
	pj_tenure_restrictions_001 text,
	pj_other_restrictions_previously_001 text,
	pj_tenure_status_001 text,
	pj_witness_relationship text,
	pj_other_witness text,
	pj_add_parties_to_entity text,
	pj_id_availability text,
	pj_id_document text,
	pj_registration_number text,
	pj_date_of_registration date,
	pj_id_document_number text,
	pj_id_photo_1 text,
	pj_id_photo_2 text,
	pj_address_type text,
	pj_province text,
	pj_chiefdom text,
	pj_other_chiefdom text,
	pj_vag text,
	pj_vag_other text,
	pj_searchtext text,
	pj_village_id text,
	pj_other_village text,
	pj_address_line_1 text,
	pj_address_line_2 text,
	pj_address_town_or_city text,
	pj_address_province text,
	pj_telephone_location_1 text,
	pj_telephone_1_001 numeric,
	pj_telephone_1_002 numeric,
	pj_telephone_location_2 text,
	pj_telephone_2_001 numeric,
	pj_telephone_2_002 numeric,
	evidence text,
	document_type text,
	document_oth text,
	document_authority text,
	authority_other text,
	document_present text,
	document_owner text,
	document_spatial text,
	document_date text,
	document_number text,
	document_photo_1 text,
	document_photo_2 text,
	comment text,
	claim_image text,
	KEY text,
	ReviewState text
);

copy "update".claims_temp FROM '/home/ubuntu/fzs/form_e2_claims/Claims_cut.csv'
DELIMITER ','
CSV HEADER;

--update update.form_e2_claims
INSERT INTO update.form_e2_claims(
	tec_name, date, jurisdiction, vag, parcel_id, parcel_id_chk, parcel, land_category, evidence, document_type, document_authority, document_present, document_owner, document_spatial, document_date, document_number, document_photo_1, document_photo_2, comment, claim_image, key, reviewstate)

SELECT
    table_enumerator.name::text COLLATE pg_catalog."default",
    date::date,
	
	CASE WHEN  claims_temp.jurisdiction::text = 'other' THEN claims_temp.jur_other
	 ELSE tj.jurisdiction_label::text 
	 END AS jurisdiction,
	
	CASE WHEN  claims_temp.vag::text = 'other' THEN claims_temp.vag_other
	 ELSE table_vags.vag_label::text 
	 END AS vag,
	 
    parcel_id::integer,
    parcel_id_chk::integer,
    parcel::text COLLATE pg_catalog."default",
    table_land_category.label::text as land_category,
	evidence::text,
	
	CASE WHEN  claims_temp.document_type::text = 'other' THEN claims_temp.document_oth
	 ELSE table_evidence.name::text 
	 END AS document,
	
	CASE WHEN  claims_temp.document_authority::text = 'other' THEN claims_temp.authority_other
	 ELSE table_authority.authority_label::text 
	 END AS document,
	
    document_present::text COLLATE pg_catalog."default",
    document_owner::text COLLATE pg_catalog."default",
    document_spatial::text COLLATE pg_catalog."default",
    document_date::text COLLATE pg_catalog."default",
    document_number::text COLLATE pg_catalog."default",
    document_photo_1::text COLLATE pg_catalog."default",
    document_photo_2::text COLLATE pg_catalog."default",
    comment::text COLLATE pg_catalog."default",
    claim_image::text COLLATE pg_catalog."default",
    key::text COLLATE pg_catalog."default",
    reviewstate::text COLLATE pg_catalog."default"
FROM update.claims_temp
	LEFT OUTER JOIN "public".table_enumerator ON ( claims_temp.tec_name = table_enumerator.code  )
	LEFT OUTER JOIN "update".table_jurisdiction tj ON ( claims_temp.jurisdiction = tj.jurisdiction_name  )
	LEFT OUTER JOIN "update".table_vags ON ( claims_temp.vag = table_vags.vag_name  )
	LEFT OUTER JOIN "update".table_land_category ON ( claims_temp.land_category = table_land_category.name  )
	LEFT OUTER JOIN "update".table_evidence ON ( claims_temp.document_type = table_evidence.name  )
	LEFT OUTER JOIN "update".table_authority ON ( claims_temp.document_authority = table_authority.authority_name  )
	WHERE claims_temp.key NOT IN (SELECT KEY FROM "update".form_e2_claims) AND claims_temp.key NOT IN (SELECT KEY FROM "public".form_e2_claims);

--drop temp table
DROP TABLE "update".claims_temp;

-- Set image URLs where they exists
update update.form_e2_claims
set document_photo_1 = concat('http://13.244.91.45:90/media/fzs/e2/'||document_photo_1)
where length(document_photo_1) = 17;

update update.form_e2_claims
set document_photo_2 = concat('http://13.244.91.45:90/media/fzs/e2/'||document_photo_2)
where length(document_photo_2) = 17;

update update.form_e2_claims
set claim_image = concat('http://13.244.91.45:90/media/fzs/e2/'||claim_image)
where length(claim_image) = 17;	

--set checked to no
update update.form_e2_claims
set reviewstate = 'no'
where reviewstate IS NULL;

--update public schema
INSERT INTO public.form_e2_claims(
	tec_name, date, jurisdiction, vag, parcel_id, parcel_id_chk, parcel, land_category, evidence, document_type, document_authority, document_present, document_owner, document_spatial, document_date, document_number, document_photo_1, document_photo_2, comment, claim_image, key, date_checked)
	
SELECT tec_name, date, jurisdiction, vag, parcel_id, parcel_id_chk, parcel, land_category, evidence, document_type, document_authority, document_present, document_owner, document_spatial, document_date, document_number, document_photo_1, document_photo_2, comment, claim_image, key, date_checked
FROM update.form_e2_claims
WHERE update.form_e2_claims.key NOT IN (SELECT key from public.form_e2_claims) AND update.form_e2_claims.reviewstate = 'yes';

DELETE FROM update.form_e2_claims
USING public.form_e2_claims
WHERE update.form_e2_claims.key = public.form_e2_claims.key;

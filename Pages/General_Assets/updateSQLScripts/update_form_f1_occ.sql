CREATE TABLE "update".occ_temp (
	tec_name text,
	tec_given_name text,
	tec_family_name text,
	date date,
	jurisdiction text,
	jur_other text,
	vag text,
	vag_other text,
	parcel_id text,
	parcel_id_chk text,
	parcel text,
	certified text,
	cor_condition text,
	del_condition text,
	add_condition text,
	bound_condition text,
	sig_condition text,
	vil_condition text,
	land_category text,
	evidence text,
	document_type text,
	document_oth text,
	document_authority text,
	authority_other text,
	document_present text,
	document_owner text,
	document_spatial text,
	document_date date,
	document_number text,
	document_photo_1 text,
	document_photo_2 text,
	comment text,
	conflict_reason text,
	conflict_obs text,
	receipt_imagetext text,
	parcel_village_id text,
	polygon text,
	auto_path character varying(25000),
	auto_shp character varying(25000),
	headperson_signed text,
	vlc_signed text,
	KEY text,
	ReviewState text
);
--insert data from the csv file
copy "update".occ_temp from '/home/ubuntu/fzs/form_f1_occ/occ_cut.csv'
DELIMITER ','
CSV HEADER;

--update occ table in update schema
INSERT INTO update.form_f1_occ(
	tec_name, date, jurisdiction, vag, parcel_id, parcel_id_chk, parcel, certified, cor_condition, del_condition, add_condition, bound_condition, sig_condition, vil_condition, land_category, evidence, document_type, document_oth, document_authority, authority_other, document_present, document_owner, document_spatial, document_date, document_number, document_photo_1, document_photo_2, comment, conflict_reason, conflict_obs, receipt_image, village_id, headperson_signed, vlc_signed, key)

SELECT 
	table_enumerator.name::text,
	date::date,
	table_jurisdiction.jurisdiction_label::text,
	occ_temp.vag::text,
	parcel_id::integer,
	parcel_id_chk::integer,
	parcel::text,
	table_certify.certify_label::text,
	cor_condition::text,
	del_condition::text,
	add_condition::text,
	bound_condition::text,
	sig_condition::text,
	vil_condition::text,
	land_category::text,
	evidence::text,
	document_type::text,
	document_oth::text,
	document_authority::text,
	authority_other::text,
	document_present::text,
	document_owner::text,
	document_spatial::text,
	document_date,
	document_number::text,
	document_photo_1::text,
	document_photo_2::text,
	comment::text,
	conflict_reason::text,
	conflict_obs::text,
	receipt_imagetext::text,
	table_village.village::text,
	headperson_signed::text,
	vlc_signed::text,
	key::character varying
FROM update.occ_temp
	LEFT OUTER JOIN "public".table_enumerator ON ( occ_temp.tec_name = table_enumerator.code )
	LEFT OUTER JOIN "update".table_certify ON ( occ_temp.certified = table_certify.certify_name )
	LEFT OUTER JOIN "update".table_jurisdiction ON ( occ_temp.jurisdiction = table_jurisdiction.jurisdiction_name )
	LEFT OUTER JOIN "public".table_village ON ( occ_temp.jurisdiction = table_village.code )
WHERE occ_temp.key NOT IN (SELECT KEY FROM "update".form_f1_occ) AND occ_temp.key NOT IN (SELECT KEY FROM "public".form_f1_occ);

--update checked column
update update.form_f1_occ
set checked = 'yes'
where certified = 'Ready to certify - all signed, no changes';

update update.form_f1_occ
set checked = 'no'
where checked IS NULL;

--drop occ_temp table
DROP TABLE "update".occ_temp;

--duplicates
CREATE TABLE update.occ_duplicates AS
SELECT 
tec_name, date, jurisdiction, vag, form_f1_occ.parcel_id, parcel_id_chk, parcel, certified, cor_condition, del_condition, add_condition, bound_condition, sig_condition, vil_condition, land_category, evidence, document_type, document_oth, document_authority, authority_other, document_present, document_owner, document_spatial, document_date, document_number, document_photo_1, document_photo_2, comment, conflict_reason, conflict_obs, receipt_image, village_id, headperson_signed, vlc_signed, key, checked
FROM
(SELECT parcel_id FROM update.form_f1_occ GROUP BY parcel_id
  HAVING count(parcel_id) >= 2)
  AS dup INNER JOIN update.form_f1_occ ON update.form_f1_occ.parcel_id = dup.parcel_id
  ORDER BY parcel_id;
 
UPDATE update.occ_duplicates
SET checked = 'duplicate';

UPDATE update.form_f1_occ
SET checked = update.occ_duplicates.checked
FROM update.occ_duplicates
WHERE update.form_f1_occ.key = update.occ_duplicates.key;

DROP TABLE update.occ_duplicates;

--insert into occ table in public schema
INSERT INTO public.form_f1_occ(
	tec_name, date, jurisdiction, parcel_id, parcel_id_chk, parcel, certified, cor_condition, del_condition, add_condition, bound_condition, sig_condition, vil_condition, receipt_image, village_id, headperson_signed, vlc_signed, key)

SELECT tec_name, date, jurisdiction, parcel_id, parcel_id_chk, parcel, certified, cor_condition, del_condition, add_condition, bound_condition, sig_condition, vil_condition, receipt_image, village_id, headperson_signed, vlc_signed, key
	FROM update.form_f1_occ
	WHERE update.form_f1_occ.key NOT IN (SELECT KEY FROM "public".form_f1_occ) AND update.form_f1_occ.checked = 'yes';

DELETE FROM update.form_f1_occ
USING public.form_f1_occ
WHERE update.form_f1_occ.key = public.form_f1_occ.key;

update update.form_f1_occ
set receipt_image = concat('http://13.244.91.45:90/media/fzs/f1/'||receipt_image)
where length(receipt_image) = 17;


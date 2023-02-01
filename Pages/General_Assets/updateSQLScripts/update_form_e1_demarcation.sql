-- Build temp table
CREATE TABLE "update".demarcation_temp (
	tec_name text,
	date date,
	jurisdiction text,
	jur_other text,
	vag text,
	vag_other text,
	village_id text,
	village_other text,
	state_cust text,
	state_note text,
	parcel_access text,
	parcel_access_gps_Latitude numeric(38,10),
	parcel_access_gps_Longitude numeric(38,10),
	parcel_access_gps_Altitude numeric(38,10),
	parcel_access_gps_Accuracy numeric(38,10),
	dem_point_Latitude numeric(38,10),
	dem_point_Longitude numeric(38,10),
	dem_point_Altitude numeric(38,10),
	dem_point_Accuracy numeric(38,10),
	parcel_id integer,
	parcel_id_chk integer,
	parcel text,
	land_use text,
	land_cover text,
	survey_method text,
	partial_boundary character varying(25000),
	full_boundary_area character varying(25000),
	poly_map_id integer,
	map_sheet_number integer,
	Map_sheet_number_confirm integer,
	conflict_y_n text,
	conflic_resolved text,
	conflict_description text,
	border text,
	overlap text,
	beacons text,
	water text,
	infra text,
	land_category text,
	holder_y_n text,
	holder_given_name text,
	holder_family_name text,
	gender_holder text,
	landholder_youth text,
	representative_given_name text,
	representative_family_name text,
	gender_rep text,
	rep_youth text,
	rep_relation text,
	rep_relation_other text,
	entity_type text,
	entity_name text,
	witnesses_image text,
	receipt_image text,
	map_sheet_image text,
	KEY text,
	ReviewState text
);

copy "update".demarcation_temp from '/home/ubuntu/fzs/form_e1_demarcation/form_e1_demarcation_cut.csv'
DELIMITER ','
CSV HEADER;

--update the update.form_e1_demarcation
INSERT INTO update.form_e1_demarcation(
	geom, altitude, accuracy, tech_name, date, jurisdiction, vag, village, table_state_label, state_note, access, parcel_access_gps_latitude, parcel_access_gps_longitude, parcel_access_gps_altitude, parcel_access_gps_accuracy, parcel_id, parcel_id_chk, parcel, table_land_use_label, table_land_cover_label, label, poly_map_id, map_sheet_number, map_sheet_number_confirm, conflict_y_n, conflic_resolved, conflict_description, border, overlap, beacons, water_label, infrastructure, land_category, holder_given_name, holder_family_name, holder_gender, holder_youth, representative_given_name, representative_family_name, rep_gender, rep_youth, rep_relation, entity_type, entity_name, witnesses_image, receipt_image, map_sheet_image, key, reviewstate)
	
SELECT
	ST_SetSRID(ST_MakePoint(dem_point_longitude,  dem_point_latitude),4326) AS geom,
	dem_point_altitude::integer as altitude,  
	dem_point_accuracy::integer as accuracy,
 
	table_enumerator.name::text,
	date::date,
	
	CASE WHEN  demarcation_temp.jurisdiction::text = 'other' THEN demarcation_temp.jur_other
	 ELSE tj.jurisdiction_label::text 
	 END AS jurisdiction,
	
	CASE WHEN  demarcation_temp.vag::text = 'other' THEN demarcation_temp.vag_other
	 ELSE table_vags.vag_label::text 
	 END AS vag, 
	
	CASE WHEN  demarcation_temp.village_id::text = '1' THEN demarcation_temp.village_other
	 ELSE tv.village::text 
	 END AS village,
	
	table_state.table_state_label::text,	
	state_note::text,
	table_access.label::text as access,
	parcel_access_gps_latitude::numeric,
	parcel_access_gps_longitude::numeric,
	parcel_access_gps_altitude::numeric,
	parcel_access_gps_accuracy::numeric,
	parcel_id::integer,
	parcel_id_chk::integer,
	parcel::text,
	table_land_use.table_land_use_label::text,
	table_land_cover.table_land_cover_label::text,
	table_dem_means.label::text,
	poly_map_id::integer,
	map_sheet_number::integer,
	map_sheet_number_confirm::integer,
	conflict_y_n::text,
	conflic_resolved::text,
	conflict_description::text,
	border::text,
	overlap::text,
	beacons::text,
	table_water.water_label::text,
	table_infrastructure.label::text as infrastructure,
	table_land_category.label::text as land_category,
	
	holder_given_name::text,
	holder_family_name::text,
	table_gender.gender_label::text as holder_gender,
	table_youth.label::text as holder_youth,
	
	representative_given_name::text,
	representative_family_name::text,
	tg1.gender_label::text as rep_gender,
	ty1.label::text as rep_youth,
	
	CASE WHEN  demarcation_temp.rep_relation::text = 'other' THEN demarcation_temp.rep_relation_other
	 ELSE table_rep_relation.label::text 
	 END AS rep_relation, 
	
	entity_type::text,
	entity_name::text,
	
	witnesses_image::text,
	receipt_image::text,
	map_sheet_image::text,
	key,
	reviewstate
FROM update.demarcation_temp
	LEFT OUTER JOIN "public".table_enumerator ON ( demarcation_temp.tec_name = table_enumerator.code  )
	LEFT OUTER JOIN "update".table_jurisdiction tj ON ( demarcation_temp.jurisdiction = tj.jurisdiction_name  )
	LEFT OUTER JOIN "public".table_village tv ON ( demarcation_temp.village_id = tv.code  )
	LEFT OUTER JOIN "update".table_vags ON ( demarcation_temp.vag = table_vags.vag_name  )
	LEFT OUTER JOIN "update".table_state ON ( demarcation_temp.state_cust = table_state.table_state_name  )
	LEFT OUTER JOIN "update".table_land_use ON ( demarcation_temp.land_use = table_land_use.table_land_use_name  )
	LEFT OUTER JOIN "update".table_land_cover ON ( demarcation_temp.land_cover = table_land_cover.table_land_cover_name  )
	LEFT OUTER JOIN "update".table_dem_means ON ( demarcation_temp.survey_method = table_dem_means.name  )
	LEFT OUTER JOIN "update".table_water ON ( demarcation_temp.water = table_water.water_name  )
	LEFT OUTER JOIN "update".table_infrastructure ON ( demarcation_temp.infra = table_infrastructure.name  )
	LEFT OUTER JOIN "update".table_land_category ON ( demarcation_temp.land_category = table_land_category.name  )
	LEFT OUTER JOIN "update".table_rep_relation ON ( demarcation_temp.rep_relation = table_rep_relation.name  )
	LEFT OUTER JOIN "update".table_access ON ( demarcation_temp.parcel_access = table_access.name  )
	LEFT OUTER JOIN "update".table_gender ON ( demarcation_temp.gender_holder = table_gender.gender_name  )
	LEFT OUTER JOIN "update".table_youth ON ( demarcation_temp.landholder_youth = table_youth.name  )
	LEFT OUTER JOIN "update".table_gender tg1 ON ( demarcation_temp.gender_rep = tg1.gender_name  )
	LEFT OUTER JOIN "update".table_youth ty1 ON ( demarcation_temp.landholder_youth = ty1.name  )
WHERE demarcation_temp.key NOT IN (SELECT KEY FROM "update".form_e1_demarcation) AND demarcation_temp.key NOT IN (SELECT KEY FROM "public".form_e1_demarcation);

-- draw parcels
ALTER TABLE update.form_e1_parcels ALTER COLUMN geom type geometry(MultiPolygonZM, 4326);

INSERT INTO update.form_e1_parcels(
	geom, parcel_id, parcel, key)

SELECT
	ST_FlipCoordinates(ST_GeomFromText(CONCAT('MultiPolygonZM ((('||RTRIM(replace(demarcation_temp."full_boundary_area", ';', ',' ), ', ')||')))'),4326)),
	parcel_id::integer,
    parcel::text COLLATE pg_catalog."default",
    key::text COLLATE pg_catalog."default"
FROM update.demarcation_temp
	WHERE update.demarcation_temp.full_boundary_area IS NOT NULL AND demarcation_temp.key NOT IN (SELECT key from update.form_e1_parcels) AND demarcation_temp.key NOT IN (SELECT key from public.parcels);	
	
-- drop temp table
DROP TABLE "update".demarcation_temp;

-- Set image URLs where they exists
update update.form_e1_demarcation
set witnesses_image = concat('http://13.244.91.45:90/media/fzs/e1/'||witnesses_image)
where length(witnesses_image) = 17;

update update.form_e1_demarcation
set receipt_image = concat('http://13.244.91.45:90/media/fzs/e1/'||receipt_image)
where length(receipt_image) = 17;

update update.form_e1_demarcation
set map_sheet_image = concat('http://13.244.91.45:90/media/fzs/e1/'||map_sheet_image)
where length(map_sheet_image) = 17;

update update.form_e1_parcels
set checked = 'no'
where checked IS NULL;

--update the public schema
INSERT INTO public.form_e1_demarcation(
	geom, altitude, accuracy, tech_name, date, jurisdiction, vag, village, table_state_label, state_note, access, parcel_access_gps_latitude, parcel_access_gps_longitude, parcel_access_gps_altitude, parcel_access_gps_accuracy, parcel_id, parcel_id_chk, parcel, table_land_use_label, table_land_cover_label, label, poly_map_id, map_sheet_number, map_sheet_number_confirm, conflict_y_n, conflic_resolved, conflict_description, border, overlap, beacons, water_label, infrastructure, land_category, holder_given_name, holder_family_name, holder_gender, holder_youth, representative_given_name, representative_family_name, rep_gender, rep_youth, rep_relation, entity_type, entity_name, witnesses_image, receipt_image, map_sheet_image, key)

SELECT geom, altitude, accuracy, tech_name, date, jurisdiction, vag, village, table_state_label, state_note, access, parcel_access_gps_latitude, parcel_access_gps_longitude, parcel_access_gps_altitude, parcel_access_gps_accuracy, parcel_id, parcel_id_chk, parcel, table_land_use_label, table_land_cover_label, label, poly_map_id, map_sheet_number, map_sheet_number_confirm, conflict_y_n, conflic_resolved, conflict_description, border, overlap, beacons, water_label, infrastructure, land_category, holder_given_name, holder_family_name, holder_gender, holder_youth, representative_given_name, representative_family_name, rep_gender, rep_youth, rep_relation, entity_type, entity_name, witnesses_image, receipt_image, map_sheet_image, key
FROM update.form_e1_demarcation
WHERE update.form_e1_demarcation.key NOT IN (SELECT key from public.form_e1_demarcation);

DELETE FROM update.form_e1_demarcation
USING public.form_e1_demarcation
WHERE update.form_e1_demarcation.key = public.form_e1_demarcation.key;

--update parcels in public schema
INSERT INTO public.parcels(
	geom, parcel_id, parcel, x_min, x_max, y_min, y_max, key, date_checked)

SELECT geom, parcel_id, parcel, x_min, x_max, y_min, y_max, key, date_checked
FROM update.form_e1_parcels
WHERE update.form_e1_parcels.key NOT IN (SELECT key from public.parcels) AND update.form_e1_parcels.checked = 'yes';

DELETE FROM update.form_e1_parcels
USING public.parcels
WHERE update.form_e1_parcels.key = public.parcels.key;

--update the key
UPDATE update.manual_digitization
SET key = public.form_e1_demarcation.key
FROM public.form_e1_demarcation
WHERE update.manual_digitization.parcel_id = public.form_e1_demarcation.parcel_id AND update.manual_digitization.key IS NULL;

--insert in the public schema
INSERT INTO public.parcels(
	geom, parcel_id, parcel, x_min, x_max, y_min, y_max, key, date_checked)
SELECT DISTINCT ON ( update.manual_digitization.key) geom, parcel_id, parcel, x_min, x_max, y_min, y_max, key, date_checked
FROM update.manual_digitization
WHERE update.manual_digitization.key NOT IN (SELECT key from public.parcels) AND update.manual_digitization.checked = 'yes' AND update.manual_digitization.key != '';

DELETE FROM update.manual_digitization
USING public.parcels
WHERE update.manual_digitization.key = public.parcels.key;
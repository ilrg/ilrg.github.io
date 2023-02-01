-- Build temp table
CREATE TABLE "update".vill_id_temp (
    geom public.geometry(Point, 4326),
    tec_name text,
    date timestamp,
    jurisdiction text,
    jur_other text,
    vag text,
    vag_other text,
    village text,
    village_other text,
    latitude numeric(38,10),
    longitude numeric(38,10),
    altitude numeric(38,10),
    accuracy numeric(38,10),
    is_hp text,
    contact_given_name character varying(255),
    contact_family_name character varying(255),
    headperson_given_name character varying(255),
    headperson_family_name character varying(255),
    headperson_contact text,
    number_households integer,
    village_register character varying(255),
    village_recognized character varying(255),
    shrd_rsrcs_agriculture character varying(255),
    shrd_rsrcs_network character varying(255),
    shrd_rsrcs_borehole character varying(255),
    shrd_rsrcs_well character varying(255),
    shrd_rsrcs_hammermill character varying(255),
    dist_pri_school integer,
    dist_sec_school integer,
    shrd_rsrcs_church character varying(255),
    shrd_rsrcs_clinic character varying(255),
    dist_clinic integer,
    shrd_rsrcs_dam character varying(255),
    shrd_rsrcs_dip_tank character varying(255),
    shrd_rsrcs_gov_pres character varying(255),
    shrd_rsrcs_electricity character varying(255),
    shrd_rsrcs_market character varying(255),
    shrd_rsrcs_accessibility character varying(255),
    shrd_rsrcs_public_transport character varying(255),
    shrd_rsrcs_nat_res character varying(255),
    mob_network_airtel character varying(255),
    mob_network_mtn character varying(255),
    mob_network_zamtel character varying(255),
    conflict character varying(255),
    con_des character varying(255),
    settle_scheme text null,
	mvuvye_forest text null,
    key character varying(80),
    ReviewState text NULL
);

-- Copy data from CSV export
-- Column names here must correspond to the CSV export columns IN ORDER. There is some variance in column names from the ODK exports, which should mirror database standards under Phase 1
copy "update".vill_id_temp(tec_name, date, jurisdiction, jur_other, vag, vag_other, village, village_other, latitude, longitude, altitude, accuracy, is_hp, contact_given_name, contact_family_name, headperson_given_name, headperson_family_name, headperson_contact, number_households, village_register, village_recognized, shrd_rsrcs_agriculture, shrd_rsrcs_network, shrd_rsrcs_borehole, shrd_rsrcs_well, shrd_rsrcs_hammermill, dist_pri_school, dist_sec_school, shrd_rsrcs_church, shrd_rsrcs_clinic, dist_clinic, shrd_rsrcs_dam, shrd_rsrcs_dip_tank, shrd_rsrcs_gov_pres, shrd_rsrcs_electricity, shrd_rsrcs_market, shrd_rsrcs_accessibility, shrd_rsrcs_public_transport, shrd_rsrcs_nat_res, mob_network_airtel, mob_network_mtn, mob_network_zamtel, conflict, con_des, settle_scheme, mvuvye_forest, key, ReviewState)
from '/home/ubuntu/fzs/form_a1_village_identification/Village_Identification_v3_cut.csv'
DELIMITER ','
CSV HEADER;

-- Insert data from vill_id_temp table into update schema
-- Same column names as above, same order
INSERT INTO update.form_a1_village_identification(
	geom, tec_name, date, jurisdiction, vag, village, latitude, longitude, altitude, accuracy, is_hp, contact_given_name, contact_family_name, headperson_given_name, headperson_family_name, headperson_contact, number_households, village_register, village_recognized, shrd_rsrcs_agriculture, shrd_rsrcs_network, shrd_rsrcs_borehole, shrd_rsrcs_well, shrd_rsrcs_hammermill, dist_pri_school, dist_sec_school, shrd_rsrcs_church, shrd_rsrcs_clinic, dist_clinic, shrd_rsrcs_dam, shrd_rsrcs_dip_tank, shrd_rsrcs_gov_pres, shrd_rsrcs_electricity, shrd_rsrcs_market, shrd_rsrcs_accessibility, shrd_rsrcs_public_transport, shrd_rsrcs_nat_res, mob_network_airtel, mob_network_mtn, mob_network_zamtel, conflict, con_des, settle_scheme, mvuvye_forest, key, reviewstate)
	

SELECT
	geom,
	table_enumerator.name::text,
	date::date,
	
	CASE WHEN  vill_id_temp.jurisdiction::text = 'other' THEN vill_id_temp.jur_other
	 ELSE tj.jurisdiction_label::text 
	 END AS jurisdiction,
	 
	CASE WHEN  vill_id_temp.vag::text = 'other' THEN vill_id_temp.vag_other
	 ELSE table_vags.vag_label::text 
	 END AS vag, 
	
	CASE WHEN  vill_id_temp.village::text = '1' THEN vill_id_temp.village_other
	 ELSE tv.village::text 
	 END AS village,
	 
	latitude,
	longitude,
	altitude,
	accuracy,
	
	is_hp::text,
	contact_given_name::text,
	contact_family_name::text,
	headperson_given_name::text,
	headperson_family_name::text,
	headperson_contact::integer,
	number_households::integer,
	village_register::text,
	village_recognized::text,
	shrd_rsrcs_agriculture::text,
	shrd_rsrcs_network::text,
	shrd_rsrcs_borehole::text,
	shrd_rsrcs_well::text,
	shrd_rsrcs_hammermill::text,
	dist_pri_school::integer,
	dist_sec_school::integer,
	shrd_rsrcs_church::text,
	shrd_rsrcs_clinic::text,
	dist_clinic::integer,
	shrd_rsrcs_dam::text,
	shrd_rsrcs_dip_tank::text,
	shrd_rsrcs_gov_pres::text,
	shrd_rsrcs_electricity::text,
	shrd_rsrcs_market::text,
	table_vehicle_access.vehicle_access_label::text,
	table_hours.hours_label::text,
	shrd_rsrcs_nat_res::text,
	mob_network_airtel::text,
	mob_network_mtn::text,
	mob_network_zamtel::text,
	conflict::text,
	con_des::text,
	settle_scheme::text,
	mvuvye_forest::text,
	key::text,
	reviewstate::text
FROM update.vill_id_temp
	LEFT OUTER JOIN "public".table_enumerator ON ( vill_id_temp.tec_name = table_enumerator.code  )
	LEFT OUTER JOIN "update".table_jurisdiction tj ON ( vill_id_temp.jurisdiction = tj.jurisdiction_name  )
	LEFT OUTER JOIN "update".table_vags ON ( vill_id_temp.vag = table_vags.vag_name  )
	LEFT OUTER JOIN "public".table_village tv ON ( vill_id_temp.village = tv.code  )
	LEFT OUTER JOIN "update".table_vehicle_access ON ( vill_id_temp.shrd_rsrcs_accessibility = table_vehicle_access.vehicle_access_name  )
	LEFT OUTER JOIN "update".table_hours ON ( vill_id_temp.shrd_rsrcs_public_transport = table_hours.hours_name  )
WHERE vill_id_temp.key NOT IN (SELECT KEY FROM "update".form_a1_village_identification);

-- Drop vill_id_temp
drop table "update".vill_id_temp;
-- Add geom column from points
update "update".form_a1_village_identification
set geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
where geom is NULL;
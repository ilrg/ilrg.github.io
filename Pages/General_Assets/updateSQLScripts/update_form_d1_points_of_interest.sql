---------------------------------------
-- Points of interest
-- Temp table
CREATE TABLE "update".point_interest_temp (
	geom geometry(point, 4326) NULL,
	tec_name text NULL,
	jurisdiction text NULL,
	jur_other text NULL,
	"date" date NULL,
	latitude numeric(38, 10) NULL,
	longitude numeric(38, 10) NULL,
	altitude numeric(38, 10) NULL,
	accuracy numeric(38, 10) NULL,
	"descriptor" text NULL,
	descriptor_other text NULL,
	resource_name text NULL,
	tenure text NULL,
	resource_manager text NULL,
	management_problems text NULL,
	resource_notes text NULL,
	image text NULL,
	"key" text NOT NULL,
	ReviewState text NULL
);

-- Copy from CSV
-- Column names here must correspond to the CSV export columns IN ORDER. There is some variance in column names from the ODK exports, which should mirror database standards under Phase 1
copy "update".point_interest_temp(tec_name, jurisdiction, jur_other, date, latitude, longitude, altitude, accuracy, descriptor, descriptor_other, resource_name, tenure, resource_manager, management_problems, resource_notes, image, key, ReviewState)
from '/home/ubuntu/fzs/form_d1_points_of_interest/Points_of_Interest_V3_cut.csv'
DELIMITER ','
CSV HEADER;
-- Insert only new items
-- Same column names as above, same order
INSERT INTO update.form_d1_point_of_interest(
	geom, tec_name, jurisdiction, date, latitude, longitude, altitude, accuracy, descriptor, resource_name, tenure, resource_manager, management_problems, resource_notes, image, key, reviewstate)
	
SELECT
	geom,
	table_enumerator.name::text,
	
	CASE WHEN  point_interest_temp.jurisdiction::text = 'other' THEN point_interest_temp.jur_other
	 ELSE tj.jurisdiction_label::text 
	 END AS jurisdiction,
	 
	date::date,
	latitude,
	longitude,
	altitude,
	accuracy,
	
	CASE WHEN  point_interest_temp.descriptor::text = 'other' THEN point_interest_temp.descriptor_other
	 ELSE table_descriptor.descriptor_label::text 
	 END AS descriptor,
	 
	resource_name::text,
	table_tenures.tenures_label::text,
	table_institutions.institutions_label::text,
	management_problems::text,
	resource_notes::text,
	image::text,
	key::text,
	reviewstate::text
FROM update.point_interest_temp
	LEFT OUTER JOIN "public".table_enumerator ON ( point_interest_temp.tec_name = table_enumerator.code  )
	LEFT OUTER JOIN "update".table_jurisdiction tj ON ( point_interest_temp.jurisdiction = tj.jurisdiction_name  )
	LEFT OUTER JOIN "update".table_descriptor ON ( point_interest_temp.descriptor = table_descriptor.descriptor_name  )
	LEFT OUTER JOIN "update".table_tenures ON ( point_interest_temp.tenure = table_tenures.tenures_name  )
	LEFT OUTER JOIN "update".table_institutions ON ( point_interest_temp.resource_manager = table_institutions.institutions_name  )
WHERE point_interest_temp.key NOT IN (SELECT KEY FROM "update".form_d1_point_of_interest) AND point_interest_temp.key NOT IN (SELECT KEY FROM public.form_d1_point_of_interest);

-- Add geometry
update "update".form_d1_point_of_interest
set geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
where geom is NULL;

-- Add image URLs where they don't exist
/*update "update".form_d1_point_of_interest
set image = concat('http://13.244.91.45:90/media/fzs/d1/',image)
where length(image) = 17;*/
update update.form_d1_point_of_interest
set image = concat('http://13.244.91.45:90/media/fzs/d1/'||image)
where length(image) = 17;

-- Drop temp
drop table "update".point_interest_temp;

--update public schema point of interest table
INSERT INTO public.form_d1_point_of_interest(
	geom, tec_name, jurisdiction, date, latitude, longitude, altitude, accuracy, descriptor, resource_name, tenure, resource_manager, management_problems, resource_notes, image, key)

SELECT geom, tec_name, jurisdiction, date, latitude, longitude, altitude, accuracy, descriptor, resource_name, tenure, resource_manager, management_problems, resource_notes, image, key
	FROM update.form_d1_point_of_interest
	WHERE update.form_d1_point_of_interest.key NOT IN (SELECT KEY FROM public.form_d1_point_of_interest);

DELETE FROM update.form_d1_point_of_interest
USING public.form_d1_point_of_interest
WHERE update.form_d1_point_of_interest.key = public.form_d1_point_of_interest.key;
	
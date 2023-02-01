---------------------------------------
-- Shared resources
-- Temp table
CREATE TABLE "update".area_temp (
	tec_name text NULL,
	jurisdiction text NULL,
	jur_other text NULL,
	"date" date NULL,
	ref_map_id text NULL,
	id_means text NULL,
	area_descriptor text NULL,
	other_area text NULL,
	res_name text NULL,
	auto_shp text NULL,
	res_code text NULL,
	tenure_type text NULL,
	management_institution text NULL,
	management_problems text NULL,
	management_notes text NULL,
	uses text NULL,
	principle_use text NULL,
	uses_other text NULL,
	use_rules text NULL,
	narrative text NULL,
	"key" varchar(80) NOT NULL,
	ReviewState text NULL
);

-- Copy from CSV
-- Column names here must correspond to the CSV export columns IN ORDER. There is some variance in column names from the ODK exports, which should mirror database standards under Phase 1
copy "update".area_temp(tec_name, jurisdiction, jur_other, date, ref_map_id, id_means, area_descriptor, other_area, res_name, auto_shp, res_code, tenure_type, management_institution, management_problems, management_notes, uses, principle_use, uses_other, use_rules, narrative, key, ReviewState)
from '/home/ubuntu/fzs/form_d2_shared_resources/Shared_Resources_Areas_V4_cut.csv'
DELIMITER ','
CSV HEADER;

-- Insert only new items
-- Same column names as above, same order
INSERT INTO update.form_d2_shared_resources(
	tec_name, jurisdiction, date, ref_map_id, id_means, area_descriptor, res_name, auto_shp, res_code, tenure_type, management_institution, management_problems, management_notes, uses, principle_use, uses_other, use_rules, narrative, key, reviewstate)
	
SELECT
	table_enumerator.name::text,
	
	CASE WHEN  area_temp.jurisdiction::text = 'other' THEN area_temp.jur_other
	 ELSE tj.jurisdiction_label::text 
	 END AS jurisdiction,
	 
	date::date,
	ref_map_id::text,
	table_means.means_label::text,
	
	CASE WHEN  area_temp.area_descriptor::text = 'other' THEN area_temp.area_descriptor
	 ELSE table_descriptor_area.descriptor_area_label::text 
	 END AS descriptor,
	 
	
	res_name::text,
	auto_shp,
	res_code::text,
	table_tenure_area.tenure_area_label::text,
	table_institutions.institutions_label::text,
		
	management_problems::text,
	management_notes::text,
	uses::text,
	table_use_areas.use_areas_label::text as principle_use,
	tua1.use_areas_label::text as uses_other,
	use_rules::text,
	narrative::text,
	key::text,
	reviewstate::text
FROM update.area_temp
	LEFT OUTER JOIN "public".table_enumerator ON ( area_temp.tec_name = table_enumerator.code  )
	LEFT OUTER JOIN "update".table_jurisdiction tj ON ( area_temp.jurisdiction = tj.jurisdiction_name  )
	LEFT OUTER JOIN "update".table_means ON ( area_temp.id_means = table_means.means_name  )
	LEFT OUTER JOIN "update".table_descriptor_area ON ( area_temp.area_descriptor = table_descriptor_area.descriptor_area_name  )
	LEFT OUTER JOIN "update".table_tenure_area ON ( area_temp.tenure_type = table_tenure_area.tenure_area_name  )
	LEFT OUTER JOIN "update".table_institutions ON ( area_temp.management_institution = table_institutions.institutions_name  )
	LEFT OUTER JOIN "update".table_use_areas ON ( area_temp.principle_use = table_use_areas.use_areas_name  )
	LEFT OUTER JOIN "update".table_use_areas tua1 ON ( area_temp.uses_other = tua1.use_areas_name  )
WHERE area_temp.key NOT IN (SELECT KEY FROM "update".form_d2_shared_resources) AND area_temp.key NOT IN (SELECT KEY FROM public.form_d2_shared_resources);

-- Drop temp
drop table "update".area_temp;

--update public schema shared resource table
INSERT INTO public.form_d2_shared_resources(
	tec_name, jurisdiction, date, ref_map_id, id_means, area_descriptor, res_name, auto_shp, res_code, tenure_type, management_institution, management_problems, management_notes, uses, principle_use, uses_other, use_rules, narrative, key)
	
SELECT tec_name, jurisdiction, date, ref_map_id, id_means, area_descriptor, res_name, auto_shp, res_code, tenure_type, management_institution, management_problems, management_notes, uses, principle_use, uses_other, use_rules, narrative, key
	FROM update.form_d2_shared_resources
	WHERE update.form_d2_shared_resources.key NOT IN (SELECT KEY FROM public.form_d2_shared_resources);

DELETE FROM update.form_d2_shared_resources
USING public.form_d2_shared_resources
WHERE update.form_d2_shared_resources.key = public.form_d2_shared_resources.key;
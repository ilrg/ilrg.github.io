UPDATE  public.form_f1_occ
SET conflict_reason = 'none'
WHERE conflict_reason IS NULL;

UPDATE  public.form_f1_occ
SET conflict_obs = 'none'
WHERE conflict_obs IS NULL;

UPDATE  public.form_f1_occ
SET certified = 'certify'
WHERE certified = 'Ready to certify - all signed, no changes';

UPDATE  public.form_f1_occ
SET certified = 'certify'
WHERE certified = 'NOT ready to certify, and needs corrections' AND bound_condition = 'no' AND vil_condition = 'no';

UPDATE  public.form_f1_occ
SET certified = 'certify'
WHERE certified = 'Not Ready to certify, needs a claim' AND bound_condition = 'no';

INSERT INTO public.certification(
	geom, date_of_survey, jurisdiction, vag, village, parcel_id, parcel, date_digitized, produced, key)

SELECT DISTINCT ON (fed."key")
p.geom,
fed."date",
fed.jurisdiction,
fed.vag, 
fed.village,
fed.parcel_id,
fed.parcel,
p.date_checked,
current_date as produced,
fed."key"
FROM "public".form_e1_demarcation fed 
	INNER JOIN "public".form_e2_claims fec ON ( fed.parcel_id = fec.parcel_id  )  
	INNER JOIN "public".parcels p ON ( fed.parcel_id = p.parcel_id  )  
	INNER JOIN "public".form_f1_occ ffo ON ( fed.parcel_id = ffo.parcel_id  )
WHERE fed."key" NOT IN (SELECT KEY FROM "public".certification);

UPDATE public.certification
set area_hectares =  ST_Area/10000 FROM (SELECT ST_Area(ST_Transform(geom, 32736)), parcel_id  FROM public.certification) AS a
WHERE certification.parcel_id = a.parcel_id;

UPDATE public.certification
set x_min = ST_XMin FROM (SELECT ST_XMin(ST_Transform(geom, 32736)), parcel_id from public.certification)as a
where certification.parcel_id = a.parcel_id;

UPDATE public.certification
set x_max = ST_XMax FROM (SELECT ST_XMax(ST_Transform(geom, 32736)), parcel_id from public.certification)as a
where certification.parcel_id = a.parcel_id;

UPDATE public.certification
set y_min = ST_YMin FROM (SELECT ST_YMin(ST_Transform(geom, 32736)), parcel_id from public.certification)as a
where certification.parcel_id = a.parcel_id;

UPDATE public.certification
set y_max = ST_YMax FROM (SELECT ST_YMax(ST_Transform(geom, 32736)), parcel_id from public.certification)as a
where certification.parcel_id = a.parcel_id;


CREATE EXTENSION IF NOT EXISTS dblink;

-- Clean DB first. !!!! DISABLE FOR SUBSEQUENT RUNS !!!!
/*
TRUNCATE public.application_party CASCADE;
TRUNCATE public.application_party_for_change CASCADE;
TRUNCATE public.application_parcel CASCADE;
TRUNCATE public.application_document CASCADE;
TRUNCATE public.party_document CASCADE;
TRUNCATE public.parcel_feature CASCADE;
TRUNCATE public.rrr_document CASCADE;
TRUNCATE public.document CASCADE;
TRUNCATE public.rightholder CASCADE;
TRUNCATE public.party CASCADE;
TRUNCATE public.rrr CASCADE;
TRUNCATE public.parcel CASCADE;
TRUNCATE public.application CASCADE;

TRUNCATE history.application_party;
TRUNCATE history.application_party_for_change;
TRUNCATE history.application_parcel;
TRUNCATE history.application_document;
TRUNCATE history.party_document;
TRUNCATE history.parcel_feature;
TRUNCATE history.rrr_document;
TRUNCATE history.document;
TRUNCATE history.rightholder;
TRUNCATE history.party;
TRUNCATE history.rrr;
TRUNCATE history.parcel;
TRUNCATE history.application;

TRUNCATE media.file CASCADE;
ALTER SEQUENCE application_number_seq RESTART WITH 1;
*/

-- Create transfer log table
DO
$do$
BEGIN
-------
IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'migration_log') THEN
 CREATE TABLE public.migration_log
 (
   id uuid PRIMARY KEY DEFAULT UUID_GENERATE_V4(), 
   upi character varying(100),
   msg character varying, 
   record_time timestamp without time zone NOT NULL DEFAULT now()
 ) 
 WITH (
  OIDS = FALSE
 );
ELSE
 TRUNCATE public.migration_log;
END IF;
-------
END
$do$;

-- Start migration
DO
$$
DECLARE

error_text text;
error_details text;
r record;
t record;
p record;
e record;
w record;
total int:=0;
app_id varchar;
old_parcel_id bigint;
new_parcel_id varchar;
new_right_id varchar;
new_party_id varchar;
file_id varchar;
doc_id varchar;
parcel_upi varchar;
failed int := 0;
success int := 0;

-- Configure this connection string, pointing to the admin database
conn_str varchar := 'postgres://postgres:Welcome1@localhost:5433/zambia?sslmode=disable';

land_type varchar;
land_use varchar;
village varchar;
survey_type varchar;
survey_method varchar;

citizenship varchar;
gender varchar;
id_type varchar;
entity_type varchar;
marital_status varchar;
age_range varchar;
province varchar;
chiefdom varchar;

occupancy_type varchar;
acquisition_type varchar;
owner_type varchar;
certified boolean;
parcel_status varchar;
reg_status varchar;
where_str varchar;

w1 varchar;
w2 varchar;
w3 varchar;

BEGIN
-------
-- Synchronize ref data tables first
for r in select * from dblink(conn_str, E'SELECT * FROM public.land_cover') as data(code character varying, land_cover character varying) loop
  if not exists (select code from public.ref_land_type where code = r.code) then 
    insert into public.ref_land_type(code, val) values (r.code, r.land_cover);
  else 
    update public.ref_land_type set val = r.land_cover where code = r.code and val != r.land_cover;
  end if;
end loop;


for r in select * from dblink(conn_str, E'SELECT * FROM public.land_use') as data(code character varying, land_use character varying) loop
  if not exists (select code from public.ref_landuse where code = r.code) then 
    insert into public.ref_landuse(code, val) values (r.code, r.land_use);
  else 
    update public.ref_landuse set val = r.land_use where code = r.code and val != r.land_use;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.survey_type') as data(code character varying, survey_type character varying) loop
  if not exists (select code from public.ref_survey_type where code = r.code) then 
    insert into public.ref_survey_type(code, val) values (r.code, r.survey_type);
  else 
    update public.ref_survey_type set val = r.survey_type where code = r.code and val != r.survey_type;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.survey_method') as data(code character varying, survey_method character varying) loop
  if not exists (select code from public.ref_survey_method where code = r.code) then 
    insert into public.ref_survey_method(code, val) values (r.code, r.survey_method);
  else 
    update public.ref_survey_method set val = r.survey_method where code = r.code and val != r.survey_method;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.land_category') as data(code character varying, land_category character varying) loop
  if not exists (select code from public.ref_occupancy_type where code = r.code) then 
    insert into public.ref_occupancy_type(code, val) values (r.code, r.land_category);
  else 
    update public.ref_occupancy_type set val = r.land_category where code = r.code and val != r.land_category;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.nationality') as data(code character varying, nationality character varying) loop
  if not exists (select code from public.ref_citizenship where code = r.code) then 
    insert into public.ref_citizenship(code, val) values (r.code, r.nationality);
  else 
    update public.ref_citizenship set val = r.nationality where code = r.code and val != r.nationality;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.gender') as data(code character varying, gender character varying) loop
  if not exists (select code from public.ref_gender where code = r.code) then 
    insert into public.ref_gender(code, val) values (r.code, r.gender);
  else 
    update public.ref_gender set val = r.gender where code = r.code and val != r.gender;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.id_document_type') as data(code character varying, documents character varying) loop
  if not exists (select code from public.ref_id_type where code = r.code) then 
    insert into public.ref_id_type(code, for_private, val) values (r.code, 't', r.documents);
  else 
    update public.ref_id_type set val = r.documents where code = r.code and val != r.documents;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.pj_id_document') as data(code character varying, pj_id_document character varying) loop
  if not exists (select code from public.ref_id_type where code = r.code) then 
    insert into public.ref_id_type(code, for_private, val) values (r.code, 'f', r.pj_id_document);
  else 
    update public.ref_id_type set val = r.pj_id_document where code = r.code and val != r.pj_id_document;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.pj_entity_type') as data(code character varying, pj_entity_type character varying) loop
  if not exists (select code from public.ref_entity_type where code = r.code) then 
    insert into public.ref_entity_type(code, val) values (r.code, r.pj_entity_type);
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.civil_status') as data(code character varying, civil_status character varying) loop
  if not exists (select code from public.ref_marital_status where code = r.code) then 
    insert into public.ref_marital_status(code, val) values (r.code, r.civil_status);
  else 
    update public.ref_marital_status set val = r.civil_status where code = r.code and val != r.civil_status;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT * FROM public.age_range') as data(code character varying, age_range character varying) loop
  if not exists (select code from public.ref_age_range where code = r.code) then 
    insert into public.ref_age_range(code, val) values (r.code, r.age_range);
  else 
    update public.ref_age_range set val = r.age_range where code = r.code and val != r.age_range;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT code, val, chiefdom_code, geom FROM public.areas') as data(code character varying, val character varying, chiefdom_code character varying, geom geometry) loop
  if not exists (select code from public.ref_area where code = r.code) then 
    insert into public.ref_area(code, val, chiefdom_code, geom) values (r.code, r.val, r.chiefdom_code, r.geom);
  else 
    update public.ref_area set val = r.val where code = r.code and val != r.code;
  end if;
end loop;

for r in select * from dblink(conn_str, E'SELECT code, val, area_code, geom FROM public.tmp_villages') as data(code character varying, val character varying, area_code character varying, geom geometry) loop
  if not exists (select code from public.ref_village where code = r.code) then 
    insert into public.ref_village(code, val, area_code, geom) values (r.code, r.val, r.area_code, r.geom);
  else 
    update public.ref_village set val = r.val, area_code = r.area_code where code = r.code and (val != r.val or area_code != r.area_code);
  end if;
end loop;

-- Loop through land parcels 
for r in select * from dblink(conn_str, E'SELECT * FROM public.parcels') 
  as data(geom geometry,
    parcel_transaction_status character varying,
    parcel_name character varying,
    parcel_id bigint,
    chiefdom_id character varying,
    village_name character varying,
    area_h double precision,
    perimeter_k double precision,
    x_min integer,
    x_max integer,
    y_min integer,
    y_max integer,
    access_type character varying,
    survey_type character varying,
    survey_method character varying,
    survey_date date,
    surveyor character varying,
    digitized_date date,
    digitizer character varying,
    certificate_date date,
    certificate_status character varying,
    land_use character varying,
    land_cover character varying,
    land_category character varying) where parcel_name not in (select upi from public.parcel)
loop
begin

 if r.parcel_transaction_status = 'Certified' then
   certified := true;
   app_id := null;
   parcel_status := 'active';
   reg_status := 'current';
 else 
   certified := false;
   app_id := uuid_generate_v4()::varchar;
   parcel_status := 'pending';
   reg_status := 'pending';
 end if;
 
 total := total + 1;
 if total%500 = 0 then
   raise notice '% processed...', total;
 end if;
   
 -- Check parcel doesn't exist
 parcel_upi := r.parcel_name;
 
 ---if not exists (select id from public.parcel where upi = parcel_upi) then
   old_parcel_id := r.parcel_id;
   new_parcel_id := uuid_generate_v4()::varchar;

   -- Make validations of parcel geometry and ref data fields
   if ST_NumGeometries(r.geom) > 1 then
     raise exception 'Multipolygons are not allowed';
   end if;

   land_type := (select code from public.ref_land_type where lower(val) = lower(r.land_cover) limit 1);
   if land_type is null and r.land_cover is not null and r.land_cover != '' then
     raise exception 'Land cover code was not found for "%"', r.land_cover;
   end if;
   
   land_use := (select code from public.ref_landuse where lower(val) = lower(r.land_use) limit 1);
   if land_use is null and r.land_use is not null and r.land_use != '' then
     raise exception 'Land use code was not found for "%"', r.land_use;
   end if;
   
   village := (select v.code from public.ref_village v inner join public.ref_area a on v.area_code = a.code where lower(v.val) = lower(r.village_name) and lower(a.chiefdom_code) = lower(r.chiefdom_id) limit 1);
   if village is null and r.village_name is not null and r.village_name != '' then
     raise exception 'Village code was not found for "%", chiefdom code "%"', r.village_name, r.chiefdom_id;
   end if;
   if village is null then
     raise exception 'Village code is null for UPI "%"', parcel_upi;
   end if;
   
   survey_type := (select code from public.ref_survey_type where lower(val) = lower(r.survey_type) limit 1);
   if survey_type is null and r.survey_type is not null and r.survey_type != '' then
     raise exception 'Survey type code was not found for "%"', r.survey_type;
   end if;

   survey_method := (select code from public.ref_survey_method where lower(val) = lower(r.survey_method) limit 1);
   if survey_method is null and r.survey_method is not null and r.survey_method != '' then
     raise exception 'Survey method code was not found for "%"', r.survey_method;
   end if;

   occupancy_type := (select code from public.ref_occupancy_type where lower(val) = lower(r.land_category) limit 1);
   if occupancy_type is null and r.land_category is not null and r.land_category != '' then
     raise exception 'Occupancy type code was not found for "%"', r.land_category;
   end if;

   -- Check parcel has registered rights
   if certified and not exists (select tenure_id from dblink(conn_str, E'SELECT tenure_id FROM public.tenure where parcel_id = ''' || parcel_upi || '''') as data(tenure_id character varying)) then
     raise exception 'Parcel "%" has no registered rights.', parcel_upi;
   end if;
   
   -- Check parcel has owners
   if certified and not exists (select tenure_id from dblink(conn_str, E'SELECT tenure_id FROM public.tenure where parcel_id = ''' || parcel_upi || ''' and tenure_role = ''Landholder''') as data(tenure_id character varying)) then
     raise exception 'Parcel "%" has no owners.', parcel_upi;
   end if;

   if not certified and not exists (select party_id from dblink(conn_str, E'SELECT party_id FROM public.parcel_applicant where parcel = ''' || parcel_upi || '''') as data(party_id character varying)) then
     raise exception 'Uncomplete parcel "%" has no applicants.', parcel_upi;
   end if;

   -- Create application for uncomplete parcels
   if not certified then
     INSERT INTO public.application(id, app_type_code, chiefdom_code, workflow_step_id, comment)
      VALUES (app_id, 'app-new-cert', r.chiefdom_id, 'step2', 'Parcel ID ' || r.parcel_name);
   end if;
   
   -- Insert parcel record
   INSERT INTO public.parcel(id, land_type_code, landuse_code, upi, village_code, survey_date, surveyor, survey_type_code, survey_method_code, geom, status_code, application_id)
    VALUES (new_parcel_id, land_type, land_use, parcel_upi, village, r.survey_date, r.surveyor, survey_type, survey_method, ST_GeometryN(r.geom, 1), parcel_status, app_id);

   -- Loop through the tenure rights  
   new_right_id := null;
   
   if certified then 
      where_str := ' and tenure_role = ''Landholder'' limit 1';
   else
      where_str := ' order by (case when tenure_role = ''Landholder'' then 0 else 1 end) limit 1';
   end if;
   
   for t in select * from dblink(conn_str, E'SELECT * FROM public.tenure where parcel_id = ''' || parcel_upi || '''' || where_str) 
    as data(tenure_id character varying,
	    parcel_id character varying,
	    party_id character varying,
	    tenure_role character varying,
	    tenure_acquired character varying,
	    tenure_responsibility character varying,
	    tenure_restriction character varying,
	    tenure_right character varying,
	    tenure_status character varying,
	    tenure_start date,
	    tenure_end date,
	    demarcation_receipt_path character varying,
	    demarcation_receipt bytea,
	    claims_receipt_path character varying,
	    claims_receipt bytea,
	    occ_image_path character varying,
	    occ_image bytea,
	    signature_images_path character varying,
	    signature_images bytea,
	    party_distribution_path character varying,
	    party_distribution bytea,
	    certificate_pdf character varying,
	    annex_pdf character varying)
   loop
   
     -- Check party exists
     if not exists (select party_id from dblink(conn_str, E'SELECT party_id FROM public.party where party_id = ''' || replace(t.party_id, '''', '''''') || '''') as data(party_id character varying)) then
       raise exception 'Party does not exists for tenure id "%"', t.tenure_id;
     end if;
     
     -- Make validations of reference data tables
     acquisition_type := (select code from public.ref_acquisition_type where lower(val) = lower(t.tenure_acquired) limit 1);
     if acquisition_type is null and t.tenure_acquired is not null and t.tenure_acquired != '' then
       raise exception 'Acquisition type code was not found for "%"', t.tenure_acquired;
     end if;
       
     new_right_id := uuid_generate_v4()::varchar;

     -- Get witnesses
     w1 := null;
     w2 := null;
     w3 := null;

     for w in select * from dblink(conn_str, E'SELECT parcel, given_name, family_name FROM public.witness') 
       as data(parcel character varying, given_name character varying, family_name character varying) where parcel = parcel_upi
     loop
       if w1 is null then
         w1 := coalesce(w.given_name) || ' ' || coalesce(w.family_name);
       end if;
       if w1 is not null and w2 is null then
         w2 := coalesce(w.given_name) || ' ' || coalesce(w.family_name);
       end if;
       if w2 is not null and w3 is null then
         w3 := coalesce(w.given_name) || ' ' || coalesce(w.family_name);
       end if;
     end loop;
  
     -- Insert tenure
        
     INSERT INTO public.rrr(id, parcel_id, right_type_code, occupancy_type_code, acquisition_type_code, allocation_date, reg_date, witness1, witness2, witness3, status_code, application_id)
     VALUES (new_right_id, new_parcel_id, 'landhold', occupancy_type, acquisition_type, t.tenure_start, r.certificate_date, w1, w2, w3, reg_status, app_id);     
     -- Insert tenure documents
     /*if t.demarcation_receipt_path is not null and length(t.demarcation_receipt_path) > 3 then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;
       
       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, t.demarcation_receipt_path, file_id || '_demarcation_receipt.jpg', 'image/jpeg', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, 'other', file_id, 'Demarcation receipt');

       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

     if t.claims_receipt_path is not null and length(t.claims_receipt_path) > 3 then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;
       
       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, t.claims_receipt_path, file_id || '_claims_receipt.jpg', 'image/jpeg', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, 'other', file_id, 'Claim receipt');

       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

     if t.occ_image_path is not null and length(t.occ_image_path) > 3 then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;

       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, t.occ_image_path, file_id || '_occ_image.jpg', 'image/jpeg', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, 'other', file_id, 'Objections, Corrections, Confirmations');

       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

     if t.signature_images_path is not null and length(t.signature_images_path) > 3 then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;

       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, t.signature_images_path, file_id || '_signature.jpg', 'image/jpeg', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, 'other', file_id, 'Signature');

       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

     if t.party_distribution_path is not null and length(t.party_distribution_path) > 3 then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;

       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, t.party_distribution_path, file_id || '_party_distribution.jpg', 'image/jpeg', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, 'other', file_id, 'Party distribution');

       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

     if t.party_distribution_path is not null and length(t.party_distribution_path) > 3 then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;

       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, t.party_distribution_path, file_id || '_party_distribution.jpg', 'image/jpeg', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, 'other', file_id, 'Party distribution');

       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

     if t.certificate_pdf is not null and length(t.certificate_pdf) > 3 then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;

       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, t.certificate_pdf, file_id || '_certificate.pdf', 'application/pdf', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, 'cust_cert', file_id, 'Certificate');

       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

     if t.annex_pdf is not null and length(t.annex_pdf) > 3 then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;

       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, t.annex_pdf, file_id || '_annex_pdf', 'application/pdf', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, 'cust_cert', file_id, 'Certificate annex');
 
       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;*/
   end loop;

   -- Insert tenure evidences
    
   for e in select * from dblink(conn_str, E'SELECT document_type, document_type_other, 
	replace(document_photo_1, ''http://13.244.91.45:90/media/'', '''') as document_photo_1_path,
	replace(document_photo_1, ''http://13.244.91.45:90/media/ilrg_admin/'', '''') as document_photo_1_file, 
	replace(document_photo_2, ''http://13.244.91.45:90/media/'', '''') as document_photo_2_path,
	replace(document_photo_2, ''http://13.244.91.45:90/media/ilrg_admin/'', '''') as document_photo_2_file 
      from public.temp_evidence
      where (document_photo_1 is not null or document_photo_1 is not null) and parcel = ''' || parcel_upi || '''') 
    as data(document_type character varying,
	document_type_other character varying,
	document_photo_1_path text,
	document_photo_1_file text,
	document_photo_2_path text,
	document_photo_2_file text)
   loop

     -- Check doc type exists
     if not exists (select code from public.ref_doc_type where code = e.document_type) then
       e.document_type := 'other';
     end if;

     if e.document_photo_1_file is not null and length(e.document_photo_1_file) > 3 and new_right_id is not null then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;
	 
       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, e.document_photo_1_path, e.document_photo_1_file, 'image/jpeg', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, e.document_type, file_id, e.document_type_other);
 
       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

     if e.document_photo_2_file is not null and length(e.document_photo_2_file) > 3 and new_right_id is not null then
       file_id := uuid_generate_v4()::varchar;
       doc_id := uuid_generate_v4()::varchar;

       INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
       VALUES (file_id, e.document_photo_2_path, e.document_photo_2_file, 'image/jpeg', 1000);

       INSERT INTO public.document(id, type_code, file_id, description)
       VALUES (doc_id, e.document_type, file_id, e.document_type_other);
 
       INSERT INTO public.rrr_document(rrr_id, document_id) VALUES (new_right_id, doc_id);
     end if;

   end loop;

   -- Insert parties
   for t in select * from dblink(conn_str, E'SELECT party_id, tenure_role FROM public.tenure where parcel_id = ''' || parcel_upi || '''') 
     as data(party_id character varying, tenure_role character varying)
   loop

     -- Loop through parties   
     for p in select * from dblink(conn_str, E'SELECT p.*, replace(person_path, ''http://13.244.91.45:90/media/ilrg_admin/'', '''') as photo_file_name,
	replace(person_path, ''http://13.244.91.45:90/media/'', '''') as photo_file_path, person_content_type, person_length,
	replace(id_front_path, ''http://13.244.91.45:90/media/ilrg_admin/'', '''') as id_front_file_name,
	replace(id_front_path, ''http://13.244.91.45:90/media/'', '''') as id_front_file_path, id_front_content_type, id_front_content_length,
	replace(id_back_path, ''http://13.244.91.45:90/media/ilrg_admin/'', '''') as id_back_file_name,
	replace(id_back_path, ''http://13.244.91.45:90/media/'', '''') as id_back_file_path, id_back_content_type, id_back_content_length
       FROM public.party p left join public.temp_photo tp on p.party_id = tp.party_id where p.party_id = ''' || replace(t.party_id, '''', '''''') || '''') 
       as data(party_id character varying,
	    survey_date date,
	    party_type character varying,
	    prefix character varying,
	    first_name character varying,
	    middle_name character varying,
	    family_name character varying,
	    suffix character varying,
	    gender character varying,
	    civil_status character varying,
	    place_of_birth character varying,
	    date_of_birth date,
	    year_of_birth integer,
	    age_range character varying,
	    nationality character varying,
	    tax_number character varying,
	    photo_person bytea,
	    photo_person_path character varying,
	    id_document character varying,
	    id_doc_number character varying,
	    id_place_of_issue character varying,
	    id_date_of_issue date,
	    id_date_of_expiry date,
	    id_photo_front bytea,
	    id_photo_front_path character varying,
	    id_photo_back bytea,
	    id_photo_back_path character varying,
	    phone character varying,
	    email character varying,
	    address_line_1 character varying,
	    address_line_2 character varying,
	    address_village character varying,
	    address_town character varying,
	    address_city character varying,
	    address_chiefdom character varying,
	    address_province character varying,
	    address_postcode character varying,
	    party_status character varying,
	    date_of_death date,
	    juridical_name character varying,
	    entity_type character varying,
	    registration_no character varying,
	    date_registration date,
	    date_dissolution date,
	    age_grouped text,
	    photo_file_name text,
	    photo_file_path text,
	    person_content_type character varying,
	    person_length integer,
	    id_front_file_name text,
	    id_front_file_path text,
	    id_front_content_type character varying,
	    id_front_content_length integer,
	    id_back_file_name text,
	    id_back_file_path text,
	    id_back_content_type character varying,
	    id_back_content_length integer)
     loop

       -- Make validations of reference data tables
       new_party_id := uuid_generate_v4()::varchar;

       -- Check person has role
       if p.party_type = 'Physical' and (t.tenure_role is null or length(t.tenure_role) < 2) then
         raise exception 'Person with id "%" has no tenure role. Parcel "%".', p.party_id, parcel_upi;
       end if;
       
       citizenship := (select code from public.ref_citizenship where lower(val) = lower(p.nationality) limit 1);
       if citizenship is null and p.nationality is not null and p.nationality != '' then
         raise exception 'Citizenship code was not found for "%"', p.nationality;
       end if;

       gender := (select code from public.ref_gender where lower(val) = lower(p.gender) limit 1);
       if gender is null and p.gender is not null and p.gender != '' then
         raise exception 'Gender code was not found for "%"', p.gender;
       end if;

      
       id_type := (select code from public.ref_id_type where lower(val) = lower(p.id_document) limit 1);
       if id_type is null and p.id_document is not null and p.id_document != '' then
         raise exception 'ID type code was not found for "%"', p.id_document;
       end if;

       if p.party_type = 'Juridical' then
         entity_type := (select code from public.ref_entity_type where lower(val) = lower(p.entity_type) limit 1);
         if entity_type is null and p.entity_type is not null and p.entity_type != '' then
           raise exception 'Entity type code was not found for "%"', p.entity_type;
         end if;
       end if;
       
       marital_status := (select code from public.ref_marital_status where lower(val) = lower(p.civil_status) limit 1);
       if marital_status is null and p.civil_status is not null and p.civil_status != '' then
         raise exception 'Marital status code was not found for "%"', p.civil_status;
       end if;

       age_range := (select code from public.ref_age_range where lower(val) = lower(p.age_range) limit 1);
       if age_range is null and p.age_range is not null and p.age_range != '' then
         raise exception 'Age range code was not found for "%"', p.age_range;
       end if;

       province := (select code from public.ref_province where lower(val) = trim(lower(p.address_province)) limit 1);
       if province is null and p.address_province is not null and p.address_province != '' then
         raise exception 'Party: Province code was not found for "%"', p.address_province;
       end if;

       chiefdom := (select code from public.ref_chiefdom where lower(val) = trim(lower(p.address_chiefdom)) and province_code = province limit 1);
       if chiefdom is null and p.address_chiefdom is not null and p.address_chiefdom != '' then
         raise exception 'Party: Chiefdom code was not found for "%" under province "%"', p.address_chiefdom, province;
       end if;

       village := (select v.code from public.ref_village v inner join public.ref_area a on v.area_code = a.code where lower(v.val) = trim(lower(p.address_village)) and lower(a.chiefdom_code) = lower(chiefdom) limit 1);
       if village is null and p.address_village is not null and p.address_village != '' then
         raise exception 'Party: Village code was not found for "%", chiefdom code "%"', p.address_village, chiefdom;
       end if;
       
       owner_type := (select code from public.ref_owner_type where lower(val) = lower(t.tenure_role) limit 1);
       if owner_type is null and t.tenure_role is not null and t.tenure_role != '' then
         raise exception 'Party: Tenure role code was not found for "%"', t.tenure_role;
       end if;

       -- Insert photo
       file_id := null;
       
       if p.photo_file_name is not null and length(p.photo_file_name) > 3 then
         file_id := uuid_generate_v4()::varchar;

	 if p.person_content_type is null or p.person_content_type = '' then
	   p.person_content_type := 'image/jpeg';
	 end if;

	 if p.person_length is null or p.person_length = 0 then
	   p.person_length := 1000;
	 end if;
	 
         INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
         VALUES (file_id, p.photo_file_path, p.photo_file_name, p.person_content_type, p.person_length);
       end if;

       if p.party_type is null then
         p.party_type := 'Physical';
       end if;

       if p.party_type = 'Physical' and (p.first_name is null or p.family_name is null) then
         raise exception 'Person with id "%" has no first and/or last name.', p.party_id;
       end if;
       
       -- Insert party
       INSERT INTO public.party(id, is_private, name1, name2, name3, citizenship_code, 
            gender_code, id_type_code, id_number, entity_type_code, marital_status_code, 
            dob, dob_year, age_range_code, province_code, chiefdom_code, 
            village_code, place_of_birth, mobile_number, address, person_photo_id)
       VALUES (new_party_id, p.party_type = 'Physical', 
            (case when p.party_type = 'Juridical' then coalesce(p.juridical_name, coalesce(p.first_name, '') || ' ' || coalesce(p.family_name, '')) else p.first_name end), 
            (case when p.party_type = 'Juridical' then null else p.family_name end), 
            (case when p.party_type = 'Juridical' then null else p.middle_name end), citizenship, gender, id_type, p.id_doc_number, entity_type, marital_status,
            p.date_of_birth, p.year_of_birth, age_range, province, chiefdom, village, p.place_of_birth, p.phone, 
            coalesce(p.address_line_1, ''), file_id);

       -- Insert party documents
       if p.id_front_file_name is not null and length(p.id_front_file_name) > 3 then
         file_id := uuid_generate_v4()::varchar;
         doc_id := uuid_generate_v4()::varchar;
         
	 if p.id_front_content_type is null or p.id_front_content_type = '' then
	   p.id_front_content_type := 'image/jpeg';
	 end if;

	 if p.id_front_content_length is null or p.id_front_content_length = 0 then
	   p.id_front_content_length := 1000;
	 end if;
	 
         INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
         VALUES (file_id, p.id_front_file_path, p.id_front_file_name, p.id_front_content_type, p.id_front_content_length);

         INSERT INTO public.document(id, type_code, file_id, ref_number, doc_date, authority, expiry_date, description)
         VALUES (doc_id, 'id_doc', file_id, p.id_doc_number, p.id_date_of_issue, p.id_place_of_issue, p.id_date_of_expiry, 'ID copy');

         INSERT INTO public.party_document(party_id, document_id) VALUES (new_party_id, doc_id);
       end if;

       if p.id_back_file_name is not null and length(p.id_back_file_name) > 3 then
         file_id := uuid_generate_v4()::varchar;
         doc_id := uuid_generate_v4()::varchar;

         if p.id_back_content_type is null or p.id_back_content_type = '' then
	   p.id_back_content_type := 'image/jpeg';
	 end if;

	 if p.id_back_content_length is null or p.id_back_content_length = 0 then
	   p.id_back_content_length := 1000;
	 end if;

         INSERT INTO media.file(id, file_path, original_file_name, media_type, file_size)
         VALUES (file_id, p.id_back_file_path, p.id_back_file_name, p.id_back_content_type, p.id_back_content_length);

         INSERT INTO public.document(id, type_code, file_id, ref_number, doc_date, authority, expiry_date, description)
         VALUES (doc_id, 'id_doc', file_id, p.id_doc_number, p.id_date_of_issue, p.id_place_of_issue, p.id_date_of_expiry, 'ID copy (back)');

         INSERT INTO public.party_document(party_id, document_id) VALUES (new_party_id, doc_id);
       end if;

       -- Insert rightholder
       if new_right_id is not null then
         INSERT INTO public.rightholder(rrr_id, party_id, owner_type_code) VALUES (new_right_id, new_party_id, owner_type);
       end if;

       -- Add party as an applicant for uncomplete cases
       if not certified then
         INSERT INTO public.application_party (app_id, party_id) VALUES (app_id, new_party_id);
       end if;

     end loop;

     -- Insert parties which were not found under tenure, but still have relation to the parcel under 
   end loop;

-- Insert parties for uncompleted cases
   if not certified then
    
     for p in select * from dblink(conn_str, E'select * from parcel_applicant where parcel = ''' || parcel_upi || ''' and party_id not in (select party_id from tenure)') 
       as data(party_id character varying,
	    parcel character varying,
	    survey_date date,
	    party_type character varying,
	    party_role character varying,
	    prefix character varying,
	    first_name character varying,
	    middle_name character varying,
	    family_name character varying,
	    suffix character varying,
	    gender character varying,
	    civil_status character varying,
	    place_of_birth character varying,
	    date_of_birth date,
	    year_of_birth character varying,
	    age_range character varying,
	    nationality character varying,
	    id_document character varying,
	    id_doc_number character varying,
	    address_village character varying,
	    address_chiefdom character varying,
	    address_province character varying,
	    party_status character varying,
	    age_grouped character varying)
     loop
       -- Make validations of reference data tables
       new_party_id := uuid_generate_v4()::varchar;

       -- Check person has role
       if p.party_type = 'Physical' and (p.party_role is null or length(p.party_role) < 2) then
         raise exception 'Person with id "%" has no tenure role. Parcel "%".', p.party_id, parcel_upi;
       end if;
       
       citizenship := (select code from public.ref_citizenship where lower(val) = lower(p.nationality) limit 1);
       if citizenship is null and p.nationality is not null and p.nationality != '' then
         raise exception 'Citizenship code was not found for "%"', p.nationality;
       end if;

       gender := (select code from public.ref_gender where lower(val) = lower(p.gender) limit 1);
       if gender is null and p.gender is not null and p.gender != '' then
         raise exception 'Gender code was not found for "%"', p.gender;
       end if;

      
       id_type := (select code from public.ref_id_type where lower(val) = lower(p.id_document) limit 1);
       if id_type is null and p.id_document is not null and p.id_document != '' then
         raise exception 'ID type code was not found for "%"', p.id_document;
       end if;
       
       marital_status := (select code from public.ref_marital_status where lower(val) = lower(p.civil_status) limit 1);
       if marital_status is null and p.civil_status is not null and p.civil_status != '' then
         raise exception 'Marital status code was not found for "%"', p.civil_status;
       end if;

       entity_type := null;
       
       age_range := (select code from public.ref_age_range where lower(val) = lower(p.age_range) limit 1);
       if age_range is null and p.age_range is not null and p.age_range != '' then
         raise exception 'Age range code was not found for "%"', p.age_range;
       end if;

       province := (select code from public.ref_province where lower(val) = trim(lower(p.address_province)) limit 1);
       if province is null and p.address_province is not null and p.address_province != '' then
         raise exception 'Party Applicant: Province code was not found for "%"', p.address_province;
       end if;

       chiefdom := (select code from public.ref_chiefdom where lower(val) = trim(lower(p.address_chiefdom)) and province_code = province limit 1);
       if chiefdom is null and p.address_chiefdom is not null and p.address_chiefdom != '' then
         raise exception 'Party Applicant: Chiefdom code was not found for "%" under province "%"', p.address_chiefdom, province;
       end if;

       village := (select v.code from public.ref_village v inner join public.ref_area a on v.area_code = a.code where lower(v.val) = trim(lower(p.address_village)) and lower(a.chiefdom_code) = lower(chiefdom) limit 1);
       if village is null and p.address_village is not null and p.address_village != '' then
         raise exception 'Party Applicant: Village code was not found for "%", chiefdom code "%"', p.address_village, chiefdom;
       end if;
       
       owner_type := (select code from public.ref_owner_type where lower(val) = lower(p.party_role) limit 1);
       if owner_type is null and p.party_role is not null and p.party_role != '' then
         raise exception 'Party Applicant: Tenure role code was not found for "%"', p.party_role;
       end if;
       
       if p.party_type is null then
         p.party_type := 'Physical';
       end if;

       if p.party_type = 'Physical' and (p.first_name is null or p.family_name is null) then
         raise exception 'Person Applicant with id "%" has no first and/or last name.', p.party_id;
       end if;

       -- Insert party
       INSERT INTO public.party(id, is_private, name1, name2, name3, citizenship_code, 
            gender_code, id_type_code, id_number, entity_type_code, marital_status_code, 
            dob, dob_year, age_range_code, province_code, chiefdom_code, 
            village_code, place_of_birth)
       VALUES (new_party_id, p.party_type = 'Physical', 
            p.first_name, p.family_name, p.middle_name, citizenship, gender, id_type, p.id_doc_number, entity_type, marital_status,
            p.date_of_birth, p.year_of_birth::int, age_range, province, chiefdom, village, p.place_of_birth);

       -- Insert rightholder
       if new_right_id is not null then
	 INSERT INTO public.rightholder(rrr_id, party_id, owner_type_code) VALUES (new_right_id, new_party_id, owner_type);
       end if;

       -- Add party as an applicant for uncomplete cases
       INSERT INTO public.application_party (app_id, party_id) VALUES (app_id, new_party_id);
       
     end loop;

   end if;

   success := success + 1;
 --end if;

EXCEPTION

 WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS error_text = MESSAGE_TEXT, error_details = PG_EXCEPTION_CONTEXT;
  -- More debug https://www.postgresql.org/docs/current/plpgsql-control-structures.html
  failed := failed + 1;
  insert into migration_log (upi, msg, record_time) values (parcel_upi, 'Error: ' || error_text, now());
end;
 
end loop;

raise notice 'Parcels total: %. Migrated: %. Failed: %. Check migration_log for more details', total, success, failed;

-------
END
$$;

-- select count(1) from parcel
-- select * from migration_log order by msg
-- select msg, count(1) as cases from migration_log group by msg order by msg

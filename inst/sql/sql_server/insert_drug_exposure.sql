

insert into @cdm_schema.drug_exposure (
drug_exposure_id,
person_id,
drug_concept_id,
drug_exposure_start_date,
drug_exposure_start_datetime,
drug_exposure_end_date,
drug_exposure_end_datetime,
verbatim_end_date,
drug_type_concept_id,
stop_reason,
refills,
quantity,
days_supply,
sig,
route_concept_id,
lot_number,
provider_id,
visit_occurrence_id,
visit_detail_id,
drug_source_value,
drug_source_concept_id,
route_source_value,
dose_unit_source_value
)
select
row_number()over(order by p.person_id),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
c.start,
c.start,
coalesce(c.stop,c.start),
coalesce(c.stop,c.start),
c.stop,
581452,
cast(null as varchar),
0,
0,
coalesce(datediff(day,c.start,c.stop),0),
cast(null as varchar),
0,
0,
0,
(select fv.visit_occurrence_id_new from @cdm_schema.final_visit_ids fv
  where fv.encounter_id = c.encounter) visit_occurrence_id,
0,
c.code,
(
	select case when source_concept_id is NULL then 0 else source_concept_id end as source_concept_id
	from (
		select srctosrcvm.source_concept_id
	   from @vocab_schema.source_to_source_vocab_map srctosrcvm
	  where srctosrcvm.source_code = c.code
	    and srctosrcvm.source_vocabulary_id  = 'SNOMED'
	    ) a
),
cast(null as varchar),
cast(null as varchar)

from @synthea_schema.conditions c
left join @vocab_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = c.code
 and srctostdvm.target_domain_id        = 'Drug'
 and srctostdvm.target_vocabulary_id    = 'RxNorm'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join @cdm_schema.person p
  on p.person_source_value    = c.patient

union all

select
row_number()over(order by p.person_id),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
m.start,
m.start,
coalesce(m.stop,m.start),
coalesce(m.stop,m.start),
m.stop,
38000177,
cast(null as varchar),
0,
0,
coalesce(datediff(day,m.start,m.stop),0),
cast(null as varchar),
0,
0,
0,
(select fv.visit_occurrence_id_new from @cdm_schema.final_visit_ids fv
  where fv.encounter_id = m.encounter) visit_occurrence_id,
0,
m.code,
(
	select case when source_concept_id is NULL then 0 else source_concept_id end as source_concept_id
	from (
		select srctosrcvm.source_concept_id
	   from @vocab_schema.source_to_source_vocab_map srctosrcvm
	  where srctosrcvm.source_code = m.code
	    and srctosrcvm.source_vocabulary_id  = 'RxNorm'
	    ) a
),
cast(null as varchar),
cast(null as varchar)

from @synthea_schema.medications m
left join @vocab_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = m.code
 and srctostdvm.target_domain_id        = 'Drug'
 and srctostdvm.target_vocabulary_id    = 'RxNorm'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join @cdm_schema.person p
  on p.person_source_value    = m.patient

union all

select
row_number()over(order by p.person_id),
p.person_id,
case when srctostdvm.target_concept_id is NULL then 0 else srctostdvm.target_concept_id end as target_concept_id,
i.date,
i.date,
i.date,
i.date,
i.date,
581452,
cast(null as varchar),
0,
0,
0,
cast(null as varchar),
0,
0,
0,
(select fv.visit_occurrence_id_new from @cdm_schema.final_visit_ids fv
  where fv.encounter_id = i.encounter) visit_occurrence_id,
0,
i.code,
(
 select case when source_concept_id is NULL then 0 else source_concept_id end as source_concept_id
 from (
		 select srctosrcvm.source_concept_id
		   from @vocab_schema.source_to_source_vocab_map srctosrcvm
		  where srctosrcvm.source_code = i.code
		    and srctosrcvm.source_vocabulary_id  = 'CVX'
		    ) a
),
cast(null as varchar),
cast(null as varchar)

from @synthea_schema.immunizations i
left join @vocab_schema.source_to_standard_vocab_map srctostdvm
  on srctostdvm.source_code             = i.code
 and srctostdvm.target_domain_id        = 'Drug'
 and srctostdvm.target_vocabulary_id    = 'CVX'
 and srctostdvm.target_standard_concept = 'S'
 and srctostdvm.target_invalid_reason IS NULL
join @cdm_schema.person p
  on p.person_source_value    = i.patient;

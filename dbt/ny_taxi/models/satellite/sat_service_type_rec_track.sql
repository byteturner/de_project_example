{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
tracked_hashkey: hk_service_type_h
source_models:
    - name: stg_fhv
      rsrc_static: 'fhv_taxi_raw_data'
    - name: stg_yellow
      hk_column: hk_service_type_h
      rsrc_static: 'yellow_taxi_raw_data'
    - name: stg_green
      hk_column: hk_service_type_h
      rsrc_static: 'green_taxi_raw_data'
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.rec_track_sat(tracked_hashkey=metadata_dict['tracked_hashkey'],
                                source_models=metadata_dict['source_models']) }}
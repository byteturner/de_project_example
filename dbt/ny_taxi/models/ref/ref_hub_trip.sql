{{ config(materialized='incremental',
        schema='Core') }}

{%- set yaml_metadata -%}
source_models:
    - name: stg_fhv
      rsrc_static: 'fhv_taxi_raw_data'
    - name: stg_green
      ref_keys: hk_trip_r
      rsrc_static: 'green_taxi_raw_data'
    - name: stg_yellow
      ref_keys: hk_trip_r
      rsrc_static: 'yellow_taxi_raw_data'
ref_keys: hk_trip_r
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.ref_hub(source_models=metadata_dict['source_models'],
                    ref_keys=metadata_dict['ref_keys']) }}
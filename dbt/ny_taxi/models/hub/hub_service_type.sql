{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
hashkey: 'hk_service_type_h'
business_keys:
    - service_type
source_models:
    - name: stg_fhv
      rsrc_static: 'fhv_taxi_raw_data'
    - name: stg_yellow
      hk_column: 'hk_service_type_h'
      bk_columns:
          - service_type
      rsrc_static: 'yellow_taxi_raw_data'
    - name: stg_green
      hk_column: 'hk_service_type_h'
      bk_columns:
          - service_type
      rsrc_static: 'green_taxi_raw_data'
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set hashkey = metadata_dict['hashkey'] -%}
{%- set business_keys = metadata_dict['business_keys'] -%}
{%- set source_models = metadata_dict['source_models'] -%}

{{ datavault4dbt.hub(hashkey=hashkey,
                    business_keys=business_keys,
                    source_models=source_models) }}
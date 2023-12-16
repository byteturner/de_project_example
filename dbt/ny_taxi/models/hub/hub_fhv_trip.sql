{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
hashkey: 'hk_trip_h'
business_keys:
    - source_provider_id
    - source_pickup_location_id
    - source_dropoff_location_id
    - source_dl_file
    - source_file_row_number
source_models: stg_fhv
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set hashkey = metadata_dict['hashkey'] -%}
{%- set business_keys = metadata_dict['business_keys'] -%}
{%- set source_models = metadata_dict['source_models'] -%}

{{ datavault4dbt.hub(hashkey=hashkey,
                    business_keys=business_keys,
                    source_models=source_models) }}
{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
hashkey: 'hk_trip_h'
business_keys:
    - source_pickup_location_id
    - source_dropoff_location_id
    - source_dl_file
    - source_file_row_number
source_models:
    - name: stg_green
      rsrc_static: 'green_taxi_raw_data'
    - name: stg_yellow
      hk_column: 'hk_trip_h'
      bk_columns:
        - source_pickup_location_id
        - source_dropoff_location_id
        - source_dl_file
        - source_file_row_number
      rsrc_static: 'yellow_taxi_raw_data'
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set hashkey = metadata_dict['hashkey'] -%}
{%- set business_keys = metadata_dict['business_keys'] -%}
{%- set source_models = metadata_dict['source_models'] -%}

{{ datavault4dbt.hub(hashkey=hashkey,
                    business_keys=business_keys,
                    source_models=source_models) }}
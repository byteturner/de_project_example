{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
hashkey: 'hk_location_id_h'
business_keys:
    - location_id
    - service_type
source_models:
    - name: stg_fhv
      rsrc_static: '!fhv_taxi_raw_data'
    - name: stg_fhv
      hk_column: hk_pickup_location_id_h
      bk_columns:
        - source_pickup_location_id
        - service_type
      rsrc_static: '!fhv_taxi_raw_data'
    - name: stg_fhv
      hk_column: hk_dropoff_location_id_h
      bk_columns:
        - source_dropoff_location_id
        - service_type
      rsrc_static: '!fhv_taxi_raw_data'
    - name: stg_green
      hk_column: hk_dropoff_location_id_h
      bk_columns:
        - source_dropoff_location_id
        - service_type
      rsrc_static: '!green_taxi_raw_data'
    - name: stg_green
      hk_column: source_pickup_location_id
      bk_columns:
        - source_pickup_location_id
        - service_type
      rsrc_static: '!green_taxi_raw_data'
    - name: stg_yellow
      hk_column: source_pickup_location_id
      bk_columns:
        - source_pickup_location_id
        - service_type
      rsrc_static: '!yellow_taxi_raw_data'
    - name: stg_yellow
      hk_column: hk_dropoff_location_id_h
      bk_columns:
        - source_dropoff_location_id
        - service_type
      rsrc_static: '!yellow_taxi_raw_data'
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set hashkey = metadata_dict['hashkey'] -%}
{%- set business_keys = metadata_dict['business_keys'] -%}
{%- set source_models = metadata_dict['source_models'] -%}

{{ datavault4dbt.hub(hashkey=hashkey,
                    business_keys=business_keys,
                    source_models=source_models) }}
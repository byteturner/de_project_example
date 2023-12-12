{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model:
    fhv_raw: 'fhv'
include_source_columns: false
ldts: 'load_dttm'
rsrc: '!fhv_taxi_raw_data'
hashed_columns:
    hk_service_type_h:
        - service_type
    hk_provider_h:
        - dispatching_base_num
        - service_type
    hk_pickup_location_id_h:
        - pulocationid
    hk_dropoff_location_id_h:
        - dolocationid
derived_columns:
    service_type:
        value: '!fhv'
        datatype: 'STRING'
    pickup_ts:
        value: 'TO_TIMESTAMP_NTZ(pickup_datetime)'
        datatype: 'TIMESTAMP_NTZ'
        src_cols_required: pickup_datetime
    dropoff_ts:
        value: 'TO_TIMESTAMP_NTZ(dropoff_datetime)'
        datatype: 'TIMESTAMP_NTZ'
        src_cols_required: dropoff_datetime
    source_pickup_location_id:
        value: 'pulocationid'
        datatype: 'NUMBER'
        src_cols_required: pulocationid
    source_dropoff_location_id:
        value: 'dolocationid'
        datatype: 'NUMBER'
        src_cols_required: dolocationid
    source_provider_id:
        value: 'dispatching_base_num'
        datatype: 'STRING'
        src_cols_required: dispatching_base_num
    source_affiliated_provider_id:
        value: 'affiliated_base_number'
        datatype: 'STRING'
        src_cols_required: affiliated_base_number
    source_shared_ride_flag:
        value: 'sr_flag'
        datatype: 'STRING'
        src_cols_required: sr_flag
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set source_model = metadata_dict['source_model'] -%}
{%- set ldts = metadata_dict['ldts'] -%}
{%- set rsrc = metadata_dict['rsrc'] -%}
{%- set hashed_columns = metadata_dict['hashed_columns'] -%}
{%- set derived_columns = metadata_dict['derived_columns'] -%}
{%- set include_source_columns = metadata_dict['include_source_columns'] -%}

{{
    datavault4dbt.stage(
        source_model=source_model,
        ldts=ldts,
        rsrc=rsrc,
        hashed_columns=hashed_columns,
        derived_columns=derived_columns,
        include_source_columns=include_source_columns
    )
}}
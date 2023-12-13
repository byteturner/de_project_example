{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model:
    fhv_raw: 'fhv'
include_source_columns: false
ldts: 'load_dttm'
rsrc: '!fhv_taxi_raw_data'
hashed_columns:
    hk_location_id_h:
        - pulocationid
        - service_type
derived_columns:
    service_type:
        value: '!fhv'
        datatype: 'STRING'
    location_id:
        value: 'COALESCE(pulocationid, -1)'
        datatype: 'NUMBER'
        src_cols_required: pulocationid
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
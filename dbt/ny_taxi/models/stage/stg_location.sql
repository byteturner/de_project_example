{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model:
    location_raw: 'location'
include_source_columns: true
ldts: 'load_dttm'
rsrc: '!location_raw_data'
hashed_columns:
    hk_location_id_h:
        - location_id
    hd_location_id_s:
        is_hashdiff: true
        columns:
            - borough
            - zone
            - service_zone
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set source_model = metadata_dict['source_model'] -%}
{%- set ldts = metadata_dict['ldts'] -%}
{%- set rsrc = metadata_dict['rsrc'] -%}
{%- set hashed_columns = metadata_dict['hashed_columns'] -%}
{%- set include_source_columns = metadata_dict['include_source_columns'] -%}

{{
    datavault4dbt.stage(
        source_model=source_model,
        ldts=ldts,
        rsrc=rsrc,
        hashed_columns=hashed_columns,
        include_source_columns=include_source_columns
    )
}}
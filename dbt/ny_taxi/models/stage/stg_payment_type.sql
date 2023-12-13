{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model:
    payment_type_raw: 'payment_type'
include_source_columns: true
ldts: 'load_dttm'
rsrc: '!payment_type_raw_data'
hashed_columns:
    hk_payment_type_id_h:
        - payment_type_id
    hd_payment_type_id_s:
        is_hashdiff: true
        columns:
            - payment_type_name
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
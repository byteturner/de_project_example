{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
hashkey: 'hk_location_id_h'
business_keys:
    - location_id
source_models: stg_location
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set hashkey = metadata_dict['hashkey'] -%}
{%- set business_keys = metadata_dict['business_keys'] -%}
{%- set source_models = metadata_dict['source_models'] -%}

{{ datavault4dbt.hub(hashkey=hashkey,
                    business_keys=business_keys,
                    source_models=source_models)}}
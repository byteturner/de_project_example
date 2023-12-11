{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 'fhv_raw':'fhv'
ldts: 'load_dttm'
rsrc: 'source_file'
hashed_columns:
    hk_dispatching_base_num_h:
        - dispatching_base_num
    hk_pickup_location_id_h:
        - pulocationid
    hk_dropoff_location_id_h:
        - dolocationid
    hk_affiliated_base_num_h:
        - affiliated_base_number
derived_columns:
    service_type:
        value: 'fhv'
        type: 'string'
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ log(metadata_dict, info=True) }}

{{ datavault4dbt.stage(source_model=metadata_dict['source_model'],
                    ldts=metadata_dict['ldts'],
                    rsrc=metadata_dict['rsrc'],
                    hashed_columns=metadata_dict['hashed_columns'],
                    derived_columns=metadata_dict['derived_columns'],
                    include_source_columns=true) }}
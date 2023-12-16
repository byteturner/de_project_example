{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
parent_hashkey: 'hk_trip_h'
src_hashdiff: 'hd_trip_s'
src_payload:
        - source_passenger_count
        - source_trip_distance
        - source_store_and_forward_flag
        - source_fare_amount
        - source_extra
        - source_mta_tax
        - source_tip_amount
        - source_tolls_amount
        - source_total_amount
        - source_congestion_surcharge
        - source_airport_fee
source_model: 'stg_yellow'
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.sat_v0(parent_hashkey=metadata_dict['parent_hashkey'],
                        src_hashdiff=metadata_dict['src_hashdiff'],
                        source_model=metadata_dict['source_model'],
                        src_payload=metadata_dict['src_payload']) }}
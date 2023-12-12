{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model:
    green_raw: 'green'
include_source_columns: false
ldts: 'load_dttm'
rsrc: '!green_taxi_raw_data'
hashed_columns:
    hk_service_type_h:
        - service_type
    hk_provider_h:
        - vendorid
        - service_type
    hk_pickup_location_id_h:
        - pulocationid
    hk_dropoff_location_id_h:
        - dolocationid
    hk_rate_code_id_h:
        - ratecodeid
    hk_payment_type_id_h:
        - ratecodeid
derived_columns:
    service_type:
        value: '!green'
        datatype: 'STRING'
    pickup_ts:
        value: 'TO_TIMESTAMP_NTZ(lpep_pickup_datetime)'
        datatype: 'TIMESTAMP_NTZ'
        src_cols_required: lpep_pickup_datetime
    dropoff_ts:
        value: 'TO_TIMESTAMP_NTZ(lpep_dropoff_datetime)'
        datatype: 'TIMESTAMP_NTZ'
        src_cols_required: lpep_dropoff_datetime
    source_rate_code_id:
        value: 'ratecodeid'
        datatype: 'NUMBER'
        src_cols_required: ratecodeid
    source_store_and_forward_flag:
        value: 'store_and_fwd_flag'
        datatype: 'STRING'
        src_cols_required: store_and_fwd_flag
    source_payment_type_id:
        value: 'payment_type'
        datatype: 'NUMBER'
        src_cols_required: payment_type
    source_passenger_count:
        value: 'passenger_count'
        datatype: 'NUMBER'
        src_cols_required: passenger_count
    source_trip_distance:
        value: 'trip_distance'
        datatype: 'FLOAT4'
        src_cols_required: trip_distance
    source_fare_amount:
        value: 'fare_amount'
        datatype: 'FLOAT4'
        src_cols_required: fare_amount
    source_extra:
        value: 'extra'
        datatype: 'FLOAT4'
        src_cols_required: extra
    source_mta_tax:
        value: 'mta_tax'
        datatype: 'FLOAT4'
        src_cols_required: mta_tax
    source_tip_amount:
        value: 'tip_amount'
        datatype: 'FLOAT4'
        src_cols_required: tip_amount
    source_tolls_amount:
        value: 'tolls_amount'
        datatype: 'FLOAT4'
        src_cols_required: tolls_amount
    source_improvement_surcharge:
        value: 'improvement_surcharge'
        datatype: 'FLOAT4'
        src_cols_required: improvement_surcharge
    source_total_amount:
        value: 'total_amount'
        datatype: 'FLOAT4'
        src_cols_required: total_amount
    source_congestion_surcharge:
        value: 'congestion_surcharge'
        datatype: 'FLOAT4'
        src_cols_required: congestion_surcharge
    source_trip_type:
        value: 'source_trip_type'
        datatype: 'FLOAT4'
        src_cols_required: source_trip_type
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
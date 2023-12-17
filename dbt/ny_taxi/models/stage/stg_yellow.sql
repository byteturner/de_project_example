{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model:
    yellow_raw: 'yellow'
include_source_columns: false
ldts: 'load_dttm'
rsrc: '!yellow_taxi_raw_data'
hashed_columns:
    hk_service_type_h:
        - service_type
    hk_provider_h:
        - vendorid
    hk_pickup_location_id_h:
        - pulocationid
    hk_dropoff_location_id_h:
        - dolocationid
    hk_rate_code_id_h:
        - ratecodeid
    hk_payment_type_id_h:
        - payment_type
    hk_trip_h:
        - service_type
        - vendorid
        - pulocationid
        - dolocationid
        - source_file
        - file_row_number
    hd_trip_s:
        is_hashdiff: true
        columns:
            - passenger_count
            - trip_distance
            - store_and_fwd_flag
            - fare_amount
            - extra
            - mta_tax
            - tip_amount
            - tolls_amount
            - total_amount
            - congestion_surcharge
            - airport_fee
    hk_trip_pickup_location_l:
        - service_type
        - vendorid
        - pulocationid
        - dolocationid
        - source_file
        - file_row_number
        - pulocationid
    hk_trip_dropoff_location_l:
        - service_type
        - vendorid
        - pulocationid
        - dolocationid
        - source_file
        - file_row_number
        - dolocationid
    hk_trip_rate_code_l:
        - service_type
        - vendorid
        - pulocationid
        - dolocationid
        - source_file
        - file_row_number
        - ratecodeid
    hk_trip_payment_type_l:
        - service_type
        - vendorid
        - pulocationid
        - dolocationid
        - source_file
        - file_row_number
        - payment_type
derived_columns:
    service_type:
        value: '!yellow'
        datatype: 'STRING'
    pickup_ts:
        value: 'TO_TIMESTAMP_NTZ(tpep_pickup_datetime)'
        datatype: 'TIMESTAMP_NTZ'
        src_cols_required: tpep_pickup_datetime
    dropoff_ts:
        value: 'TO_TIMESTAMP_NTZ(tpep_dropoff_datetime)'
        datatype: 'TIMESTAMP_NTZ'
        src_cols_required: tpep_dropoff_datetime
    source_provider_id:
        value: 'vendorid'
        datatype: 'NUMBER'
        src_cols_required: vendorid
    source_pickup_location_id:
        value: 'COALESCE(pulocationid, -1)'
        datatype: 'NUMBER'
        src_cols_required: pulocationid
    source_dropoff_location_id:
        value: 'COALESCE(dolocationid, -1)'
        datatype: 'NUMBER'
        src_cols_required: dolocationid
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
    source_airport_fee:
        value: 'airport_fee'
        datatype: 'FLOAT4'
        src_cols_required: airport_fee
    source_dl_file:
        value: 'source_file'
        datatype: 'STRING'
        src_cols_required: source_file
    source_file_row_number:
        value: 'file_row_number'
        datatype: 'NUMBER'
        src_cols_required: file_row_number
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
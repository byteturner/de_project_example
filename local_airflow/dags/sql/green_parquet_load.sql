COPY INTO taxi_db.raw_data.{{ params.service }}
FROM (
    SELECT
        $1:VendorID::number
        ,$1:lpep_pickup_datetime::varchar
        ,$1:lpep_dropoff_datetime::varchar
        ,$1:store_and_fwd_flag::varchar
        ,$1:RatecodeID::number
        ,$1:PULocationID::number
        ,$1:DOLocationID::number
        ,$1:passenger_count::number
        ,$1:trip_distance::float4
        ,$1:fare_amount::float4
        ,$1:extra::float4
        ,$1:mta_tax::float4
        ,$1:tip_amount::float4
        ,$1:tolls_amount::float4
        ,$1:ehail_fee::varchar
        ,$1:improvement_surcharge::float4
        ,$1:total_amount::float4
        ,$1:payment_type::number
        ,$1:trip_type::number
        ,$1:congestion_surcharge::float4
        ,METADATA$FILENAME
        ,METADATA$FILE_ROW_NUMBER
        ,SYSDATE()
    FROM @manage_db.external_stages.taxi_path/{{ params.service }}/{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}/{{ params.service }}_{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}_monthly_data.{{ params.file_format }}
);


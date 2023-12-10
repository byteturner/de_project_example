COPY INTO taxi_db.raw_data.{{ params.service }}
FROM (
    SELECT
        $1:dispatching_base_num::varchar
        ,$1:pickup_datetime::varchar
        ,$1:dropOff_datetime::varchar
        ,$1:PUlocationID::number
        ,$1:DOlocationID::number
        ,$1:SR_Flag::varchar
        ,$1:Affiliated_base_number::varchar
        ,METADATA$FILENAME
        ,METADATA$FILE_ROW_NUMBER
        ,SYSDATE()
    FROM @manage_db.external_stages.taxi_path/{{ params.service }}/{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}/{{ params.service }}_{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}_monthly_data.{{ params.file_format }}
);
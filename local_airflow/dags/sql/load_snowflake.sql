CREATE TEMP TABLE taxi_db.raw_data.tmp_{{ params.service }}_{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}_monthly_data LIKE taxi_db.raw_data.{{ params.service }};

ALTER TABLE taxi_db.raw_data.tmp_{{ params.service }}_{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}_monthly_data DROP COLUMN load_dttm;

COPY INTO taxi_db.raw_data.tmp_{{ params.service }}_{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}_monthly_data
FROM @manage_db.external_stages.taxi_path/{{ params.service }}/{{ macros.ds_format(ds, '%Y-%m-%d', '%Y-%m') }}/{{ params.service }}_{{ macros.ds_format(ds, '%Y-%m-%d', '%Y-%m') }}_monthly_data.{{ params.file_format }}
MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;

INSERT INTO taxi_db.raw_data.{{ params.service }}
SELECT
    *
    , CURRENT_TIMESTAMP()
FROM taxi_db.raw_data.tmp_{{ params.service }}_{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}_monthly_data;

DROP TABLE taxi_db.raw_data.tmp_{{ params.service }}_{{ macros.ds_format(ds, '%Y-%m-%d', '%Y_%m') }}_monthly_data;
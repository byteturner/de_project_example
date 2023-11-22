from datetime import datetime
import requests
import os
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.amazon.aws.transfers.local_to_s3 import LocalFilesystemToS3Operator

from constants import (
    BUCKET_NAME,
    SERVICES,
    WEB_URL,
    FILE_FORMAT,
    LOCAL_PATH
)


def download_data(execution_date, web_url, service_name, file_format, local_path):
    filedate = execution_date.strftime("_tripdata_%Y-%m.")
    webfilepath = f"{web_url}{service_name}{filedate}{file_format}"
    localfilepath = f"{local_path}{service_name}{filedate}{file_format}"

    response = requests.get(webfilepath)
    if response.status_code == 200:
        with open(localfilepath, 'wb') as file:
            file.write(response.content)

        print(f"File {webfilepath} was successfully downloaded.")
        return f"{localfilepath}"
    else:
        print(f"Error to download file {webfilepath}. Error: ", response.status_code)
        return None


def delete_data(execution_date, local_path, service_name, file_format):
    filedate = execution_date.strftime("_tripdata_%Y-%m.")
    localfilepath = f"{local_path}{service_name}{filedate}{file_format}"
    try:
        os.remove(f"{localfilepath}")
        print(f"File {localfilepath} deleted.")
        return True
    except Exception:
        print(Exception)
        return False


default_args = {
    "depends_on_past": True,
    "retries": 0,

}

with DAG(
        dag_id="web_to_s3",
        start_date=datetime(2023, 1, 1),
        schedule_interval="@monthly",
        catchup=True,
        max_active_runs=1,
        is_paused_upon_creation=True,
) as dag:
    for service in SERVICES:
        download_file = PythonOperator(
            task_id=f'download_{service}_file',
            python_callable=download_data,
            op_kwargs={
                'web_url': WEB_URL,
                'service_name': service,
                'file_format': FILE_FORMAT,
                'local_path': LOCAL_PATH
            },
            provide_context=True
        )
        load_to_s3 = LocalFilesystemToS3Operator(
            task_id=f"{service}_taxi_data_to_raw_datalake",
            filename=f"{LOCAL_PATH}{service}_tripdata_"
                     f"{{{{ macros.ds_format(ds, '%Y-%m-%d', '%Y-%m') }}}}.{FILE_FORMAT}",
            dest_bucket=BUCKET_NAME,
            dest_key=f"ny_taxi/{service}/{{{{ macros.ds_format(ds, '%Y-%m-%d', '%Y-%m') }}}}/"
                     f"{service}_{{{{ macros.ds_format(ds, '%Y-%m-%d', '%Y-%m') }}}}"
                     f"_monthly_data.{FILE_FORMAT}",
            replace=True,
            aws_conn_id="aws",
            encrypt=True,
        )
        delete_file = PythonOperator(
            task_id=f'delete_{service}_file',
            python_callable=delete_data,
            op_kwargs={
                'service_name': service,
                'file_format': FILE_FORMAT,
                'local_path': LOCAL_PATH
            },
            provide_context=True
        )
        download_file >> load_to_s3 >> delete_file
FROM apache/airflow:2.7.3
#USER root
#COPY ./dags /opt/airflow/dags
USER airflow
RUN pip install 'boto3' 'requests' 'apache-airflow[aws]'  \
    'apache-airflow-providers-amazon'  \
    'apache-airflow-providers-google==10.1.0'  \
    'apache-airflow-providers-snowflake'

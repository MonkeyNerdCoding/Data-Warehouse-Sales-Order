FROM fishtownanalytics/dbt:1.0.0

WORKDIR /usr/app

# Sao chép dự án vào container
COPY dw_project/ .

# Cài đặt các gói phụ thuộc
RUN pip install --upgrade pip && \
    pip install dbt-bigquery
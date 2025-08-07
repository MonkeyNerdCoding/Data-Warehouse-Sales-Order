FROM ghcr.io/dbt-labs/dbt-bigquery:1.7.6

# Cài git nếu dùng dbt deps từ git repo
RUN apt-get update && apt-get install -y git

# Đặt thư mục làm việc
WORKDIR /usr/app

# Copy toàn bộ dự án dbt
COPY ./dw_project/ ./

# Copy profile cấu hình vào đúng nơi dbt dùng
COPY profiles/profiles.yml /root/.dbt/profiles.yml


# Copy service account key
COPY ./dw_project/gcp-key.json /usr/app/gcp-key.json

# Cài dependencies (nếu có trong packages.yml)
RUN dbt deps

CMD ["bash"]

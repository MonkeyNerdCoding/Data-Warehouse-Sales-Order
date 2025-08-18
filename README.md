# Data-Warehouse-Sales-Order

## 🔐 Chuẩn bị cấu hình BigQuery

1. Vào Google Cloud Console → IAM & Admin → Service Accounts → tạo key mới định dạng `JSON`.
2. Tải file về và lưu vào `profiles/credentials.json`
3. Tạo file `profiles/profiles.yml` như sau:

dw_project:
  outputs:
    dev:
      dataset: dw_sales_order_project
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: /usr/app/gcp-key.json
      location: asia-southeast1  
      method: service-account
      priority: interactive
      project: learn-dbt-465312
      threads: 4
      type: bigquery
  target: dev


  ## 🐳 Chạy project với Docker
1. **docker-compose build**
2. **docker-compose run --rm dbt run --select (Choose model you want)**
3. **docker-compose exec dbt bash (When you wanna run in the container)**




## Setup Instructions WITHOUT DOCKER
1. **Activate Virtual Environment**:  
   - Create a virtual environment by running `python -m venv .venv` in the `dw_project` directory (if `.venv` is not already present).  
   - Activate the virtual environment with `.\.venv\Scripts\Activate.ps1`.  
   - **Note**: If pushing to GitHub, remove the `.venv` folder.

2. **Initialize dbt Project**:  
   - Run `dbt init dw_project` to set up the project.

3. **Configure Profiles**:  
   - The default `profiles.yml` file is located at `C:\Users\ADmin\.dbt\profiles.yml`.  
   - Move the `profiles.yml` file into the `dw_project` directory.  
   - Set the environment variable for the profile directory by running `$env:DBT_PROFILES_DIR = "."`.

4. **Run dbt Commands**:  
   - Execute `dbt run --select` to run the models.  
   - Run `dbt test` to perform tests.  
   - Use `dbt debug` to debug the setup.

5. **Khởi tạo project**:
-  `dbt init dw_project`
---


## Nếu chạy ngoài net 
1. Install python (Remember to add python to path) 
2. Install pip in dockerfile 
3. Install python -m .venv venv 
4. Open powersell run this : Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser 
5. Add json key to .venv folder (sài lại key cũ ở nhà cũng được)


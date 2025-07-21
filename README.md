# Data-Warehouse-Sales-Order

## Setup Instructions

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

---
WITH dim_person AS (
    SELECT
    CAST(person_id AS INT) AS person_key,
    CAST(full_name AS STRING) AS full_name,
    CAST(preferred_name AS STRING) AS preferred_name,
    CAST(search_name AS STRING) AS search_name,
    CAST(is_permitted_to_logon AS BOOLEAN) AS is_permitted_to_logon, 
    CAST(is_external_logon_provider AS BOOLEAN) AS is_external_logon_provider, 
    CAST(is_system_user AS BOOLEAN) AS is_system_user,
    CAST(is_employee AS BOOLEAN) AS is_employee,
    CAST(is_salesperson AS BOOLEAN) AS is_salesperson
    FROM `vit-lam-data.wide_world_importers.application__people`
), dim_person_boolean_converted AS (
    SELECT
    person_key,
    full_name,
    preferred_name,
    search_name,
    CASE 
        WHEN is_permitted_to_logon IS TRUE THEN "Permitted to logon"
        WHEN is_permitted_to_logon IS FALSE THEN "Not permitted to logon"
        ELSE "Undefined"
    END AS is_permitted_to_logon,
    CASE 
        WHEN is_external_logon_provider IS TRUE THEN "External logon provider"
        WHEN is_external_logon_provider IS FALSE THEN "Not external logon provider"
        ELSE "Undefined"
    END AS is_external_logon_provider,
    CASE 
        WHEN is_system_user IS TRUE THEN "System user"
        WHEN is_system_user IS FALSE THEN "Not system user"
        ELSE "Undefined"
    END AS is_system_user,
    CASE 
        WHEN is_employee IS TRUE THEN "Employee"
        WHEN is_employee IS FALSE THEN "Not employee"
        ELSE "Undefined"
    END AS is_employee,
    CASE 
        WHEN is_salesperson IS TRUE THEN "Salesperson"
        WHEN is_salesperson IS FALSE THEN "Not salesperson"
        ELSE "Undefined"
    END AS is_salesperson,
    FROM dim_person
), dim_person_final AS (
    SELECT
    COALESCE(person_key,0) AS person_key,
    COALESCE(full_name,"Undefined") AS full_name,
    COALESCE(preferred_name,"Undefined") AS preferred_name,
    COALESCE(search_name,"Undefined") AS search_name,
    COALESCE(is_permitted_to_logon,"Undefined") AS is_permitted_to_logon,
    COALESCE(is_external_logon_provider,"Undefined") AS is_external_logon_provider,
    COALESCE(is_system_user,"Undefined") AS is_system_user,
    COALESCE(is_employee,"Undefined") AS is_employee,
    COALESCE(is_salesperson,"Undefined") AS is_salesperson
    FROM dim_person_boolean_converted

    UNION ALL 
    SELECT 
    0 AS person_key,
    "Undefined" AS full_name,
    "Undefined" AS preferred_name,
    "Undefined" AS search_name,
    "Undefined" AS is_permitted_to_logon,
    "Undefined" AS is_external_logon_provider,
    "Undefined" AS is_system_user,
    "Undefined" AS is_employee,
    "Undefined" AS is_salesperson

    UNION ALL 
    SELECT 
    - 1 AS person_key, 
    "ERROR" AS full_name,
    "ERROR" AS preferred_name,
    "ERROR" AS search_name,
    "ERROR" AS is_permitted_to_logon,
    "ERROR" AS is_external_logon_provider,
    "ERROR" AS is_system_user,
    "ERROR" AS is_employee,
    "ERROR" AS is_salesperson
)

SELECT * 
FROM dim_person_final
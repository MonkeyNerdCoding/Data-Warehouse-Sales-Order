SELECT 
    person_key AS employee_key,
    full_name AS employee_full_name,
    search_name AS employee_search_name,
    is_employee
FROM {{ ref('dim_person') }}
WHERE is_employee = 'Employee' OR person_key IN (0,-1)
-- lọc ra chỉ toàn employee và đảm bảo lấy 2 cột undefined và error 


-- Vì trong fact_sale_order_line có 2 trường là is_sale_person và is_employee, 2 thằng này đều lấy từ dim_person (person_key)
-- Nên khi lọc qua power bi, nó sẽ bị loạn nên mình phải tách ra 2 bảng nhỏ nữa là dim_saleperson_person và dim_employee_person
-- dim_saleperson_person sẽ chỉ chứa các nhân viên bán hàng
-- dim_employee_person sẽ chỉ chứa các nhân viên nhân sự
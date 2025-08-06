SELECT 
    person_key AS picked_by_person_key,
    full_name AS picked_by_full_name,
    search_name AS picked_by_search_name,
    is_employee
FROM {{ ref('dim_person') }}
WHERE is_employee = 'Employee' OR person_key IN (0,-1)
-- lọc ra chỉ toàn employee và đảm bảo lấy 2 cột undefined và error 


-- Vì trong fact_sale_order_line có 3 trường là picked_by_person_key,sale_person_key và contact_person_key, 3 thằng này đều lấy từ dim_person (person_key)
-- Nên khi lọc qua power bi, nó sẽ bị loạn nên mình phải tách ra 2 bảng nhỏ nữa là dim_saleperson_person và dim_contact_person hay dim_picked_by_person

-- dim_picked_by_person sẽ chỉ chứa các nhân viên bán hàng và nhân viên nhân sự
-- dim_contact_person sẽ chỉ chứa các khách hàng
-- dim_sale_person sẽ chỉ chứa các nhân viên bán hàng


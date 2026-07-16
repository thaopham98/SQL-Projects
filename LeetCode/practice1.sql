USE BikeStores;

-- --Check for existing tables in the database
-- -- Tables only (user tables)
-- SELECT name
-- FROM sys.tables
-- ORDER BY name;

-- -- Include schema + tables (user tables)
-- SELECT s.name AS schema_name, t.name AS table_name
-- FROM sys.tables t
-- JOIN sys.schemas s ON s.schema_id = t.schema_id
-- ORDER BY s.name, t.name;



select 
    first_name + ' ' + last_name AS "Manager Name"
from sales.staffs
GROUP by manager_id
having count(manager_id) >= 2;

SELECT 
    staff_id, 
    first_name, 
    last_name, 
    manager_id
FROM sales.staffs;

select 
    distinct m.first_name + ' ' + m.last_name AS "Manager Name"
from sales.staffs e
join sales.staffs m on e.manager_id = m.staff_id
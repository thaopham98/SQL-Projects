/*
3. Create a function that when passed productid, return the total quantity that the product was 
ordered.
a. Use the function in a SELECT to return the product names and the quantity they 
were ordered.
*/
GO
CREATE FUNCTION P2Q3 (@productid int)
RETURNS int
BEGIN
RETURN (SELECT SUM(quantity)
		FROM [sales].[order_items]
		WHERE product_id=@productid)
END
--------------------
GO
PRINT dbo.P2Q3(20)
--
SELECT 
	product_name, 
	product_id, 
	dbo.P2Q3(product_id) AS 'Quantity ordered'
FROM [production].[products]
ORDER BY 'Quantity ordered' DESC
---
--use the function to return the products that haven't been ordered it
SELECT product_name--, dbo.P2Q3(product_id) AS 'Quantity ordered'
FROM [production].[products]
WHERE dbo.P2Q3(product_id) IS NULL
--
SELECT product_name
FROM [production].[products] P 
LEFT JOIN [sales].[order_items] OI ON P.product_id=OI.product_id
WHERE order_id IS NULL 

--use the function to return how many products haven't been ordered it 
SELECT COUNT(product_name) 'count of products not ordered'--, dbo.P2Q3(product_id) AS 'Quantity ordered'
FROM [production].[products]
WHERE dbo.P2Q3(product_id) IS NULL

/*
4. Create a function that when passed a storied returns the name of person that manages the most people.
a. Use the function in a SELECT query to return all the stores and the number of mangers in each store
*/
GO
drop function if EXISTS P2q4;
GO
CREATE or ALTER FUNCTION P2q4 (@storeid int)
RETURNS varchar(50)
-- TABLE
--AS
begin
	RETURN 
	(
		SELECT 
			top 1 Manager.first_name + ' ' + Manager.last_name AS 'Manager Name'
	-- , 		staff.store_id
	--, COUNT(*) AS 'Count of staff'
		FROM [sales].[staffs] staff 
		JOIN [sales].[staffs] Manager ON staff.manager_id=manager.staff_id
		WHERE staff.store_id=@storeid
		GROUP BY Manager.first_name, Manager.last_name, staff.store_id
		-- HAVING COUNT(*) = 
							-- (
							-- 	SELECT TOP 1 COUNT(*) 
							-- 	FROM [sales].[staffs]
							-- 	WHERE store_id=@storeid
							-- 	GROUP BY manager_id,store_id
							-- 	ORDER BY COUNT(*) DESC 
							-- )
	)
end

GO
/* Calling the function that return VARCHAR */
select store_name, dbo.P2q4(store_id) [Manager Name] from sales.stores;

select distinct store_name, store_id from sales.stores;

/*	return the store name and its manager*/
SELECT 
    TOP 1 
    m.first_name + ' ' + m.last_name AS ManagerName,  -- Full name of the manager
    s.store_name  -- Store name
FROM sales.stores s
JOIN sales.staffs e ON s.store_id = e.store_id  -- Join stores with employees
JOIN sales.staffs m ON e.manager_id = m.staff_id  -- Join to find the manager for each employee
WHERE s.store_id = 3  -- Replace with the desired store_id or parameterize it
GROUP BY m.first_name, m.last_name, s.store_name  -- Group by manager and store name
ORDER BY COUNT(e.staff_id) DESC  -- Order by number of staff under each manager in descending order


------------------------

/* Calling the function that return TABLE */
SELECT *--store_name, [Manager Name]
FROM [sales].[stores] store CROSS APPLY dbo.P2q4 (store_id); -- there's an error message bc P2q4 use here was returns table and not int

SELECT * FROM dbo.P2q4(1);

SELECT *
FROM [sales].[stores]

--
SELECT *
FROM [sales].[stores] store JOIN dbo.P2q4(1) Q4 ON store.store_id=Q4.store_id



---
SELECT Manager.first_name + ' '+Manager.last_name AS 'Manager Name', staff.store_id, COUNT(*)
FROM [sales].[staffs] staff JOIN [sales].[staffs] Manager ON staff.manager_id=manager.staff_id
WHERE staff.store_id=1
GROUP BY Manager.first_name,Manager.last_name,staff.store_id
HAVING COUNT(*) = (SELECT TOP 1 COUNT(*) 
					FROM [sales].[staffs]
					WHERE store_id=1
					GROUP BY manager_id,store_id
					ORDER BY COUNT(*) DESC )
ORDER BY staff.store_id

/*
Manger name		storeid	 number of people being managed 
Fabiola Jackson	1					2
Mireya Copeland	1					2
Fabiola Jackson	2					1
Jannette David	2					3
Fabiola Jackson	3					1
Venita Daniel	3					4

*/
--
SELECT TOP 1 COUNT(*) 
FROM [sales].[staffs]
WHERE store_id=2
GROUP BY manager_id,store_id
ORDER BY COUNT(*) DESC 


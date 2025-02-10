-- use BikeStores;

/* q1 */
GO
CREATE OR ALTER PROC q1
    @letter VARCHAR(1)
AS
    /* Handling Errors and Messages */

    SELECT 
        -- *
        brand_name,
        COUNT(DISTINCT p.product_id) 'Number of Products', -- w/out DISTINCT, it will count the same product_id that also in other stores
        COUNT(DISTINCT store_id) 'Number of stores carrying the brand' -- the same w/ this one
    FROM production.brands b 
    JOIN production.products p 
        ON p.brand_id=b.brand_id
    JOIN production.stocks s 
        ON s.product_id = p.product_id

    WHERE brand_name LIKE '[' + @letter + ']%'
    GROUP BY brand_name;

GO
EXEC q1 's'

/* q2 */


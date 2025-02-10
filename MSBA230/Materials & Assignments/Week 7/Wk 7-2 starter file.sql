USE MyGuitarShop;

-- Change the discount percent of category 3 products to 50


-- Change the empty line2 cells in Addresses table to 'NA'

-- Create a table called "ShippedItems" and store all orders that were shipped
select * into ShippedItems
from Orders 
where ShipDate is not null;
-- Drop Table ShippedItems;


-- Add a new item to the products table. (check which columns can be null)
select * from products 
insert into Products 
values (1,'T', 'Test','dssdfs', 200, 0, GETDATE())

-- Delete all the products in category 2

-- Delete the Administrators table



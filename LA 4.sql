-- LAB ASSIGNMENT 4
SELECT account_description, 
COUNT(*) AS line_item_count, 
SUM(line_item_amount) AS line_item_amount_sum
FROM general_ledger_accounts gl 
JOIN invoice_line_items li
ON gl.account_number = li.account_number
GROUP BY gl.account_description
HAVING line_item_count > 1
ORDER BY line_item_amount_sum DESC;

SELECT account_number, SUM(line_item_amount) AS line_item_sum
FROM invoice_line_items
GROUP BY account_number WITH ROLLUP;
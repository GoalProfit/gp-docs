# SQL Query Analyzer

This page allows you to query data using SQL style syntax.

## Notes

Use _Ctrl+Enter_ or _Command+Enter_ keyboard shortcuts to run the query.

Query without `GROUP BY` section assumes aggregation to one record.

Use `SUM(1)` instead of `COUNT(*)` to compute number of records.

Use `*` instead of `%` in `LIKE` operation.

The `JOIN` operation returns each record from the left table (table1) and the corresponding _ONE_ record from the right table (table2), if available; otherwise, it returns null for the right table record.

The `FULL JOIN` operation returns all records from both the left (table1) and the right (table2) tables when the join condition is met. It combines all possible combinations of records from both tables.

To set variables, use the syntax `SET @variable = value`. Once defined, these variables can be referenced as `@variable` within your queries.

Use `SET @cores = <number>` to adjust number of CPU cores that will be used to run the query.

The following aggregation functions are available:
* `ALL` – returns true if condition is true for all records
* `ANY` – returns true if condition is true for at least one record
* `SUM` – computes sum
* `AVG` – computes average
* `MEAN` – alias for `AVG`
* `MIN` – returns minimum value
* `MAX` – returns maximum value

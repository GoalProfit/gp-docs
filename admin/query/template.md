# SQL Query Analyzer

This page allows you to query data using SQL style syntax.

## Notes & Tips

Use _Ctrl+Enter_ or _Command+Enter_ keyboard shortcuts to run the query.

Query without `GROUP BY` section assumes aggregation to one record.

Use `sum(1)` instead of `count(*)` to compute number of records.

Use `*` instead of `%` in `like` operation.

The `join` operation returns each record from the left table (table1) and the corresponding _ONE_ record from the right table (table2), if available; otherwise, it returns null for the right table record.

The `full join` operation returns all records from both the left (table1) and the right (table2) tables when the join condition is met. It combines all possible combinations of records from both tables.

To set variables, use the syntax `set @variable = value`. Once defined, these variables can be referenced as `@variable` within your queries.

Use `set @cores = <number>` to adjust number of CPU cores that will be used to run the query.

### Aggregation Functions
* `all` – returns true if condition is true for all records
* `any` – returns true if condition is true for at least one record
* `sum` – computes sum
* `avg` – computes average
* `mean` – alias for `avg`
* `min` – returns minimum value
* `max` – returns maximum value
* `first(a,b)` – returns `a` where `b` is equal to `min(b)`
* `last(a,b)` – returns `a` where `b` is equal to `max(b)`

### Computation Functions
* `floor(a)`
* `ceil(a)`
* `round(a)`
* `round(a,b)`
* `log(a)`
* `exp(a)`
* `htmlescape(a)`
* `trim(a)`
* `upper(a)`
* `lower(a)`
* `isnull(a,b)`
* `isempty(a,b)`
* `a like b`
* `a find b`
* `a =~ b`
* `a !~ b`
* `a := b`
* `search(a,b)`
* `snippet(a,b,c)`
* `cast(a,b)`
* `jq(a,b)`
* `jq(a,b,c)`
* `jql(a,b)`
* `handlebars(a)`
* `handlebars(a,b)`
* `report(a,b)`
* `subst(a,b,c)`
* `date(a,b,c)`
* `time(a,b,c)`
* `slice(a,b,c)`
* `datetime(a)`
* `datetime(a,b)`
* `join(a,b)`
* `take(a,b)`
* `skip(a,b)`
* `prefix(a,b)`
* `a if b`
* `a if b else c`
* `a in b`
* `a not in b`
* `now`
* `today`
* `a.date`
* `a.time`
* `b.year`
* `b.month`
* `b.day`
* `b.weekday`
* `c.hour`
* `c.minute`
* `c.second`

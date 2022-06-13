# Report config

[Admin UI](/admin#/dataset/reports)

The system supports storing reports referenceable by a report name.
For additional infomration about reports query syntax please see [query syntax description and examples](/pages/docs/graphql/).


* `name: string` - report name.
* `cores: integer` is the number of cores used to build the report. The default is 1.
* `vars: object` - report variables. Is an object whose keys are variable names and whose values are default variable values. The default is null (no variables).
* `source: symbol` – Data source can be a stream or a report.
* `filter0: filter` – Indexed filter in the map-reduce pipeline.
  This filter performs a coarse selection of source chunks to keep only chunks that have requested data.
  As this filter operates at chunk level, `filter1` or `filter2` are required for the fine-grained filtering.
* `filter1: filter` – Indexed filter in the map-reduce pipeline.
  This filter performs an efficient indexed lookup for desired rows within each source chunk that passed `filter0`.
* `filter2: expression` – Generic filter in the map-reduce pipeline.
  This filter is applied to each row that passes indexed `filter0` and `filter1`.
  This filter supports a wide range of operations allowed by the `expression` type.
* `filter3: expression` – Generic filter in the map-reduce pipeline.
  This filter is applied to every row in the resulting report.
* `dims: formulas` – The list of formulas used for the group by operation in the map-reduce pipeline.
* `vals: formulas` – The list of formulas used for aggregation operations in the map-reduce pipeline.
* `cols: formulas` – The optional list of formulas used to compute additional values after the map-reduce pipeline is complete. `cols` are defaulted to `dims + vals` if not set.
* `sort : [integer]` – Indexes of columns to sort resulting rows
* `indexes: integer[]` - indexing of columns so that this report can be used as a source for another report with the possibility of strong filtering and aggregation. The column index is defined as in `sort`.
* `expand: string[]` is a list of `source` links. By default, a link with another source selects one row from the linked source that corresponds to the splits. If the link is specified in expand, then all lines of this link with this partition are linked, and aggregate functions can be applied to them.
* `links: object[]` - Set up links to other streams and reports. The linked stream/report data is accessed through the linkName.field1 point. Advertised links cannot be used in the current report, but can be used in other streams/reports that use this one. Is an array of objects:
  - `linkName: string` - link name
  - `sourceName: string` - name of the stream or report to be linked
  - `columnPairs: object[]` - a list of columns on which to link. Is an array of objects:
    - `srcColumn: string` - column in the current stream
    - `dstColumn: string` - link stream/report column
* `funcs: object[]` - computed columns. Is an array of objects:
  - `name: string` - column name
  - `calc: string` - the formula by which the column value is calculated
  - `args: string[]` - arguments of the function
* `expire: double` - report lifetime in seconds.
* `stored*: bool` - the report is stored.
* `description: string` - report description.

<style>
.my-dark-theme .my-content {
    color: var(--light)
}
.my-dark-theme .my-content h1,
.my-dark-theme .my-content h2,
.my-dark-theme .my-content h3,
.my-dark-theme .my-content h4,
.my-dark-theme .my-content h5 {
    color: white;
}
.my-content b,i,em {
    color: rgb(88,167,202);
}
code { white-space: pre; }
</style>

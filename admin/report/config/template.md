# Report config

[Admin UI](/admin#/dataset/reports)

*name*: string - report name.

*cores*: int32 is the number of cores used to build the report. The default is 1.

*filter0*: string - zero-level filter on *source* data. The fastest but most syntax-limited filter. The default is null (no filtering).

*filter1*: string - filter only on indexed columns of the source *source*. Second fastest filter. Syntax constraints are the same as *filter0*. The default is null (no filtering).

*filter2*: string - filter on all columns of the source *source*. The slowest filter, but has extended syntax. The default is null (no filtering).

*filter3*: string - filter based on the report data built. Allows you to filter already aggregated data. The default is null (no filtering).

*vars*: object - report variables. Is an object whose keys are variable names and whose values are default variable values. The default is null (no variables).

*dims*: string - the list of indexed columns of the *source* source for which aggregation is required. The pins are listed by commas. Required to fill in.

*vals*: string - report columns calculated through the aggregation functions (sum, avg, min, max...) of the *source* data. Columns are listed by commas. The default is null (no columns).

*cols*: string - columns calculated after aggregation through *dims* and *vals*. It is also used to change the order of output of columns from *dims* and *vals*. By default, null (there are no columns, they are formed based on *dims* and *vals*).

*sort*: int64[] - Sort the report lines by column with the specified indexes. Index numbering begins with 1. Sorting is done in ascending order. You must use a negative column index to sort in descending order. If *cols* is not specified, then the numbering is end-to-end in the order in which the columns are declared in *dims* and *vals*. If *cols* is specified, the numbering matches the order of the columns in *cols*.

*source*: string - The name of the data source for the report. It can be a stream or a report. Default is "default."

*indexes*: uint64[] - indexing of columns so that this report can be used as a source for another report with the possibility of strong filtering and aggregation. The column index is defined as in *sort*.

*expand*: string[] is a list of *source* links. By default, a link with another source selects one row from the linked source that corresponds to the splits. If the link is specified in expand, then all lines of this link with this partition are linked, and aggregate functions can be applied to them.

*links*: object[] - Set up links to other streams and reports. The linked stream/report data is accessed through the linkName.field1 point. Advertised links cannot be used in the current report, but can be used in other streams/reports that use this one. Is an array of objects:
- *linkName*: string - link name
- *sourceName*: string - name of the stream or report to be linked
- *columnPairs*: object[] - a list of columns on which to link. Is an array of objects:
-- *srcColumn*: string - column in the current stream
-- *dstColumn*: string - link stream/report column

*funcs*: object[] - computed columns. Is an array of objects:
- *name*: string - column name
- *calc*: string - the formula by which the column value is calculated
- *args*: string[] - arguments of the function???

*module*: string - deprecated.

*engine*: string - deprecated.

*config*: string - deprecated.

*expand*: double - report lifetime in seconds.

*stored*: bool - the report is stored.

*description*: string - report description.

[Field syntax description and query examples here](/pages/docs/graphql/)

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

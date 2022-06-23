# GraphQL

The system provides GraphQL API as the primary API endpoint.

See [GraphiQL](/graphiql) console for the supported queries and mutations.
See [Data Model](../datamodel/) for additoinal information about data formats.
See [Sample Queries](samples/) for working GraphQL samples.
See [Syntax Grammar](../grammar/) for the complete list of supported types and operations.

The system provides SQL-like syntax to query data controlled by the following parameters.

* *source*: symbol – Data source can be a stream or a report.
* *filter0*: filter – Indexed filter in the map-reduce pipeline.
  This filter performs a coarse selection of source chunks to keep only chunks that have requested data.
  As this filter operates at chunk level, *filter1* or *filter2* are required for the fine-grained filtering.
* *filter1*: filter – Indexed filter in the map-reduce pipeline.
  This filter performs an efficient indexed lookup for desired rows within each source chunk that passed *filter0*.
* *filter2*: expression – Generic filter in the map-reduce pipeline.
  This filter is applied to each row that passes indexed *filter0* and *filter1*.
  This filter supports a wide range of operations allowed by the expression type.
* *filter3*: expression – Generic filter in the map-reduce pipeline.
  This filter is applied to every row in the resulting report.
* *dims*: formulas – The list of formulas used for the group by operation in the map-reduce pipeline.
* *vals*: formulas – The list of formulas used for aggregation operations in the map-reduce pipeline.
* *cols*: formulas – The optional list of formulas used to compute additional values after the map-reduce pipeline is complete. *cols* are defaulted to *dims* + *vals* if not set.
* *sort*: [integer] – Indexes of columns to sort resulting rows

The SQL mnemonic for the query syntax is the following:

> ```
> SELECT cols FROM (
>   SELECT dims, vals
>   FROM source
>   WHERE filter0 AND filter1 AND filter2
>   GROUP BY dims
>   HAVING filter3
> )
> SORT BY sort
> ```

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

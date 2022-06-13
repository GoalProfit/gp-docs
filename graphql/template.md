# GraphQL

The systme provides GraphQL API as the primary API endpoint. Please see [GraphiQL](/graphiql) console for the list of supported queries and mutations. Please find [sample queries](samples/).

* `<filter0> : <filter>` – indexed filter in the map reduce pipline
* `<filter1> : <filter>` – indexed filter in the map reduce pipline
* `<filter2> : <expression>` – generic filter in the map reduce pipline
* `<filter3> : <expression>` – generic filter in the map reduce pipline
* `<dims> : <formulas>` – the list of formulas used for group by operation in the map reduce pipline   
* `<vals> : <formulas>` – the list of formulas used for agregation operations in the map reduce pipline
* `<cols> : <formulas>` – the list of foumlas used to compute additional values after the map reduce pipline is complete

Please see [The Complete Query Syntax Grammar](../grammar/).

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

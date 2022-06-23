# Data Model

* Low-level data representation: persistent structures
* High-level data representation: segmented streams
![Stream model](/pages/docs/GoalProfit%20stream.svg?v2)
* Preferred operation: adding new data
* Deletion and modification: mark "do not use" on old data + new version of data
* Point change strategy: operation log and rollup by key
* Data upload: pool + push
* Supported sources:
    * Flat files: rfc4180 CSV and dialects
    * Excel 2010 xlsx/xlsm via OpenPyXL
    * Arbitrary files via ad hoc converters
    * Relational data via ODBC converter
    * Kafka
    * Arbitrary sources via ad hoc connector
* Query language: SQL-like
* ODBC driver: under development
* Automatic correction of primary and derived data for supporting sources
* Hierarchical, incremental, stored, parameterizable reporting
* "Dereferencing" via stored links between streams/reports


<style>
.my-content img {
    margin: 10px 0;
    max-width: 100%;
}
.my-dark-theme .my-content img {
    filter: invert(100%);
}
</style>

# Sample GraphQL queries

Please find below the list of sample queries. You can use [GrapiQL](/graphiql) console to run these queries.


1. Selects the specified columns [Product_ID, Description] from the stream *items* sorted by *Product_ID*
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        streams {
          items {
            # return top 5 rows respecting current sort
            # ascendant sort by column Product_ID. 1 - is a 1-based index of column Product_ID in the query         
            report(dims: "Product_ID" vals: "Description" sort: [1]) {
              rows(take: 5) 
            }
          }
        }
      }
    }
    ```


2. The same query sorting results in the descendand order.
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        streams {
          items {
            # return top 5 rows respecting current sort
            # ascendant sort by column Product_ID. 1 - is a 1-based index of column Product_ID in the query         
            report(dims: "Product_ID" vals: "Description" sort: [-1]) {
              rows(take: 5) 
            }
          }
        }
      }
    }
    ```


3. Selects ten random rows from the stored report.
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        report(name: "assort_zones") {
          rows(sample: 10)
        }
      }
    }
    ```


4. Selects additional metadata from the stored report.
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        report(name: "assort_zones") {
          rows(sample: 10)
          columns {
            name
            type
            synonym
          }
          stats {
            processTime
            processRows
          }
        }
      }
    }
    ```

5. Selects data from stream with aggregation functions
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        streams {
          items {
            report(
              dims: "class"
              vals: "sum(1), min(Current_Price), max(Current_Price)"
            	sort: [-2])
            {
              rows
            }
          }
        }
      }
    }
    ```


6. Appends records to a stream. Mutation returns a list of identifiers for the added records. See the added records at https://lmg.goalprofit.com/admin#/dataset/streams/test/records
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    mutation {
      appendRecords(
        stream: "test"
        format: "csv"
        records: "abcd,12345"
        )
    }
    ```

6. Removes records from a stream.
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    mutation {
      removeRecords(
        stream: "test"
        ids: [0,1,2]
        )
    }
    ```

8. Selects information from linked streams
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        streams {
          items {
            report(
              dims: "item, class", 
              links: [{
                linkName: "classif"
                sourceName: "classif"
                columnPairs: [{
                  srcColumn: "class"
                  dstColumn: "class"
                }]
              }]) {
              report(
                dims: "classif.category"
                vals: "sum(1)"
                sort: [-2])
              {
                rows
              }
            }
          }
        }
      }
    }
    ```

<link rel="stylesheet"
      href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.5.1/styles/default.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.5.1/highlight.min.js"></script>
<style>
.my-content li > code {
  white-space: pre;
  color: var(--dark);
  line-height: 1.25;
  display: block;
  background: var(--light);
  padding: 5px;
}
.my-content a[onclick="setQuery(event)"] {
  float: right;
  margin-right: 10px;
  margin-top: 20px;
}
.my-content ul > li + li,
.my-content ol > li + li {
  margin-top: 10px;
}
</style>
<script>
window.setQuery = e => {
  localStorage["graphiql:query"] = e.target.parentNode.nextSibling.innerText
}
</script>
    

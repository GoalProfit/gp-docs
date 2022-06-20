# Sample GraphQL queries

Please find below the list of sample queries. You can use [GrapiQL](/graphiql) console to run these queries.


1. Select the specified columns [item, name] from the stream *items* sorted by *item*
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        streams {
          items {
            # return top 5 rows respecting current sort
            # ascendant sort by column item. 1 - is a 1-based index of column item in the query         
            report(dims: "item" vals: "name" sort: [1]) {
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
            # ascendant sort by column item. 1 - is a 1-based index of column item in the query         
            report(dims: "item" vals: "name" sort: [-1]) {
              rows(take: 5) 
            }
          }
        }
      }
    }
    ```


3. Select ten random rows from the stored report.
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


4. Select additional metadata from the stored report.
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

5. Select data from stream with aggregation functions
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        streams {
          competitors {
            report(
              dims: "item.class, competitor_name"
              vals: "sum(1), min(competitor_price), max(competitor_price)"
              sort: [-2])
            {
              rows(sample:10)
            }
          }
        }
      }
    }
    ```


6. Append records to a stream. Mutation returns a list of identifiers for the added records. See the added records at stream test [page](/admin#/dataset/streams/test/records).
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    mutation {
      appendRecords(
        stream: "test"
        format: "csv"
        records: "abcd,12345")
    }
    ```

6. Remove records from a stream.
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    mutation {
      removeRecords(
        stream: "test"
        ids: [0,1,2])
    }
    ```

8. Select information from linked stream
    <a href="/graphiql" target="_blank" onclick="setQuery(event)">try</a>
    ```
    query {
      dataset {
        streams {
          items {
            report(
              dims: "item, class"
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
    

# Sample GraphQL queries

Please find below the list of sample queries. You cane use [GrapiQL](/graphiql) console to run these queries.

<style>
.my-content code {
  white-space: pre;
}
.my-content ul > li + li,
.my-content ol > li + li {
  margin-top: 10px;
}
</style>

1. Simple query from stream – selects specified fields [*item*, *BRAND*, *COLOR*] from stream *items* without any grouping and filtering
    ```
    # comments started from symbol '#'
    query simple_query_from_stream {
      dataset {
        streams {
          items {
            # return top 5 rows respecting current sort
            # ascendant sort by column [item]. 3 - is a 1-based index of column [item] in stream, not in query         
            records(take: 5, sort: [3]) {
              rows {
                item
                BRAND
                COLOR
              }
            }
          }
        }
      }
    }
    ```


2. Simple query from stream with descendant sort order
    ```
    # comments atarted from symbol #
    query simple_query_from_stream_desc {
      dataset {
        streams {
          items {
            # Descendand sort for column [item]. For descendant sort order - negate column index should be used.  
            records(take: 5, sort: [-3]) {
              rows {
                item
                BRAND
                COLOR
              }
            }
          }
        }
      }
    }
    ```


3. Query all columns from a report
    ```
    query query_from_report {
      dataset {
        report(name: "model_category_last") {
          rows(sample: 10)
        }
      }
    }
    ```


4. Query from report with header description and additional statistics information
    ```
    query query_from_report_info {
      dataset {
        report(name: "model_category_last") {
          rows(sample: 10)
          columns {
            name
            type
          }
          stats {
            processTime
            processRows
          }
        }
      }
    }
    ```

5. Query from stream using grouping and filtering. Query *categoryid* and *category*, *status*, *date* corresponding  this category and maximum *create_time* value. Filter by *categoryid* applied.
    ```
    query query_from_stream_with_grouping {
      dataset {
        streams {
          model_category {
            report(dims: "categoryid", filter1: "categoryid in ['Obuwie']", vals: "last(category, create_time) as category,last(status, create_time),last(date, create_time)") {
              rows
            }
          }
        }
      }
    }
    
    ```


6. Remove records from stream.Available only for streams with *id* column. That column should be *docid* type
    ```
    mutation remove_records {
      removeRecords(stream: "model_category", ids: [24, 23])
    }
    ```


7. Append records into stream - list of lists with values for rows of columns should be specified
    ```
    mutation append_records {
      appendRecords(stream: "model_category", format: "json", records: "[[60, \"ATEST\", \"CATTEST\", \"pending\", \"2022-02-20\"]")
    }
    ```


8. Linking streams and using linked stream's column for filtering result
    ```
    query linking {
      dataset {
        streams {
          new_prices {
            report(
              dims: "item,price", 
              links: [{
                linkName: "item", 
                sourceName: "items", 
                columnPairs: [{srcColumn: "item", dstColumn: "item"}]}]) {
              report(
                dims: "item,item.COLOR,price", 
                filter2: "item.COLOR=='WHITE'") {
                rows
              }
            }
          }
        }
      }
    }
    ```
    
    

# Stream configuration

[Admin UI](/admin#/dataset/streams/items/config)

* *name*: string - stream name.

* *description*: string – stream description.

* *blockRows*: int32 – the number of bytes in the stream data block. Blocks are stored independently.

* *doubleEntry*: bool – the double record maintenance characteristic. Used for accounting.

* *columnOriented*: bool – sign of column data storage.

* *paused*: bool – if true, the stream is not automatically updated according to its spouts. Adding data manually through appendRecords continues to work.

* *compressed*: bool – if true, then the data is compressed by the LZ4 algorithm to reduce storage space.

* *access*: object[] –  allows you to impose data restrictions on users:
  - *username*: string - name of the user for whom the restrictions apply
  - *filter0*: string - filter part added to filter0 by "and" for user *username* to all requests for this stream
  - *filter1*: string - filter part added to filter1 by "and" for user *username* to all requests for this stream
  - *filter2*: string - filter part added to filter2 by "and" for user *username* to all requests for this stream
  - *canWrite*: bool - if true, allows the user to add entries to the stream
  - *canReset*: bool - if true, allows the user to reset the stream

* *vars*: object – stream variables. Is an object whose keys are variable names and whose values are default variable values.

* *links*: object[] – set up links to other streams and reports. The linked stream/report data is accessed through the linkName.field1 point. Object structure:
  - *linkName*: string - link name
  - *sourceName*: string - name of the stream/report to be linked
  - *columnPairs*: object[] - list of columns to link to:
    - *srcColumn*: string - column in the current stream
    - *dstColumn*: string - column in link stream/report

* *funcs*: object[] – computed columns:
  - *name*: string - column name
  - *calc*: string - the formula by which the column value is calculated
  - *args*: string[] - formula args ???


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

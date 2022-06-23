# Stream Config

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


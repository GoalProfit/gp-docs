# Stream columns

[Admin UI](/admin#/dataset/streams/items/columns)

Stream data structure. Here is a list of columns that will be stored in the stream. When loading data, they must be ghosted into a column view and be in the same order in which the columns on this page are declared. Thus, when loading data, the order of columns is important, and when reading data, their names are important. The description of each column is an object with the following properties:

*name*: string - column name. Required field

*type*: string - the type of data in the column. Required field. Valid types from the following list:
- *docid*: 0..4294967295 - stream entry ID
- *bool*: true/false - boolean value
- *int8*: -128..127 - one-byte integer
- *int16*: -32768..32767 - two-byte integer
- *int32*: -2147483648..2147483647 - four-byte integer
- *int64*: -9223372036854775808..9223372036854775807 - eight-byte integer
- *float*: -128..127 - single precision floating point number
- *double*: -128..127 - double precision floating point number
- *date*: yyyy-mm-dd - date without time
- *time*: hh:mm:ss - time without date
- *datetime*: yyyy-mm-ddThh:mm:ss - date with time
- *string*: string data
- *json*: JSON data

*synonym*: string - additional name of the field. Optional field

*indexed*: bool - specifies the column index. Optional field. By default, false.

*fulltext*: bool - includes a full-text search. Optional field. By default, false.

*description*: string - column description. Optional field

It is allowed to declare two special columns:

<p>
    <pre>
    - name: __file__
      type: string
    - name: __line__
      type: int32
    </pre>
</p>

\_\_file__ is automatically populated with the name of the file from which the record was loaded.
\_\_line__ is automatically populated with the line number in the file from which the record was loaded.

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

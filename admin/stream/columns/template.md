# Stream Columns

[Admin UI](/admin#/dataset/streams/items/columns)

Stream data structure. Here is a list of columns that will be stored in the stream. When loading data, they must be ghosted into a column view and be in the same order in which the columns on this page are declared. Thus, the order of columns is important when loading data and their names are important when reading data. The description of each column is an object with the following properties:

* *name*: string - column name.
* *type*: string - column type. See [column types](../../../types) for additional details.
* *synonym*: string - an optional alternative name of the field.
* *indexed*: bool - an index will be created for a column, false by default.
* *fulltext*: bool - a full-text index will be created for a column, false by default.
* *description*: string - optional column description.

Two special columns can be defined:

```yaml
- name: __file__
  type: string
  indexed: true
- name: __line__
  type: int32
```

*\_\_file__* is automatically populated with the name of the file from which the record was loaded.
*\_\_line__* is automatically populated with the line number in the file from which the record was loaded.

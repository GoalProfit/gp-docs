# Attribute

[Admin UI](/admin#/dataset/solutions/default/attributes)

* *name*: string - unique attribute name

* *calc*: string - formula name from the "Formulas" section

* *aggregation*: string - aggregation function. Valid values are:
  - *sum*  - computes arithmetic sum of the aggeragted values
  - *avg*  - computes arithmetic average of the aggeragted values
  - *mix*  - compute a weighted average of the aggeragted values 
  - *max*  - finds maximal value from the aggeragted values
  - *min*  - finds minimal value from the aggeragted values

* *title*: (value, row, column, meta) => string - a function that returns tooltip text when you hover over a cell.

* *format*: string – defines a visual formatting function that renders formula value in a table. The list of standard formats is as follows:
  * *units* – renders as a decimal value according to the defined locale with up to three decimal digits by default.  
  * *value* – renders as a money value according to the defined locale with two decimal digits with no currency sign by default.
  * *percent* – renders as a percentage value according to the defined locale with one decimal digit and a percentage sign by default. The value range 0 to 1 represents 0% to 100%.
  * *date* – renders as a date text according to the defined locale. The value is expected as a positive integer value in YYYYMMDD format. Zero is a special value that signifies no date specified.
  * *datetime* – renders as a date & time text according to the defined locale. The value is expected as a positive integer value in YYYYMMDDHHMMSS format. Zero is a special value that signifies no date & time specified.
  * *timestamp* – renders as a date & time text according to the defined locale. The value is expected as a number of seconds passed since Unix epoch time (midnight January 1, 1970  UTC/GMT). Alternatively, the value can be defined as a number of microseconds (1/1000 of second) since Unix epoch time. Zero is a special value that signifies no timestamp defined.

* *style*: (value, row, column, meta) => object - a function that returns an HTMLElement.style object that describes the cell styles of the table (tag \<td>). The possible fields of the object are described here: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/style 

* *columnClass*: (value, row, column, meta) => string - applies an optional CSS class to a table cell

* *rowClass*: (value, row, column, meta) => string - applies an optional CSS class to a table row

* *editable*: (row, column, meta) => bool - function that returns the ability to edit the value of a cell

* *keys*: string - makes sense if editable = true and stream is full. The list of stream keys on which the gp-table component is built (combined by default). Keys are listed with commas or spaces.

* *stream*: string - makes sense if editable = true. The name of the stream into which the record will be inserted when the value of the current cell is changed.
Flow structure requirements:

  ```yaml
  - name: *key 1*
    type: *key type 1*
  - name: *key 2*
    type: *key type 2*
  *other keys. Key order must be the same as keys*
  - name: create_user
    type: string
  - name: create_time
    type: double
  - name: value
    type: *cell value type*
  ```

* *position*: int32 - the order of non-key columns when loading a file

* *actionlink*: string | (row, column, meta) => string - either a string of small Latin letters and dashes, or a function that returns a URL. If specified, clicking on the cell will move to the specified URL

* *options*: string - if the cell is editable and this field is specified, the cell changes to a selection field instead of the normal input. Selection values are specified in this parameter through spaces

* *description*: string - used as an attribute comment, not used in logic

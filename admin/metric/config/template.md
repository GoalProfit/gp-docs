# Metric

[Admin UI](/admin#/dataset/solutions/default/metrics)

* *name*: string - unique metric name

* *calc*: string - formula name from the "Formulas" section

* *timeframe*: string - "reference\_date", "past", "future" or an identifier from the "Intervals" section. Default "reference\_date"

* *title*: (value, row, column, meta) => string - a function that returns tooltip text when you hover over a cell.

* *format*: string – defines a visual formatting function that renders formula value in a table. The list of standard formats is as follows:
  * *units* – renders as a decimal value according to the defined locale with up to three decimal digits by default.  
  * *value* – renders as a money value according to the defined locale with two decimal digits with no currency sign by default.
  * *percent* – renders as a percentage value according to the defined locale with one decimal digit and a percentage sign by default. The value range 0 to 1 represents 0% to 100%.
  * *date* – renders as a date text according to the defined locale. The value is expected as a positive integer value in YYYYMMDD format. Zero is a special value that signifies no date specified.
  * *datetime* – renders as a date & time text according to the defined locale. The value is expected as a positive integer value in YYYYMMDDHHMMSS format. Zero is a special value that signifies no date & time specified.
  * *timestamp* – renders as a date & time text according to the defined locale. The value is expected as a number of seconds passed since Unix epoch time (midnight January 1, 1970  UTC/GMT). Alternatively, the value can be defined as a number of microseconds (1/1000 of second) since Unix epoch time. Zero is a special value that signifies no timestamp defined.

* *style*: (value, row, column, meta) => object - a function that returns an HTMLElement.style object that describes the cell styles of the table (tag &lt;td>). The possible fields of the object are described here: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/style 

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

* *actionable*: bool - if true, then clicking on the cell will execute the function described in action

* *actionicon*: string - the name of the icon in the set https://feathericons.com. If actionable = true, an icon with the given name will be displayed in the cell.

* *actionlink*: string | (row, column, meta) => string - either a string of small Latin letters and dashes, or a function that returns a URL. If specified, clicking on the cell will move to the specified URL

* *action*: (row, column, meta) => void - if actionable = true, a function that will be executed when a cell is clicked.

* *options*: string - if the cell is editable and this field is specified, the cell changes to a selection field instead of the normal input. Selection values are specified in this parameter through spaces

* *override*: ({value, row, column, totals}) => unknown - a function that returns a cell value that replaces the calculated value. * *totals* is a Boolean value that indicates whether a function is called on a normal table row (false) or on a summary row (true).

* *description*: string - used as an metric comment, not used in logic

# Appendix: Attributes, Metrics, Formulas, Timeframes

***IMPORTANT!:** when saving the settings, they are completely
overwritten, therefore, before starting editing, it is recommended to
refresh the page to see the current settings, otherwise you can
overwrite the settings recently made by another user.*

The Type column often uses function arguments:

-   value - the value in the cell

-   row - an array of all values ​​in the row in column order

-   column - column setting

-   meta - the setting of the entire table

***IMPORTANT!:** When creating an editable attribute, you need to
display the attribute from the report with the value **last** set to the
report.*

***IMPORTANT:** config2 must not contain empty lines*

***IMPORTANT!:** if the report grain and the non-aggregated metric do
not match, the metric may or may not be displayed or a random value is
displayed*

---
# Attributes

Attributes dimensions (dims)

|Value|Type|Default value|Description|
|:----|:----|:----|:----|
|name |string|null|Unique name of the attribute|
|calc |string|null|The name of the formula from the “Formulas” section|
|aggregation |string|Depends on format value|Aggregation function. Valid values: <ul><li>-sum</li><li>-avg</li><li>-mix</li><li>-max</li><li>-min</li></ul>
|title |(value, row, column, meta) => string|null|A function that returns the tooltip text when the mouse is hovered over a cell.|
|format|(value) => string| <ul><li>For numbers:new Number(value).toLocaleString()</li><li>For date: new Date(x).toLocaleDateString()</li><li>For time: new Date(x).toLocaleTimeString()</li><li>For datetime: new Date(x).toLocaleString()</li><li>For bool: value ? "yes" : "no"</li></ul>|A function that returns the cell text. Used to format the value.|</li><li>
|style|(value, row, column, meta) => object|null|A function that returns an HTMLElement.style object that describes the styles of the table cell (the \<td\> tag). Possible object fields are described here: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/style|
|columnClass|(value, row, column, meta) => string|null|Applies an additional CSS class to a table cell|
|rowClass |(value, row, column, meta) => string|null|Applies an additional CSS class to a table row|
|editable |(row, column, meta) => bool|null|A function that returns the ability to edit the value of a cell|
|keys |string|null|Makes sense if editable = true and stream is full. List of stream keys on which the gp-table component is built (combined by default). Keys are listed separated by commas or spaces.|
|stream |string|null|Makes sense if editable = true. The name of the stream in which the record will be inserted when the value of the current cell is changed. Flow structure requirements: <ul><li>name: <key 1></li><li>type: <key type 1></li><li>- name: <key 2></li><li>type: <key type 2></li><li><other keys.</li></ul>   The order of the keys must be the same as keys> <ul><li>\- name: create_user  type: string </li><li>- name: create_time  type: double</li><li> -name: value </li><li> type: \<cell value type></li></ul>|
|position|int|0|Order of non-key columns when loading a file|
|actionlink |string | (row, column, meta) => string|null|Either a string of small Latin letters and dashes, or a function that returns a URL. If specified, clicking on the cell will navigate to the specified URL|
|options|string|null|If the cell is editable and this field is specified, then the cell changes to a selectable field instead of a normal input. Values for selection are specified in this parameter separated by spaces|
|description|string|null|Used as attribute comment, not used in logic|

Attributes are used to reflect in the system:

-   Non-aggregated concepts (product name)

-   Properties that rarely change over time (product weight)

-   Optimization strategy filters (the attribute must be *type: string*)

---
# Metrics

***IMPORTANT!:** for the correct operation of the system, it is
necessary to fill in the columns formula, range, format*

Aggregate report scores (Vals)

|Value|Type|Default value|Description|
|:----|:----|:----|:----|
|name |string|null|Unique metric name|
|formula|string|null|The name of the formula from the “Formulas” section|
|timeframe|string|reference_date|“reference_date”, “past”, “future” or an identifier from the “Timeframes” table.|
|title|(value, row, column, meta) => string|null|A function that returns the tooltip text when the mouse hovers over a cell.|
|format |(value) => string|For numbers: new Number(value).toLocaleString()For date: new Date(x).toLocaleDateString()|For time: new Date(x).toLocaleTimeString()|For datetime: new Date(x).toLocaleString()|For bool: value ? "yes" : "no"|A function that returns the cell text. Used to format the value.|style |(value, row, column, meta) => object|null|A function that returns an object that describes the table cell styles (the <td> tag). Possible object fields are described here: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/stylecolumnClass|(value, row, column, meta) => string|null|Applies an additional CSS class to a table cell|
|rowClass|(value, row, column, meta) => string|null|Applies an additional CSS class to a table row|
|editable |(row, column, meta) => bool|null|A function that returns the ability to edit the value of a cell|
|keys |string|null|Makes sense if editable = true and stream is full. List of stream keys on which the gp-table component is built (usually combined). Keys are listed separated by commas or spaces|
|stream |string|null| Makes sense if editable = true. The name of the stream in which the record will be inserted when the value of the current cell is changed. Flow structure requirements: <ul><li>name: <key 1></li><li>type: <key type 1></li><li>- name: <key 2></li><li>type: <key type 2></li><li><other keys.</li></ul>   The order of the keys must be the same as keys> <ul><li>\- name: create_user  type: string </li><li>- name: create_time  type: double</li><li> -name: value </li><li> type: \<cell value type></li></ul>|
|position|int|0|Order of non-key columns when loading a file.|
|actionable |bool|false|If the value is true, then when clicking on the cell, the function described in action will be executed|
|actionicon |string|null|The name of the icon from the https://feathericons.com set. If actionable = true, then an icon with the given name will be displayed in the cell|
|actionlink |string | (row, column, meta) => string|null|Either a string of small Latin letters and dashes, or a function that returns a URL. If specified, clicking on the cell will navigate to the specified URL|
|action|(row, column, meta) => void|undefined|The function that will be executed when the cell is clicked if actionable = true|
|options|string|null|If the cell is editable and this field is specified, then the cell changes to a selectable field instead of a normal input. Values for selection are specified in this parameter separated by spaces|
|override|({value, row, column, totals}) => unknown|undefined|A function that returns a cell value that replaces the calculated value. The totals parameter is a boolean value indicating whether the function is called on a normal table row (false) or on a totals row (true).|
|description|string|null|Used as attribute comment, not used in logic|

Metrics are used in the system for:

-   Aggregated quantities (prices of goods)

-   Values ​​that change frequently over time (prices of competitors)

---
# Formulas

Formulas are used to calculate report indicators. May depend on other
formulas. The maximum dependency depth is 10.

**IMPORTANT!:** Formula names must be unique and not the same as the
names of attributes, metrics, stream and report columns, stream and
report names, and link names, otherwise retail falls into endless
recursion.

**IMPORTANT!:** Sometimes there is an error "a column was not found in
the combined stream, although it is there. This error is caused by an
incorrect formula in the report/formula in config2.

**IMPORTANT!:** If there is NULL on at least one side of the comparison,
the system will generate an unsupported formula error.

|Value|Type|Default value|Description|
|:----|:----|:----|:----|
|id |string|null|Unique ID|
|calc |string|null|Formula supported in vals or cols, or another formula identifier|

---
# Timeframes

Used for report metrics. They impose an additional filter on the date
field when selecting values.

|Value | Type | Default value | Description|
|:----|:----|:----|:----|
|id | string | null| Unique ID |
|name | string|null|Name of the timeframe|
|calc | (date: Date) => [Date, Date]|null|A function that returns an array of two dates (objects of the Date type) - the beginning and end of the interval. The date parameter is the current date (reference date)|

---
# Formats

Format for displaying attributes and metrics (rules for converting
values ​​into strings).

|Value|Type|Default value|Description|
|:----|:----|:----|:----|
|id |string|null|Unique ID|
|calc |string|null|Formula supported in vals or cols, or another formula identifier|


Information from this page is stored in **/inbox/storage/\_**

<style>
.my-content > table th td {
    border-bottom: 1px solid var(--dark);
    border-top: 1px solid;
    border-right: 1px solid;
    border-left: 1px solid;
}
.my-content > table td,
.my-content > table th {
    border-right: 1px solid var(--dark);
    border-top: 1px solid;
    border-bottom: 1px solid;
    border-left: 1px solid;
}
</style>
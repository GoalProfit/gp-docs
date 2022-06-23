# Complete Grammar in BNF form

The system provides SQL-like syntax to query data controlled by the following parameters.

* *filter0*: `<filter>` – indexed filter
* *filter1*: `<filter>` – indexed filter
* *filter2*: `<expression>` – generic filter
* *filter3*: `<expression>` – generic filter
* *dims*: `<formulas>` – group by operation
* *vals*: `<formulas>` – aggregation operations
* *cols*: `<formulas>` – additional values defaulted to *dims* + *vals*
* *sort*: [`<integer>`] – indexes of columns for sorting

Please find below the complete grammar for these parameters in BNF form.

`<ws>` – allowed white space characters.
  ```python
  : [ \n\t]+
  ```
`<integer>` – integer value.
  ```python
  : [+-]?[0..9]+
  ```
`<float>` – floating point value.
  ```python
  : [+-]?[0..9]+\.[0..9]*
  ```
`<boolean>` – logical value.
  ```python
  : "true" | "false"
  ```
`<string>` – string value. String values are either single `'` or double `"` quoted. Quoting symbols inside strings are escaped with `\` character.
  ```python
  : [']([^']|\\')*[']
  | ["]([^"]|\\")*["]
  ```
`<date>` – simple data value in YYYY-mm-dd format.
  ```python
  : [0-9]{4}-[0-9]{2}-[0-9]{2}
  ```
`<time>` – simple time value in HH-MM-SS format.
  ```python
  : [0-9]{2}:[0-9]{2}:[0-9]{2}
  ```
`<datetime>` – simple datetime time value in YYYY-mm-ddTHH-MM-SS format.
  ```python
  : <date>T<time>
  ```
`<scalar>` – scalar value that can be either datetime, date, time, integer, string or constant expression.
scalar
  ```python
  : "`" <datetime> "`"            # for example `2022-06-02T17:30:00`
  | "`" <date> "`"                # for example `2022-06-02`
  | "`" <time> "`"                # for example `17:30:00`
  | <integer>                     # for example 12345
  | <float>                       # for example 123.45
  | <boolean>                     # for example true
  | <string>                      # for example 'abcd'
  | eval('<expression>')          # for example eval('today-1')
  ```
`<symbol>` – symbolic identificator.
  ```python
  : [a-zA-Z_][a-zA-Z_0-9]*
  ```
`<symbols>` – the symbolic path is a list of symbols separated by dot `.` character.
  ```python
  : <symbol>
  | <symbol> . <symbols>
  ```
`<filter>`  – indexed filter expression. The order of rules defines the priorities of corresponding operations.
  ```python
  : "*"                           # complete set
  | "{}"                          # empty set
  | "(" <filter> ")"
  | <filter> "||" <filter>        # logical disjunction
  | <filter> "&&" <filter>        # logical conjunction
  | <filter> "//" <filter>        # logical difference
  | <filter> "/\\" <filter>       # logical symmetric difference
  | <symbols> "==" <scalar>       # for example item == 'SKU12345`
  | <symbols> "!=" <scalar>       # for example item.color != 'RED`
  | <symbols> "<>" <scalar>       # for example item.color <> 'RED`
  | <symbols> "<" <scalar>        # for example date < '2022-06-02`
  | <symbols> ">" <scalar>        # for example date > '2022-06-02`
  | <symbols> "<=" <scalar>       # for example date <= '2022-06-02`
  | <symbols> ">=" <scalar>       # for example date >= '2022-06-02`
  | <symbols> "in [" <scalar> "]" # for example date in ['2022-06-02`, '2022-06-01`]
  | "!" <filter>                  # logical negation
  ```

`<unop>` – unary operator defines a single argument function.
  ```python
  : "abs"         # returns the absolute value of an argument
  | "floor"       # returns the largest integer value less than or equal to an argument
  | "ceil"        # returns the lowest integer value greater than or equal to an argument
  | "round"       # returns the nearest value (rounded value) of a given argument
  | "log"         # computes the natural logarithm of an argument
  | "exp"         # computes e raised to the power of the given argument
  | "htmlescape"  # escapes all HTLM special characters to their corresponding entity reference (e.g. &lt;)
  ```

`<aggop>` – aggregation operator in the map-reduce sequence.
  ```python
  : "one"         # returns one of the arregated values
  | "all"         # returns true if all aggeragted values are evaluated to true
  | "any"         # returns true if at least one of the aggeragted values is evaluated to true
  | "sum"         # computes arithmetic sum of the aggeragted values
  | "avg"         # computes arithmetic average of the aggeragted values
  | "mean"        # computes arithmetic average of the aggeragted values
  | "min"         # finds minimal value from the aggeragted values
  | "max"         # finds maximal value from the aggeragted values
  | "count"       # returns number of aggeragted values
  ```

`<dateop>` – operations with date & time values
  ```python
  = "date"        # returns date component of the <datetime> value
  | "time"        # returns time component of the <datetime> value
  | "year"        # returns year component of the <date> value
  | "month"       # returns month component of the <date> value
  | "day"         # returns day component of the <date> value
  | "hour"        # returns hour component of the <time> value
  | "minute"      # returns hour component of the <minute> value
  | "second"      # returns hour component of the <second> value
  | "weekday"     # computes zero based weekday number for the given <datetime> value where week starts from Sunday
  ```

`<binop>` – binary operator defines a double argument function.
  ```python
  : "isnull"      # tries to compute the first argument and returns the second argument if computation is interrupted.
  | "isempty"     # tries to compute the first argument, returns the second argument if computation results in an empty string
  | "first"       # find the value of the first argument that corresponds to the minimal value of the second argument
  | "last"        # find the value of the first argument that corresponds to the maximal value of the second argument
  | "prefix"      # finds the common prefix of two given string arguments. The remaining part is replaced with the *** sequence
  ```

`<expression>` – generic expression, The order of rules defines the priorities of corresponding operations.
  ```python
  : "(" <expression> ")"
  | "[" <expressions> "]"
  | <aggop> "(" <expression> ")"
  | <unop> "(" <expression> ")"
  | <binop> "(" <expression> "," <expression> ")"
  | <dateop> "(" <expression> "," <expression> ")"
  | "search" "(" <string> "," <symbols> ")"                         # returns true if full text search returns any results
  | "snippet" "(" <string> "," <symbols> ")"                        # returns full text search results
  | "snippet" "(" <string> "," <symbols> "," <integer> ")"          # returns full text search results up to the defined limit
  | "cast" "(" <expression> "," <symbol> ")"                        # casts an expression to a given type
  | "jq" "(" <expression> "," <string> ")"                          # performs JQ query on a JSON value
  | "jq" "(" <expression> "," <string> "," <symbol> ")"             # performs JQ query on a JSON value and casts it to a given type
  | "jql" "(" <expression> "," <string> ")"                         # performs JQL query on a JSON value
  | "jql" "(" <expression> "," <string> "," <symbol> ")"            # performs JQL query on a JSON value and casts it to a given type
  | "subst" "(" <expression> "," <expression> "," <expression> ")"  # returns a new string with some or all matches of a pattern replaced by a replacement
  | "date" "(" <expression> "," <expression>, "," <expression> ")"  # constructs value of the date type from date components
  | "time" "(" <expression> "," <expression> "," <expression> ")"   # constructs value of the time type from date components
  | "datetime" "(" <expression> "," <expression> ")"                # constructs value of the datetime type from date and time components
  | "datetime" "(" <expression> ")"                                 # converts a YYYYmmddHHMMSS integer value to a datetime value
  | <expression> "if" <expression>                                  # computes the first expression only if the second one evaluates to true
  | <expression> "if" <expression> "else" <expression>              # computes the first expression only if the second one evaluates to true, returns the third expression otherwise
  | <expression> "||" <expression>                                  # logical or operation
  | <expression> "&&" <expression>                                  # logical and operation
  | <expression> "==" <expression>                                  # tests equality of two expression
  | <expression> "!=" <expression>                                  # tests if two expression are not equal
  | <expression> "<>" <expression>                                  # tests if two expression are not equal
  | <expression> "in" "[" <expressions> "]"                         # checks if the first expression value is present in a give list
  | <expression> "not in" "[" <expressions> "]"                     # checks if the first expression value is not present in a give list
  | <expression> "=~" <expression>                                  # tests if the first expressions matches regular expression given in the second expression
  | <expression> "!~" <expression>                                  # tests if the first expressions doesn't match regular expression given in the second expression
  | <expression> "=~" <expression>
                 ":=" <expression>                                  # tests and replaces expression value against given regular expression. matched groups can be referenced using $N syntax
  | <expression> "like" <expression>                                # tests expression value against a given wildcard. '*' represents zero, one, or multiple characters
  | <expression> "<" <expression>                                   # tests if the first expression is less than the second expression
  | <expression> ">" <expression>                                   # tests if the first expression is greater than the second expression
  | <expression> "<=" <expression>                                  # tests if the first expression less than or equal to the second expression
  | <expression> ">=" <expression>                                  # tests if the first expression greater than or equal to the second expression
  | <expression> "+" <expression>.                                  # sums two expressions
  | <expression> "-" <expression>                                   # subtracts two expressions
  | <expression> "*" <expression>                                   # muliplies two expressions
  | <expression> "/" <expression>                                   # computes division of two expressions
  | <expression> "%" <expression>.                                  # computes mod of two expressions
  | "!" <expression>                                                # inverts a logical value
  | "-" <expression>                                                # negates a numeric value
  | "+" <expression>                                                # singnifies positivenes of a numeric value
  | "now"                                                           # returns current date & time according to the configured timezone
  | "today"                                                         # returns current date according to the configured timezone
  | <scalar>                                                        # returns constant expression
  | <symbol>                                                        # resolves given name to a stream or report column or a function
  | <symbol> "." <symbol>                                           # resolved given name following a predefined report or stream link
  ```

`<expressions>` – comma-separated list of expressions
  ```python
  : <expression>
  | <expression> "," <expressions>
  ```

`<formula>` – formula with optional alias
  ```python
  : <expression> "as" <string>
  | <expression> "as" <symbol>
  | <expression>
  ```

`<formulas>` – comma-separated list of formulas
  ```python
  : <formula>
  | <formula> "," <formulas>
  ```

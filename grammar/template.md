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

`<dateop>` – operations with date & time values. 
  ```python
  : "date"        # returns date component of the <datetime> value. Output date type
  | "time"        # returns time component of the <datetime> value Output time type
  | "year"        # returns year component of the <date> value. Output interger type
  | "month"       # returns month component of the <date> value. Output interger type
  | "day"         # returns day component of the <date> value. Output interger type
  | "hour"        # returns hour component of the <time> value. Output interger type
  | "minute"      # returns minute component of the <time> value. Output interger type
  | "second"      # returns second component of the <time> value. Output interger type
  | "weekday"     # computes zero based weekday number for the given <date> value where week starts from Sunday. Output interger value
  
  # Example Input: now.date.weekday
  # Example Input: now.time.hour
  ```

`<binop>` – binary operator defines a double argument function.
  ```python
  : "isnull"      # tries to compute the first argument and returns the second argument if computation is interrupted. isnull(<expression>,<expression2>) 
  | "isempty"     # tries to compute the first argument, returns the second argument if computation results in an empty string. Work with string expression only.
  
  | "first"       # return the value of the first argument that corresponds to the aggregated minimal value of the second argument. 
  | "last"        # return the value of the first argument that corresponds to the aggregated maximal value of the second argument Second argument will be aggregrated
  
  | "prefix"      # finds the common prefix of two given string arguments. The remaining part is replaced with the *** sequence
  | "round"       # returns the nearest value (rounded value) of a given argument and second argument as precision.
  ```

`<expression>` – generic expression, The order of rules defines the priorities of corresponding operations.
  ```python
  : "(" <expression> ")"                                            # takes an expression as input enclosed within parentheses and returns the result of that expression.
  | "[" <expression1>, <expression2> "]"                            # takes multiple expressions separated by commas within square brackets and returns a list or array containing those expressions.
  
  | <aggop> "(" <expression> ")"                                    # aggregation operation being performed on a single expression & returns the result of the aggregation operation
  
  # Example Input: avg(sales_units)
  # Example Input: any(competitor_action !=0)
  
  | <unop> "(" <expression> ")"                                     # unary operation being performed on a single expression & returns the result of the unary operation
  
  # Example Input: abs(optimization.final_price - zone_price)
  # Example Input: round(sum_sales_units)
  
  | <binop> "(" <expression1> "," <expression2> ")"                   # takes two expressions as input separated by a comma and returns the result of the binary operation applied to those expressions.
  
  # Example Input: last(create_user, create_time)                     # Output is aggregated value of expression1
  # Example Input: insull(new_price.price, zone_price)                # Output is value of expression1 or expression2 if expression1 return NULL
  # Example Input: round(new_price.price, 2)                          # Output is value of expression1 rounded by presision of 2
  
  | <expression>.<dateop>                                             # Return component of date/datetime value
  
  # Example Input: (today - date - today.weekday + 7)
  # Example Input: datetime(link.create_time/1000).date
  # Example Input: now.date.weekday
  # Example Input: now.time.hour


  | "search" "(" <string> "," <symbols> ")"                         # returns true if full text search returns any results. It takes a search term (string) and symbols (symbols) as input parameters.
  | "snippet" "(" <string> "," <symbols> ")"                        # returns full text search results
  | "snippet" "(" <string> "," <symbols> "," <integer> ")"          # returns full text search results up to the defined limit. It takes a search term (string), symbols (symbols), and an optional limit (integer) as input parameters. It returns the full-text search results, either all results or up to the defined limit if specified.
  ```
  
  ```python
  | "cast" "(" <expression> "," <symbol> ")"                        # casts an expression to a given type.  It takes an expression (of any type) and a symbol (representing the target type) as input parameters. It returns the expression casted to the specified type.
  
  # Example Input: cast(data, double)
  # Example Input: cast(numeric_data, string)

  | "jq" "(" <expression> "," <string> ")"                          # performs JQ query on a JSON value.  It takes an expression representing a JSON value and a JQ query string as input parameters. It returns the result of the JQ query performed on the JSON value.
  | "jq" "(" <expression> "," <string> "," <symbol> ")"             # performs JQ query on a JSON value and casts it to a given type. 
  | "jql" "(" <expression> "," <string> ")"                         # performs JQL query on a JSON value
  | "jql" "(" <expression> "," <string> "," <symbol> ")"            # performs JQL query on a JSON value and casts it to a given type. It takes an expression representing a JSON value and a JQL query string as input parameters. It returns the result of the JQL query performed on the JSON value.
 
  # Example Input: jql(workflow_status, "[4]", string)              # return 5th value of json and cast it to string type
  # Example Input: jq(rules.optimization_rule_data, '.weight')      # return 'weight' value of json. Return output will be json type.

  | "subst" "(" <string1> "," <string2> "," <string3> ")"   # returns a new string with some or all matches of a pattern replaced by a replacement. It takes three expressions as input parameters: the original string, the pattern to search for, and the replacement string. It returns a new string with some or all matches of the pattern replaced by the replacement. All expression should be string type
  # Example input: subst(rule_number, '6', 'universe')
  ```
  
  ```python
  | "date" "(" <expression1> "," <expression2>, "," <expression3> ")"  # constructs value of the date type from date components. It takes three expressions representing the year, month, and day as input parameters. It returns a date value constructed from these components. Expressions must be float or interger type.
  | "time" "(" <expression1> "," <expression2> "," <expression3> ")"   # constructs value of the time type from date components. It takes three expressions representing the hour, minute, and second as input parameters. It returns a time value constructed from these components. Expressions must be float or interger type.
  
  # Example Input: date(2024.0,01,01) as date_created
  # Example Input: time(20,01,01) as time_created


  | "datetime" "(" <expression1> "," <expression2> ")"               # constructs value of the datetime type from date and time . It takes two expressions representing the date and time as input parameters. It returns a datetime value constructed from these components. Expression1 must be date type and Expression2 must be time type
  | "datetime" "(" <expression> ")"                                  # converts a YYYYmmddHHMMSS integer value to a datetime value. It takes a single expression representing the integer value as input and returns a datetime value.

  # Example Input: datetime(date_created, time_created)
  # Example Input: datetime( create_time / 1000 )
  # Example Input: (datetime( create_time / 1000 )).date 
  # Example Input: max(datetime(cast(data, double) / 1000) if data != '''' else 0.0) as data
  ```
  
  ```python
  | <expression1> "if" <expression2>                                # computes the first expression only if the second one evaluates to true. Return NULL if expression2 evaluates to false.
  | <expression1> "if" <expression2> "else" <expression3>           # computes the first expression only if the second one evaluates to true, returns the third expression otherwise. Expression1 & expression3 should be the same data type.
  | <expression> "||" <expression>                                    # logical or operation
  | <expression1> "&&" <expression2>                                  # logical and operation
  | <expression1> "==" <expression2>                                  # tests equality of two expression
  | <expression1> "!=" <expression2>                                  # tests if two expression are not equal
  | <expression1> "<>" <expression2>                                  # tests if two expression are not equal
  
  # Example: optimization.final_price if new_price.price !=0 && abs(optimization.final_price - zone_price) > 0.0001 else new_price.price

  | <expression> "in" "[" <expressions> "]"                         # checks if the first expression value is present in a give list
  | <expression> "not in" "[" <expressions> "]"                     # checks if the first expression value is not present in a give list
  | <expression1> "=~" <expression>                                  # tests if the first expressions matches regular expression given in the second expression
  | <expression1> "!~" <expression2>                                  # tests if the first expressions doesn't match regular expression given in the second expression
  | <expression1> "=~" <expression2>
                 ":=" <expression>                                  # tests and replaces expression value against given regular expression. matched groups can be referenced using $N syntax
 
  # Example: any(cast(jq(rules.optimization_rule_data, '.weight') =~ '([0-9.]+)' := '$1', float) if cast(jq(rules.optimization_rule_data, '.type'), string) == 'balanced_optimization' && cast(jq(rules.optimization_rule_data, '.goal'), string) == 'demand') as demand

  
  | <expression1> "like" <expression2>                                # tests expression value against a given wildcard. '*' represents zero, one, or multiple characters
  | <expression1> "<" <expression2>                                   # tests if the first expression is less than the second expression
  | <expression1> ">" <expression2>                                   # tests if the first expression is greater than the second expression
  | <expression1> "<=" <expression2>                                  # tests if the first expression less than or equal to the second expression
  | <expression1> ">=" <expression2>                                  # tests if the first expression greater than or equal to the second expression
  
  | <expression1> "+" <expression2>.                                  # sums two expressions
  | <expression1> "-" <expression2>                                   # subtracts two expressions
  | <expression1> "*" <expression2>                                   # muliplies two expressions
  | <expression1> "/" <expression2>                                   # computes division of two expressions
  | <expression1> "%" <expression2>.                                  # computes mod of two expressions
  
  
  | "!" <expression>                                                # inverts a logical value
  | "-" <expression>                                                # negates a numeric value
  | "+" <expression>                                                # singnifies positivenes of a numeric value
  | "now"                                                           # returns current date & time according to the configured timezone. Output type datetime
  | "today"                                                         # returns current date according to the configured timezone Output type datetime
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

# Stream spouts

[Admin UI](/admin#/dataset/streams/items/spouts)

Spouts define data sources for a stream. Streams with not spouts still can receive data via `appendRecords` [GraphQL](../../../graphql) API.

## DelimitedFile spout – loading data from files

Spout loads files from a given directory that matches a given mask.

* *type*: string = DelimitedFile

* *searchPath*: string - path to the directory in which the files are searched. The path can be relative to the working directory. The path is specified in Linux format.

* *searchMask*: string - file name mask as a regular expression following syntax defined at https://docs.rs/regex/latest/regex/#syntax

* *keepLast*: bool - if true, then the stream will only contain the data from the last file. The last file is defined as the last file in the list of files sorted alphabetically by the file name. This parameter is false by default.

* *skipRows*: integer - defines a number of rows to skip from the beginning of each file. The default value is 0.

* *delimiter*: string - column delimiter in the file.

* *quote*: string - specifies quotation character for quoted fields. The default value is `"`.

* *quoting*: bool - specifies if fields quotation is used in a file. The default value is true.

* *doubleQuote*: bool - specifies if quotation characters are doubled for fields that have quotation characters. Here is an example of a double-quoted field: `"Milk ""House in the Village"""`. The default value is true.

* *bolts*: string[][] - a list of programs that process the input before loading it into the stream. The first line of each bolt must be a valid Linux executable available in the server container. The remaining lines are command parameters. The data obtained from the file is transmitted to the first command via `stdin`. Processed data must be sent to `stdout`. The program can write logs to `stderr`. If a log line starts with the character `!`, such line is considered an important message. Every subsequent program receives data via `stdin` from the previous program. Data from the `stdout` of the last command is added to the stream. The default value is[].

* *batch*: integer - specifies the number of files to process in a single dataset synchronization cycle. For a large number of files, it is recommended that you set this value to avoid overloading the system. The default constraint is not set.

* *loadedPaths*: string[] - list of files that are loaded to the stream.

* *excludedPaths*: string[] - a list of files that will be excluded from loading.

* *parsers*: object - paser settings:
  - *decimal*: string - separator of whole and fractional parts. The default value is `.`.
  - *thousands*: string - thousands delimiter. The default value is null (no thousands delimiter used).
  - *dateFormats*: string[] - date formats without time. When parsing date values, the formats are applied in the order in which they are defined. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
  - *timeFormats*: string[] - time formats. When parsing time values, the formats are applied in the order in which they are defined. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
  - *datetimeFormats*: string[] - date formats with time. When parsing datetime values, formats are used in the order in which they are defined. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
 
DelimitedFile configuration example:

```
- type: DelimitedFile
  searchPath: ../inbox
  searchMask: out_assort_.*.csv.gz
  keepLast: true
  skipRows: 0
  delimiter: ;
  quote: '"'
  quoting: false
  doubleQuote: false
  bolts: []
  loadedPaths:
    - out_assort_20220610060636.csv.gz
  excludedPaths:
    - out_assort_20211226052436.csv.gz
    - out_assort_20211229065415.csv.gz
    - out_assort_20220210051438.csv.gz
    - out_assort_20220211052408.csv.gz
    - out_assort_20220213052257.csv.gz
    - out_assort_20220214065441.csv.gz
    - out_assort_20220214140200.csv.gz
    - out_assort_20220214165359.csv.gz
    - out_assort_20220215051505.csv.gz
    - out_assort_20220216070200.csv.gz
  parsers:
    decimal: null
    thousands: null
    dateFormats:
      - '%Y-%m-%d 00:00:00.000'
    timeFormats: []
    datetimeFormats:
      - '%Y-%m-%d %H:%M:%S%.3f'

```

## ExternalProcess spout – loading data using an external program

This type of spout allows to load data into a stream using an external console program that complies with the following protocol:

* As the first line in `stdin` it receives its configuration encoded as a single-line JSON.
* As the second line in `stdin` it receives the previously stored synchronization state encoded as a single-line JSON.
* As the first list in `stdout` it sends an updated synchronization state encoded as a single-line JSON.
* As the second line in `stdout` it sends list of row keys to remove from a stream encoded as a single-line JSON.
* All the remaining output in `stdout` will be considered as CSV encoded list of new rows to add to a stream.
* It sends log messages to `stderr`. Important messages start with `!` character.


The spout settings are the following:

* *type*: string = ExternalProcess

* *config*: object - is passed as a JSON string to the called program by the first line in stdin.

* *state*: object - is passed as a JSON string to the called program by the second line in stdin.

* *command*: string[] - the first line is a valid bash command available in the server container. The remaining lines are command parameters.

* *skipRows*: integer - defines a number of rows to skip from the beginning of each file. The default value is 0.

* *delimiter*: string - column delimiter in the file.

* *quote*: string - specifies quotation character for quoted fields. The default value is `"`.

* *quoting*: bool - specifies if fields quotation is used in a file. The default value is true.

* *doubleQuote*: bool - specifies if quotation characters are doubled for fields that have quotation characters. Here is an example of a double-quoted field: `"Milk ""House in the Village"""`. The default value is true.

* *bolts*: string[][] - a list of programs that process the input before loading it into the stream. The first line of each bolt must be a valid Linux executable available in the server container. The remaining lines are command parameters. The data obtained from the file is transmitted to the first command via `stdin`. Processed data must be sent to `stdout`. The program can write logs to `stderr`. If a log line starts with the character `!`, such line is considered an important message. Every subsequent program receives data via `stdin` from the previous program. Data from the `stdout` of the last command is added to the stream. The default value is[].

* *parsers*: object - paser settings:
  - *decimal*: string - separator of whole and fractional parts. The default value is `.`.
  - *thousands*: string - thousands delimiter. The default value is null (no thousands delimiter used).
  - *dateFormats*: string[] - date formats without time. When parsing date values, the formats are applied in the order in which they are defined. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
  - *timeFormats*: string[] - time formats. When parsing time values, the formats are applied in the order in which they are defined. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
  - *datetimeFormats*: string[] - date formats with time. When parsing datetime values, formats are used in the order in which they are defined. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
 
ExternalProcess configuration example:
```
- type: ExternalProcess
  config: '{}'
  state: 'null'
  command:
    - python3
    - '-u'
    - '-c'
    - |
      import json
      import sys
      import requests
      import time
      config = json.loads(sys.stdin.readline())
      state = json.loads(sys.stdin.readline()) or {}
      headers={"authorization": "xxxxxx="}
      categories = requests.get("https://server/data", headers=headers).json()
      newIds = list(range(0, len(categories)))
      oldIds = state.get("ids", [])
      print(json.dumps({"ids": newIds}))
      print(json.dumps(oldIds))
      createTime = time.time()
      for (categoryIndex, categoryId) in zip(range(0, len(categories)), categories):
          categoryName = categories[categoryId]['name']
          date = categories[categoryId]['date']
          status = categories[categoryId]['status'] if 'status' in categories[categoryId] else ''
          print(f"{categoryIndex},{categoryId},{categoryName},{status},{date},{createTime}")
  skipRows: 0
  delimiter: ','
  quote: '"'
  quoting: false
  doubleQuote: true
  parsers:
    decimal: null
    thousands: null
    dateFormats:
      - '%Y-%m-%d'
      - '%m/%d/%y'
      - '%m/%d/%Y'
      - '%Y-%m-%dT00:00:00'
      - '%Y-%m-%dT00:00:00.000'
      - '%Y-%m-%d 00:00:00'
      - '%Y-%m-%d 00:00:00.000'
    timeFormats:
      - '%H:%M:%S'
      - '%H:%M'
      - '%H%M%S'
    datetimeFormats:
      - '%Y-%m-%dT%H:%M:%S%.3f %z'
      - '%Y-%m-%dT%H:%M:%SZ'
      - '%Y%m%dT%H:%M:%SZ'
      - '%Y-%m-%dT%H:%M:%S'
      - '%Y-%m-%d %H:%M:%S'
      - '%m/%d/%y %H:%M'
      - '%m/%d/%Y %H:%M'
      - '%Y%m%d%H%M%S'
      - '%Y%m%d'
```

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

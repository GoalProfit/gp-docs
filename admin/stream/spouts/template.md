# Stream spouts

[Admin UI](/admin#/dataset/streams/items/spouts)

Spouts are rules for loading data into a stream. Every 10 seconds, each spout checks for new data and loads it.

Spouts come in two forms: loading from files and executing an arbitrary external program.

## Load from files
Spout searches for files in a specific directory according to the specified mask.

*type*: DelimitedFile – type spout. To load from files, must be set to DelimitedFile.

*searchPath*: string - path to the directory in which the files are searched. The path can be relative. The current directory is the directory where the server executable file (olap-rust) is located. The path is specified in Linux format.

*searchMask*: string - the file name mask in the *searchPath* directory. Supports regular expressions with the following syntax: https://docs.rs/regex/latest/regex/#syntax

*keepLast*: bool - if true, then the stream will contain the data of only the last file, otherwise - all those who fell under the mask. The last file is sorted by file name. By default, false.

*skipRows*: int32 - the number of rows skipped from the beginning in the file. Relevant for downloading files with data separated by a separator (csv, tsv, ...). The default is 0.

*delimiter*: string - column delimiter in the file. Relevant for loading files with data separated by a separator (csv, tsv,...). By default, "."

*quote*: string - if some fields are enclosed in quotation marks, specify a quotation mark character to remove them from the field value. Only makes sense if *quoting* = true. Default ''.

*quoting*: bool - if true, the first and last characters are removed from the column value if they match *quote*. By default, true.

*doubleQuote*: bool - if true, the quotation marks inside the column are screened by doubling the quotation mark character instead of using the backslash (for example, "Milk""House in the Village""" instead of "Milk\\"House in the Village\\""). By default, true.

*bolts*: string[][] - a list of programs that process the input before loading it into the stream. The first line of each bolt must be a valid bash command available in the server container. The remaining lines are command parameters. The data obtained from the file is transmitted to the first command via stdin. After processing the data, the program must output it to stdout. The program can write logs in stderr. If the log line starts with the character "!," Then this log line is considered an important message, all other log lines are ordinary. The second program receives data in stdin from the first program (which it wrote to stdout), etc. The data from the stdout of the last command is added to the stream. Default is [].

*batch*: uint64 - specifies the number of files to download simultaneously. For a large number of files, it is recommended that you set this value to avoid overloading the system. The default constraint is not set.

*loadedPaths*: string[] - list of files uploaded to the stream. Files in this list are not reloaded. Default is [].

*excludedPaths*: string[] - a list of files that are ignored by the current bolt. It is useful to use if there are several bolts that intersect on file masks, but have different loading logic. For example, when changing a set of columns in files at some point. Default is [].

*parsers*: object - list of formats for parsing values. The default is not set. List of possible keys:
- *decimal*: string - separator of whole and fractional parts. Default is "."
- *thousands*: string - bit separator. The default is null (no delimiter used).
- *dateFormats*: string[] - date formats without time. When parsing date values, the formats are applied in the order in which they are described. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
- *timeFormats*: string[] - time formats. When parsing time values, the formats are applied in the order in which they are described. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
- *datetimeFormats*: string[] - date formats with time. When parsing datetime values, formats are used in the order in which they are described. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
 
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

##### Load using an external program
Spout calls an external program and uses the result of its work as a data source. To use this type of load, a column must be declared in the stream:
<p>
    <pre>
    - name: id
      type: docid
      indexed: true
    </pre>
</p>
The called program must output the results of its work in stdout:
The first line is a json object with a list of record identifiers to add:
<p>
    <pre>
    { 
          "ids": [] // list of ids to add
    }
    </pre>
</p>
The second line is a json object with a list of deleted record identifiers:
<p>
    <pre>
    { 
        "ids": [] // list of ids to delete
    }
    </pre>
</p>
Each next line is the record to be added. The columns are separated by a separator.

*type*: ExternalProcess – type spout. ExternalProcess must be set to ExternalProcess to call an external program.

*state*: object - is passed as a JSON string to the called program by the first line in stdin.

*config*: object - is passed as a JSON string to the called program by the second string in stdin.

*comnand*: string[] - the first line is a valid bash command available in the server container. The remaining lines are command parameters.

*skipRows*: int32 - the number of rows skipped from the beginning in the file. Relevant for downloading files with data separated by a separator (csv, tsv, ...). The default is 0.

*delimiter*: string - column delimiter in the file. Relevant for loading files with data separated by a separator (csv, tsv,...). By default, "."

*quote*: string - if some fields are enclosed in quotation marks, specify a quotation mark character to remove them from the field value. Only makes sense if *quoting* = true. Default ''.

*quoting*: bool - if true, the first and last characters are removed from the column value if they match *quote*. By default, true.

*doubleQuote*: bool - if true, the quotation marks inside the column are screened by doubling the quotation mark character instead of using the backslash (for example, "Milk""House in the Village""" instead of "Milk\\"House in the Village\\""). By default, true.

*parsers*: object - list of formats for parsing values. The default is not set. List of possible keys:
- *decimal*: string - separator of whole and fractional parts. Default is "."
- *thousands*: string - bit separator. The default is null (no delimiter used).
- *dateFormats*: string[] - date formats without time. When parsing date values, the formats are applied in the order in which they are described. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
- *timeFormats*: string[] - time formats. When parsing time values, the formats are applied in the order in which they are described. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
- *datetimeFormats*: string[] - date formats with time. When parsing datetime values, formats are used in the order in which they are described. Syntax of possible formats: https://docs.rs/chrono/0.4.0/chrono/format/strftime/index.html
 
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

# Stream links

Set up links to other streams and reports. The linked stream/report data is accessed through the linkName.field1 point. Advertised links cannot be used in the current report, but can be used in other streams/reports that use this one. Is an array of objects:

- *linkName*: string - link name
- *sourceName*: string - name of the stream or report to be linked
- *columnPairs*: object[] - a list of columns on which to link. Is an array of objects:
  - *srcColumn*: string - column in the current stream
  - *dstColumn*: string - link stream/report column

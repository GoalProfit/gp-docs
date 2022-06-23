# Streams

[Admin UI](/admin#/dataset/streams)

Streams represent structured material data. Stream has a name, a set of [columns](../../stream/columns/) and a set of [spouts](../../stream/spouts/). Spouts are data sources for a stream. The physical representation of a stream is a set of [content addressable](https://en.m.wikipedia.org/wiki/Content-addressable_storage) flat chunks stored in the *data/objects* folder and mapped to the system memory. Each chunk holds up to `65,536` rows. Chunk layout can be columnar or row-oriented depending on the stream settings. Besides actual data, each chunk holds indexes for indexed columns. Each chunk represents an atomic job in the map-reduce pipeline.

See [Data Model](../../../datamodel) for additional details


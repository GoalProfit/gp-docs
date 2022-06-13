# Dataset settings

[Admin UI](/admin#/dataset/config)

Dataset is a top-level data entry point. Besides the properties listed below dataset holds lists of sources, streams, reports, and users for a corresponding instance. On a file system, a dataset is represented as a data/dataset.json file and a list of binary files in a data/objects directory. Binary files in the data/objects directory represent content-addressable chunks of dataset streams. Once created, such binary files are never modified and can only be garbage collected if not referenced by any of the dataset versions. Dataset changes are synchronized to storage in an atomic way following the sequence:

1. Identify and atomically write stream chunks that are not yet stored in the data/objects folder.
2. Write a new version of the dataset.json file into a temporary file.
3. Atomically swap the new version of dataset.json and the current version of dataset.json, so the new version becomes current, and the current version becomes old.
4. Identify and garbage collect any binary files in the data/objects folder that are not referenced by the old and current versions of datatset.json. 

*refresh* – defines delay in seconds between streams' synchronization cycles. Streams are synchronized all together in a transaction. All changes will be published simultaneously. If any of the streams were asynchronously changed during synchronization, all changes would be rejected. It's assumed that streams synchronization logic is idempotent and has no side effects.

*assets* – specifies global frontend assets that will be prepended to all pages. Page code can expect all assets to be loaded before executing any custom logic. Typical use cases are to load third-party libraries or register a set of custom components.

*private* – if set, disables access for unauthorized users (anonymous access).

*timezone* – sets the time zone for date & time functions used in queries. Time zone name follows the TZ database name convention described on https://en.m.wikipedia.org/wiki/List_of_tz_database_time_zones

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

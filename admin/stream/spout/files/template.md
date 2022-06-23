# Stream Files

[Admin UI](/admin#/dataset/streams/items/files)

List of files that belong to the stream.
The Search field is used to filter files by name mask. Supports regular expressions.
Below the search field is the number of entries in the stream and the _browse_ link, with which you can view the contents of the entire stream.
Below are all files that are related to this stream. The file list has the following columns:

- File date (taken from file name as substring YYYYMMDD).
- Filename.
- The number of lines loaded from this file, or a "skipped" state indicating that the file was skipped because it is not the last (makes sense if keepLast = true).
- The _exclude_ link, which allows you to exclude a file from the stream and remove entries downloaded from this file from it.
- Link _include_, which allows you to include the file in the stream and download records from it (if the file was excluded earlier).
- A _delete_ reference that allows you to delete a file from the vault (if it was previously excluded).
- The _browse_ link, which allows you to view all records loaded from this file.
- Link _show logs_, which allows you to view the download log if the output in stderr is used in the bolts of the stream.
- Link _download_, which allows you to download the file to your local computer.
 

<style>
.dark-theme .my-content {
    color: var(--light)
}
.dark-theme h1,h2,h3,h4,h5 {
    color: white;
}
.dark-theme b,i,em {
    color: rgb(88,167,202);
}
</style>

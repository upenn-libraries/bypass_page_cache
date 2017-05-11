# bypass_page_cache

The OS page cache is designed to cache disk blocks in memory
to prevent costly disk access. Standard behavior is for the OS
to cache blocks whenever a file is written or read.

This is normally a good thing, or at least not a bad thing.
But when processing large amounts of data in a streaming fashion,
blocks are cached when it's certain they won't be used again 
before being purged to make room for new input/output. On a
dedicated machine, this is at worst pointless (caching only to
purge); but on a shared machine with processes with a high 
page cache hit ratio, streaming processing of large amounts of
data can become pathological, causing page cache thrashing. 

Most information about bypassing the page cache is focused on
lower-level C libraries, but many large-scale data processing
jobs are controlled from much higher-level scripting languages.

This script attempts to bridge that gap by allowing higher-level
control over bypassing the page cache. The script behaves like 
`cat`, with the intention that it be as unobtrusive as possible.

This likely doesn't work on all systems... YMMV.

```
Usage: direct_io.sh [-w|-r] [file]...

  Read/write files, bypassing page cache

  -w [out_file]
    Write stdin to specified file (or stdout)
    When out_file is - or unspecified, write to stdout
  -r [in_file]...
    Read specified files (and/or stdin) to stdout
    When in_file is - or unspecified, read from stdin
```

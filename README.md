# My Tools

## Update Vim

### Prerequisite

* Vim repository is checked out at `$HOME/repos/vim`
* Run on unixy OS (Linux, macOS, ...)
* Mercurial command `hg` is available
* `make` is available

### How to run the programme

Install Vim with my favourite settings

```sh
$ bin/vimupdate -r REVISION
```

Where `REVISION` can be obtained from Vim repository.

### How to pick a revision

```sh
$ hg pull       # Fetch recent changes
$ hg update     # Apply changes
$ hg log
changeset:   13107:fe7d576a3d3f
tag:         v8.0.1428
...
```

Here the revision number is `13107`.

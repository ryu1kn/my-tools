# My Tools

## Update Vim

### Prerequisite

* Vim's Git repository is checked out at `$HOME/repos/vim`
* Run on unixy OS (Linux, macOS, ...)
* `git` is available
* `make` is available

### How to run the programme

Install Vim with my favourite settings

```sh
$ bin/vimupdate -r VERSION
```

Where `VERSION` can be obtained from Vim repository.

### How to pick a version

```sh
$ git pull       # Fetch recent changes
$ git tag
v7.0
v7.0.001
...
v8.0.1654
v8.0.1655
```

Here, for example, you can pick a version `v8.0.1655`.

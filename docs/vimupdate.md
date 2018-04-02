## Update Vim

Compile & install the latest Vim with my preferred settings.

**NOTE:** Here file/directory paths are relative to the repository root

### Prerequisite

* Vim's Git repository is checked out at `$HOME/repos/vim`
* Run on unixy OS (Linux, macOS, ...)
* `git` is available
* `make` is available

### How to run the programme

Install Vim with my favourite settings

```sh
$ bin/vimupdate
```

### How to install a version you want

1. Go to the vim repository directory
1. Checkout the state that you want to build
1. Come back here and execute the `vimupdate` command with `c` (`use_current`) flag:

    ```sh
    $ bin/vimupdate -c
    ```

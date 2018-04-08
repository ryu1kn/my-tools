# GitHub Flavored Markdown to HTML

* Convert (GitHub Flavored?) Markdown to HTML
* Add `prettyprint` class to `pre` tag (so that [JavaScript code prettifier](https://github.com/google/code-prettify) can prettify it)
* Add language information to `pre` and `code` tag (so that [JavaScript code prettifier](https://github.com/google/code-prettify) can prettify itcode blocks)

## Setup

Install dependencies by `bundle install`

## Usage

The script (`main.rb`) takes input through standard input and gives the result to standard output.

Following commands can be executed at the top level of this repository.

```sh
$ cat README.md | bin/m2h
```

## Test

```sh
$ ruby test.rb
```

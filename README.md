# Reverse Engineering with AI

An [mdBook](https://rust-lang.github.io/mdBook/) about practical AI-assisted reverse engineering, written by a human.

## Read locally

Easiest path: Install [Nix](https://nixos.org/download/) and [devenv](https://devenv.sh/getting-started/). Then start the live-reloading server:

```sh
devenv shell book-serve
```

## Build and check

Build the book into `book/`:

```sh
devenv shell book-build
```

Run the same check used by CI:

```sh
devenv test
```

# What this is

I wrote this to investigate https://github.com/coq/coq/issues/11107 and compare
performance of Coq compiled in different ways; if you don't know what that is,
you don't care.

## Instructions

Beware no warranty. Please be familiar with `bash` and read stuff before executing it.

Also, these benchmark create new opam switches (with hardcoded names) and add opam repos for testing.

In short:

0. install `opam`
1. setup with `./harness-create.sh` to create the needed switches;
2. just run `./harness.sh`.

Or read those scripts, and run the parts you need.

# What this is

I wrote this to investigate https://github.com/coq/coq/issues/11107 and compare
performance of Coq compiled in different ways; if you don't know what that is,
you don't care.

## Instructions

Beware no warranty. Please be familiar with `bash` and read stuff before executing it.

Also, these benchmark create new opam switches (with hardcoded names) and add opam repos for testing.

In short, just run `./harness.sh`. Or read it, and run the parts you need.

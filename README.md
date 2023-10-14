# Roc TinyVG

A graphics library for the Roc programming language implementing the [Tiny Vector Graphics format](https://tinyvg.tech).

## Status

In-development -- WIP to support the [roc-graphics-mach experimental platform](https://github.com/lukewilliamboswell/roc-graphics-mach)

## Examples 

Build the examples using `bash build.sh`, you should see `.tvgt` and `.svg` files in the `examples/` directory. 

> Note that you will need `tvg-text` available on your PATH to build the examples.

## Documentation

To generate locally use `roc docs package/main.roc` and then open a file server in the `generated-docs/` directory.

## Package

To bundle into a package use `roc build --bundle .tar.br package/main.roc`

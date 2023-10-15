# Roc TinyVG

A graphics library for the Roc programming language implementing the [Tiny Vector Graphics format](https://tinyvg.tech).

## Status

In-development -- WIP to support the [roc-graphics-mach experimental platform](https://github.com/lukewilliamboswell/roc-graphics-mach)

If there is anything you would like to add raise an issue and/or a PR. Please review the [TinyVG text format](https://github.com/TinyVG/specification/blob/main/text-format.md) and the [examples](https://github.com/TinyVG/examples/blob/main/files/everything-32.tvgt) which are helpful for writing tests.

## Examples 

You can build all the examples using `bash examples.sh`, you should see `.tvgt` and `.svg` files in the `examples/` directory. 

> Note that you will need `tvg-text` available on your PATH to build the examples.

## Documentation

Hosted on GitHub pages site at [https://lukewilliamboswell.github.io/roc-tinvyvg/](https://lukewilliamboswell.github.io/roc-tinvyvg/)

To generate locally use `roc docs package/main.roc` and then open a file server in the `generated-docs/` directory.

## Package

To bundle into a package use `roc build --bundle .tar.br package/main.roc` and then host the resulting `.tar.br` file on a web server.

# Drawing

The code below is an example which draws the roc-lang purple bird logo on a white square background. 

```roc
graphic : Graphic
graphic = 
    g0 = Graphic.graphic {}
    g1, white <- g0 |> Graphic.addColor (Color.fromBasic White)
    g2, purple <- g1 |> Graphic.addColor (Color.rocPurple)

    # Draws the white square background
    whiteSquare = Command.fillPath (Style.flat white) {x : 0, y : 0 } [
        PathNode.line { x: 100, y: 0 },
        PathNode.line { x: 100, y: 100 },
        PathNode.line { x: 0, y: 100 },
        PathNode.close {},
    ]

    # Draws the roc-lang bird logo
    rocBird = Command.fillPath (Style.flat purple) {x : 24.75, y : 23.5 } [
        PathNode.line { x: 48.633, y: 26.711 },
        PathNode.line { x: 61.994, y: 42.51 },
        PathNode.line { x: 70.716, y: 40.132 },
        PathNode.line { x: 75.25, y: 45.5 },
        PathNode.line { x: 69.75, y: 45.5 },
        PathNode.line { x: 68.782, y: 49.869 },
        PathNode.line { x: 51.217, y: 62.842 },
        PathNode.line { x: 52.203, y: 68.713 },
        PathNode.line { x: 42.405, y: 76.5 },
        PathNode.line { x: 48.425, y: 46.209 },
        PathNode.close {},
    ]
    
    g2
    |> Graphic.addCommand whiteSquare
    |> Graphic.addCommand rocBird
```
app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        tvg: "../package/main.roc",
    }
    imports [
        pf.Stdout,
        tvg.Graphic.{ Graphic },
        tvg.Color,
        tvg.Style,
        tvg.Command,
    ]
    provides [main] to pf

main =

    graphic : Graphic
    graphic =
        g0 = Graphic.graphic {}
        g1, orange <- g0 |> Graphic.addColor (Color.fromBasic Orange)
        g2, black <- g1 |> Graphic.addColor (Color.fromBasic Black)
        g3, green <- g2 |> Graphic.addColor (Color.fromBasic Green)
        g4, cyan <- g3 |> Graphic.addColor (Color.fromBasic Cyan)
        g5, sea <- g4 |> Graphic.addColor (Color.fromBasic Sea)

        # helper to draw a square
        mySquare = \color, x, y ->
            Command.outlineFillRectangles
                {
                    fillStyle: Style.flat color,
                    lineStyle: Style.radial (15, 15) (0, 0) black cyan,
                    lw: Set 1,
                }
                [
                    { x, y, width: 10, height: 10 },
                ]

        g5
        |> Graphic.addCommand (mySquare orange 10 10)
        |> Graphic.addCommand (mySquare sea 15 15)
        |> Graphic.addCommand (mySquare green 20 20)

    graphic
    |> Graphic.toStr
    |> Stdout.line

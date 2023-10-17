app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        tvg: "../package/main.roc",
    }
    imports [
        pf.Stdout,
        pf.Path,
        pf.File,
        pf.Task,
        tvg.Graphic.{ Graphic },
        tvg.Color,
        tvg.Style,
        tvg.Command,
        tvg.PathNode,
    ]
    provides [main] to pf

main =

    graphic : Graphic
    graphic =
        g1, blue <- Graphic.applyColor (Graphic.graphic {}) (Color.fromBasic Blue)

        rectStyle = Style.flat blue

        rect = Command.fillRectangles rectStyle [{ x: 0, y: 0, width: 10, height: 20 }]

        g1
        |> Graphic.addCommand rect

    path = Path.fromStr "examples/filled_rectangle.tvgt"
    tvgText = Graphic.toText graphic

    result <- File.writeUtf8 path tvgText |> Task.attempt
    when result is
        Ok {} -> Stdout.line "TinVG text format copied to filled_rectangle.tvgt"
        Err _ -> Stdout.line "ERROR: Failed to write TinVG text format to filled_rectangle.tvgt"

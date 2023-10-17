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
        g0 = Graphic.graphic {
            width: 400,
            height: 400,
        }
        g1, purple <- g0 |> Graphic.applyColor (Color.fromBasic Purple)
        g2, green <- g1 |> Graphic.applyColor (Color.fromBasic Green)

        # draw a series of vertical lines
        lines = Command.drawLines
            {
                style: Style.radial (325, 210) (375, 235) purple green,
                lw: Set 2.5,
            }
            [
                ({ x: 275, y: 185 }, { x: 375, y: 195 }),
                ({ x: 275, y: 195 }, { x: 375, y: 205 }),
                ({ x: 275, y: 205 }, { x: 375, y: 215 }),
                ({ x: 275, y: 215 }, { x: 375, y: 225 }),
            ]

        g2
        |> Graphic.addCommand lines

    path = Path.fromStr "examples/draw_lines.tvgt"
    tvgText = Graphic.toText graphic

    result <- File.writeUtf8 path tvgText |> Task.attempt
    when result is
        Ok {} -> Stdout.line "TinVG text format copied to draw_lines.tvgt"
        Err _ -> Stdout.line "ERROR: Failed to write TinVG text format to draw_lines.tvgt"

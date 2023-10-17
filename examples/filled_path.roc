app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        tvg: "../package/main.roc"
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
        g0 = Graphic.graphic {}
        g1, white <- g0 |> Graphic.applyColor (Color.fromBasic White)
        g2, purple <- g1 |> Graphic.applyColor (Color.rocPurple)

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
    
    path = Path.fromStr "examples/filled_path.tvgt"
    tvgText = Graphic.toText graphic

    result <- File.writeUtf8 path tvgText |> Task.attempt
    when result is 
        Ok {} -> Stdout.line "TinVG text format copied to filled_path.tvgt"
        Err _ -> Stdout.line "ERROR: Failed to write TinVG text format to filled_path.tvgt"

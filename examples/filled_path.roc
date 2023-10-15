app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        tvg: "../package/main.roc"
    }
    imports [
        pf.Stdout,
        tvg.Graphic.{Graphic},
        tvg.Color,
        tvg.Style,
        tvg.Command,
        tvg.PathNode,
    ]
    provides [main] to pf

main = 

    graphic : Graphic
    graphic = 
        g1, purple <- Graphic.addColor (Graphic.graphic {}) (Color.rocPurple)

        # Draws the roc-lang bird logo
        rocBird = Command.fillPath (Style.flat purple) {x : 24.75, y : 23.5 } [
            PathNode.line { lw: NoChange, x: 48.633, y: 26.711 },
            PathNode.line { lw: NoChange, x: 61.994, y: 42.51 },
            PathNode.line { lw: NoChange, x: 70.716, y: 40.132 },
            PathNode.line { lw: NoChange, x: 75.25, y: 45.5 },
            PathNode.line { lw: NoChange, x: 69.75, y: 45.5 },
            PathNode.line { lw: NoChange, x: 68.782, y: 49.869 },
            PathNode.line { lw: NoChange, x: 51.217, y: 62.842 },
            PathNode.line { lw: NoChange, x: 52.203, y: 68.713 },
            PathNode.line { lw: NoChange, x: 42.405, y: 76.5 },
            PathNode.line { lw: NoChange, x: 48.425, y: 46.209 },
            PathNode.close { lw: NoChange },
        ]
        
        Graphic.addCommand g1 rocBird
    
    graphic 
    |> Graphic.toStr 
    |> Stdout.line
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
    ]
    provides [main] to pf

main = 

    graphic : Graphic
    graphic = 
        g1, whiteId <- Graphic.addColor (Graphic.graphic {}) (Color.fromBasic White)

        rectStyle = Style.flat whiteId
        
        Graphic.addCommand g1 (Command.fillRectangles rectStyle [{x: 10, y: 15, width: 50, height: 12}])
    
    graphic 
    |> Graphic.toStr 
    |> Stdout.line
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
        g1, _whiteId <- Graphic.addColor (Graphic.graphic {}) (Color.fromBasic White)

        g2, purpleId <- Graphic.addColor g1 (Color.fromBasic Purple)

        rectStyle = Style.flat purpleId
        
        Graphic.addCommand g2 (Command.fillRectangles rectStyle [{x: 0, y: 0, width: 10, height: 20}])
    
    graphic 
    |> Graphic.toStr 
    |> Stdout.line
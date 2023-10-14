app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        tvg: "../package/main.roc"
    }
    imports [
        pf.Stdout,
        tvg.Graphic.{Graphic},
        tvg.Style,
        tvg.Simple,
        tvg.Color.{Color},
    ]
    provides [main] to pf

main = 

    purple : Color
    purple = Color.fromBasic Purple

    graphic : Graphic
    graphic = Simple.box purple {x: 10, y: 15, width: 50, height: 12}
    
    tvgt : Str
    tvgt = Graphic.toStr graphic
    
    Stdout.line tvgt
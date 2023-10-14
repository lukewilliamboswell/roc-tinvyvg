# Common shapes with a simple API to get started
interface Simple
    exposes [
        box,
    ]
    imports [
        Command,
        Style.{Style},
        Color.{Color},
        Graphic.{Graphic},
    ]

box : Color, {x: U32, y: U32, width: U32, height: U32} -> Graphic
box = \color, ps ->
    g1, colorId <- Graphic.graphic {} |> Graphic.addColor color

    rectStyle : Style    
    rectStyle = Style.flat colorId
    
    g1 |> Graphic.addCommand (Command.fillRectangles rectStyle [ps])
    
expect 
    g = box (Color.fromBasic Red) {x: 0, y: 0, width: 100, height: 100} 
    
    Graphic.colors g == [Color.fromBasic Red]
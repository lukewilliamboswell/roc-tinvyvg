interface Graphic
    exposes [
        Graphic,
        graphic,
        toStr,
        colors,
        addColor,
        addCommand,
    ]
    imports [
        Color.{Color, ColorEncoding},
        Command.{Command},
    ]

# Each Unit takes up 8/16/32 bits
Precision : [Default, Reduced, Enhanced]

Graphic := {
    width : U16,
    height : U16,
    scale : U8,
    format : ColorEncoding,
    precision : Precision,
    colorTable : List Color,
    commands : List Command,
}

graphic : {
    width ? U16,
    height ? U16,
    scale ? U8,
    format ? ColorEncoding,
    precision ? Precision,
} -> Graphic
graphic = \{width ? 100, height ? 100, scale ? 1, format ? RGBA8888, precision ? Default} ->
    @Graphic {width, height, scale, format, precision, colorTable: [], commands: []}

addColor : Graphic, Color, (Graphic, U32 -> Graphic) -> Graphic
addColor = \@Graphic data, color, continueFn ->
    
    id = List.len data.colorTable |> Num.toU32
    g = @Graphic {data & colorTable: List.append data.colorTable color}

    continueFn g id

colors : Graphic -> List Color
colors = \@Graphic {colorTable} -> colorTable

addCommand : Graphic, Command -> Graphic
addCommand = \@Graphic data, command ->
    @Graphic {data & commands: List.append data.commands command}

toStr : Graphic -> Str
toStr = \g ->
    headerStr = headerToStr g
    colorTableStr = colorTableToStr g
    commandsStr = commandsToStr g 

    "(tvg 1 \(headerStr)\(colorTableStr)\(commandsStr))"

headerToStr : Graphic -> Str
headerToStr = \@Graphic {width, height, scale, format, precision} ->

    # TODO support other scales
    scaleToStr =
        when scale is 
            _ -> "1/1" 
    
    # TODO support other formats
    formatToStr =
        when format is 
            _ -> "u8888" 

    # TODO support other precisions
    precisionToStr =
        when precision is 
            _ -> "default" 

    [
        "(",
        Num.toStr width,
        " ",
        Num.toStr height,
        " ",
        scaleToStr,
        " ",
        formatToStr,
        " ",
        precisionToStr,
        ")",
    ]
    |> Str.joinWith ""

colorTableToStr : Graphic -> Str
colorTableToStr = \@Graphic data ->
    
    tvgtColors = 
        data.colorTable 
        |> List.map \c -> Color.toTvgt c data.format
        |> Str.joinWith ""

    "(\(tvgtColors))"

commandsToStr : Graphic -> Str 
commandsToStr = \@Graphic data -> 
    
    tvgtCommands = 
        data.commands 
        |> List.map Command.toTvgt 
        |> Str.joinWith ""

    "(\(tvgtCommands))"

# Test header is correct for default values 
expect headerToStr (graphic {}) == "(100 100 1/1 u8888 default)"

# Test adding two colors
expect 
    g = 
        g1, _ <- graphic {} |> addColor (Color.fromBasic White)
        g2, _ <- addColor g1 (Color.fromBasic Purple)
        
        g2
    
    colorTableToStr g == "((1.0 1.0 1.0 1.0)(0.49 0.0 1.0 1.0))"

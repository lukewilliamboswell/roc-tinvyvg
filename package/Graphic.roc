interface Graphic
    exposes [
        Graphic,
        graphic,
        toText,
        applyColor,
        addCommand,
    ]
    imports [
        Color.{Color, ColorEncoding},
        Command.{Command},
    ]

# Each Unit takes up 8/16/32 bits
Precision : [Default, Reduced, Enhanced]

## A TVG graphic
Graphic := {
    width : U16,
    height : U16,
    scale : U8,
    format : ColorEncoding,
    precision : Precision,
    colorTable : List Color,
    commands : List Command,
}

## Create a new graphic with the given options.
##
## ```
## graphic {} # Produces a 100x100 graphic, 1/1 scale, u8888 encoding, default precision
## ```
graphic : {
    width ? U16,
    height ? U16,
    scale ? U8,
    format ? ColorEncoding,
    precision ? Precision,
} -> Graphic
graphic = \{width ? 100, height ? 100, scale ? 1, format ? RGBA8888, precision ? Default} ->
    @Graphic {width, height, scale, format, precision, colorTable: [], commands: []}

## Adds a color to the graphic and returns the updated graphic and the color's index
## which is required for styling
##
## ```
## g0 = Graphic.graphic {}
## g1, white <- g0 |> Graphic.applyColor (Color.fromBasic White)
## g2, purple <- g1 |> Graphic.applyColor (Color.rocPurple)
## ```
## This is an example to add two colors.
applyColor : Graphic, Color, (Graphic, U32 -> Graphic) -> Graphic
applyColor = \@Graphic data, color, continueFn ->
    
    id = List.len data.colorTable |> Num.toU32
    g = @Graphic {data & colorTable: List.append data.colorTable color}

    continueFn g id

## Adds a draw command to the graphic
addCommand : Graphic, Command -> Graphic
addCommand = \@Graphic data, command ->
    @Graphic {data & commands: List.append data.commands command}

## Build TVG text format from a graphic
toText : Graphic -> Str
toText = \g ->
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
        |> List.map \c -> Color.toText c data.format
        |> Str.joinWith ""

    "(\(tvgtColors))"

commandsToStr : Graphic -> Str 
commandsToStr = \@Graphic data -> 
    
    tvgtCommands = 
        data.commands 
        |> List.map Command.toText 
        |> Str.joinWith ""

    "(\(tvgtCommands))"

# Test header is correct for default values 
expect headerToStr (graphic {}) == "(100 100 1/1 u8888 default)"

# Test adding two colors
expect 
    g = 
        g1, _ <- graphic {} |> applyColor (Color.fromBasic White)
        g2, _ <- applyColor g1 (Color.fromBasic Purple)
        
        g2
    
    colorTableToStr g == "((1.0 1.0 1.0 1.0)(0.49 0.0 1.0 1.0))"

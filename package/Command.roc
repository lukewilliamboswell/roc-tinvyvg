## Low-level drawing commands for TinyVG 
interface Command
    exposes [
        Command,
        fillRectangles,
        toTvgt,
    ]
    imports [
        Style.{Style},
    ]

PositionSize : { x: U32, y: U32, width: U32, height: U32}

Command := [
        FillRectangles Style (List PositionSize),
    ] implements [Eq { isEq: isEq }]

isEq : Command, Command -> Bool
isEq = \@Command first, @Command second -> first == second

fillRectangles : Style, List PositionSize -> Command
fillRectangles = \style, rects -> @Command (FillRectangles style rects)

toTvgt : Command -> Str
toTvgt = \@Command command ->
    when command is 
        FillRectangles style ps -> "(fill_rectangles \(Style.toTvgt style) (\(ps |> List.map positionSizeToTvgt |> Str.joinWith "")))"

positionSizeToTvgt : PositionSize -> Str
positionSizeToTvgt = \{x,y,width, height} ->
    "(\(Num.toStr x) \(Num.toStr y) \(Num.toStr width) \(Num.toStr height))"

testStyle1 = Style.flat 43

expect fillRectangles testStyle1 [] == @Command (FillRectangles testStyle1 [])
expect positionSizeToTvgt { x: 0, y: 12, width: 3442, height: 1} == "(0 12 3442 1)"
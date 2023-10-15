## Low-level drawing commands for TinyVG 
interface Command
    exposes [
        Command,
        fillRectangles,
        toTvgt,
    ]
    imports [
        Style.{Style},
        PathNode.{PathNode},
    ]

PositionSize : { x: U32, y: U32, width: U32, height: U32}
Position : {x : U32, y : U32 }

Command := [
        FillRectangles Style (List PositionSize),
        FillPath Style Position (List PathNode),
    ] implements [Eq { isEq: isEq }]

isEq : Command, Command -> Bool
isEq = \@Command first, @Command second -> first == second

fillRectangles : Style, List PositionSize -> Command
fillRectangles = \style, rects -> @Command (FillRectangles style rects)

fillPath : Style, Position, List PathNode -> Command
fillPath = \style, position, nodes -> @Command (FillPath style position nodes)

toTvgt : Command -> Str
toTvgt = \@Command command ->
    when command is 
        FillRectangles style ps -> "(fill_rectangles \(Style.toTvgt style) (\(ps |> List.map positionSizeToTvgt |> Str.joinWith "")))"
        FillPath style position nodes -> "(fill_path \(Style.toTvgt style) (\(positionToTvgt position) (\(nodes |> List.map PathNode.toTvgt |> Str.joinWith ""))))"

positionSizeToTvgt : PositionSize -> Str
positionSizeToTvgt = \{x,y,width, height} ->
    "(\(Num.toStr x) \(Num.toStr y) \(Num.toStr width) \(Num.toStr height))"

positionToTvgt : Position -> Str
positionToTvgt = \{x,y} ->
    "(\(Num.toStr x) \(Num.toStr y))"

testStyle1 = Style.flat 43
testStyle2 = Style.radial (325, 610) (375, 635) 1 2

expect fillRectangles testStyle1 [] == @Command (FillRectangles testStyle1 [])
expect positionSizeToTvgt { x: 0, y: 12, width: 3442, height: 1} == "(0 12 3442 1)"
expect 
    fillPath testStyle2 {x : 275, y : 585 } [
        PathNode.horizontal { lw: NoChange, x: 285 },
        PathNode.vertical { lw: NoChange, y: 595 },
        PathNode.line { lw: NoChange, x: 375, y: 585 },
        PathNode.bezier { lw: NoChange, x1: 350, y1: 605, x2: 365, y2: 635, x3: 350, y3: 635 },
        PathNode.quadraticBezier { lw: NoChange, x1: 325, y1: 635, x2: 325, y2: 610 },
        PathNode.arcEllipse { lw: NoChange, radiusX: 35, radiusY: 50, angle: 1.5, largeArc: Bool.false, sweep: Bool.true, x: 300, y: 620 },
        PathNode.arcCircle { lw: NoChange, radius: 14, largeArc: Bool.false, sweep: Bool.false, x: 275, y: 610 },
        PathNode.close { lw: NoChange },
    ] |> toTvgt == "(fill_path (radial (325 610) (375 635) 1 2) ((275 585) ((horiz - 285)(vert - 595)(line - 375 585)(bezier - (350 605) (365 635) (350 635))(quadratic_bezier - (325 635) (325 610))(arc_ellipse - 35 50 1.5 false true (300 620))(arc_circle - 14 false false (275 610))(close -))))"
## Low-level drawing commands for TinyVG
interface Command
    exposes [
        Command,
        fillRectangles,
        fillPath,
        outlineFillRectangles,
        drawLines,
        toText,
    ]
    imports [
        Style.{ Style },
        ColorIndex.{ ColorIndex },
        PathNode.{ PathNode, LineWidth, lineWidthToTvgt },
    ]

PositionSize : { x : Dec, y : Dec, width : Dec, height : Dec }
Position : { x : Dec, y : Dec }

## Represent a drawing command such as DrawLines or FillRectangles.
Command := [
    FillRectangles Style (List PositionSize),
    FillPath Style Position (List PathNode),
    OutlineFillRectangles Style Style LineWidth (List PositionSize),
    DrawLines Style LineWidth (List (Position, Position)),
]
    implements [Eq { isEq: isEq }]

isEq : Command, Command -> Bool
isEq = \@Command first, @Command second -> first == second

## Fill a list of rectangles with a style.
fillRectangles : Style, List PositionSize -> Command
fillRectangles = \style, rects -> @Command (FillRectangles style rects)

## Fill a path with a style.
fillPath : Style, Position, List PathNode -> Command
fillPath = \style, position, nodes -> @Command (FillPath style position nodes)

## Fill a list of rectangles with a style and outline them with another style.
outlineFillRectangles : { fillStyle : Style, lineStyle : Style, lw ? LineWidth }, List PositionSize -> Command
outlineFillRectangles = \{ fillStyle, lineStyle, lw ? NoChange }, rects ->
    @Command (OutlineFillRectangles fillStyle lineStyle lw rects)

## Draw a list of lines with a style.
drawLines : { style : Style, lw ? LineWidth }, List (Position, Position) -> Command
drawLines = \{ style, lw ? NoChange }, segments ->
    @Command (DrawLines style lw segments)

## Build TVG text format string
toText : Command -> Str
toText = \@Command command ->
    when command is
        FillRectangles style ps -> "(fill_rectangles \(Style.toText style) (\(ps |> List.map positionSizeToTvgt |> Str.joinWith "")))"
        FillPath style position nodes -> "(fill_path \(Style.toText style) (\(positionToTvgt position) (\(nodes |> List.map PathNode.toText |> Str.joinWith ""))))"
        OutlineFillRectangles fillStyle lineStyle lw rects -> "(outline_fill_rectangles \(Style.toText fillStyle) \(Style.toText lineStyle) \(lineWidthToTvgt lw) (\(rects |> List.map positionSizeToTvgt |> Str.joinWith "")))"
        DrawLines style lw segments -> "(draw_lines \(Style.toText style) \(lineWidthToTvgt lw) (\(segments |> List.map lineSegmentToTvgt |> Str.joinWith " ")))"

positionSizeToTvgt : PositionSize -> Str
positionSizeToTvgt = \{ x, y, width, height } ->
    "(\(Num.toStr x) \(Num.toStr y) \(Num.toStr width) \(Num.toStr height))"

positionToTvgt : Position -> Str
positionToTvgt = \{ x, y } ->
    "(\(Num.toStr x) \(Num.toStr y))"

lineSegmentToTvgt : (Position, Position) -> Str
lineSegmentToTvgt = \({ x: x1, y: y1 }, { x: x2, y: y2 }) ->
    "((\(Num.toStr x1) \(Num.toStr y1)) (\(Num.toStr x2) \(Num.toStr y2)))"

expect lineSegmentToTvgt ({ x: 275, y: 185 }, { x: 375, y: 195 }) == "((275.0 185.0) (375.0 195.0))"

testStyle1 = Style.flat (ColorIndex.fromU32 43)
testStyle2 = Style.radial (325, 610) (375, 635) (ColorIndex.fromU32 1) (ColorIndex.fromU32 2)

expect fillRectangles testStyle1 [] == @Command (FillRectangles testStyle1 [])
expect positionSizeToTvgt { x: 0, y: 12, width: 3442, height: 1 } == "(0.0 12.0 3442.0 1.0)"

# test fillPath
expect
    fillPath testStyle2 { x: 275, y: 585 } [
        PathNode.horizontal { lw: NoChange, x: 285 },
        PathNode.vertical { lw: NoChange, y: 595 },
        PathNode.line { lw: NoChange, x: 375, y: 585 },
        PathNode.bezier { lw: NoChange, x1: 350, y1: 605, x2: 365, y2: 635, x3: 350, y3: 635 },
        PathNode.quadraticBezier { lw: NoChange, x1: 325, y1: 635, x2: 325, y2: 610 },
        PathNode.arcEllipse { lw: NoChange, radiusX: 35, radiusY: 50, angle: 1.5, largeArc: Bool.false, sweep: Bool.true, x: 300, y: 620 },
        PathNode.arcCircle { lw: NoChange, radius: 14, largeArc: Bool.false, sweep: Bool.false, x: 275, y: 610 },
        PathNode.close { lw: NoChange },
    ]
    |> toText
    == "(fill_path (radial (325.0 610.0) (375.0 635.0) 1 2) ((275.0 585.0) ((horiz - 285.0)(vert - 595.0)(line - 375.0 585.0)(bezier - (350.0 605.0) (365.0 635.0) (350.0 635.0))(quadratic_bezier - (325.0 635.0) (325.0 610.0))(arc_ellipse - 35.0 50.0 1.5 false true (300.0 620.0))(arc_circle - 14.0 false false (275.0 610.0))(close -))))"

# test outlineFillRectangles
expect
    s1 = Style.radial (325, 130) (375, 155) (ColorIndex.fromU32 1) (ColorIndex.fromU32 2)
    s2 = Style.flat (ColorIndex.fromU32 3)
    a =
        outlineFillRectangles { fillStyle: s1, lineStyle: s2, lw: Set 2.5 } [
            { x: 275, y: 105, width: 100, height: 15 },
            { x: 275, y: 125, width: 100, height: 15 },
            { x: 275, y: 145, width: 100, height: 15 },
        ]
        |> toText
    a == "(outline_fill_rectangles (radial (325.0 130.0) (375.0 155.0) 1 2) (flat 3) 2.5 ((275.0 105.0 100.0 15.0)(275.0 125.0 100.0 15.0)(275.0 145.0 100.0 15.0)))"

# test drawLines
expect
    style = Style.radial (325, 210) (375, 235) (ColorIndex.fromU32 1) (ColorIndex.fromU32 2)
    lw = Set 2.5
    a =
        drawLines { style, lw } [
            ({ x: 275, y: 185 }, { x: 375, y: 195 }),
            ({ x: 275, y: 195 }, { x: 375, y: 205 }),
            ({ x: 275, y: 205 }, { x: 375, y: 215 }),
            ({ x: 275, y: 215 }, { x: 375, y: 225 }),
        ]
        |> toText
    a == "(draw_lines (radial (325.0 210.0) (375.0 235.0) 1 2) 2.5 (((275.0 185.0) (375.0 195.0)) ((275.0 195.0) (375.0 205.0)) ((275.0 205.0) (375.0 215.0)) ((275.0 215.0) (375.0 225.0))))"

interface PathNode
    exposes [
        PathNode,
        LineWidth,
        horizontal,
        vertical,
        line,
        bezier,
        quadraticBezier,
        arcEllipse,
        arcCircle,
        close,
        toTvgt,
    ]
    imports []

# (horiz <line_width> <x>)
# (vert <line_width> <y>)
# (line <line_width> <x> <y>)
# (bezier <line_width> (<x> <y>) (<x> <y>) (100<x> <y>))
# (quadratic_bezier <line_width> (<x> <y>) (<x> <y>))
# (arc_ellipse <line_width> <radius_x> <radius_y> <angle> <large_arc> <sweep> (<x> <y>))
# (arc_circle <line_width> <radius> <large_arc> <sweep> (<x> <y>))
# (close <line_width>)
PathNode := [
    Horizontal LineWidth U32,
    Vertical LineWidth U32,
    Line LineWidth (U32, U32),
    Bezier LineWidth (U32, U32) (U32, U32) (U32, U32),
    QuadraticBezier LineWidth (U32, U32) (U32, U32),
    ArcEllipse LineWidth U32 U32 Dec Bool Bool (U32, U32),
    ArcCircle LineWidth U32 Bool Bool (U32, U32),
    Close LineWidth,
] implements [Eq { isEq: isEq }]

isEq : PathNode, PathNode -> Bool
isEq = \@PathNode first, @PathNode second -> first == second

LineWidth : [NoChange, Set U32]

horizontal : { lw : LineWidth, x : U32 } -> PathNode
horizontal = \{ lw, x } -> @PathNode (Horizontal lw x)

vertical : { lw : LineWidth, y : U32 } -> PathNode
vertical = \{ lw, y } -> @PathNode (Vertical lw y)

line : { lw : LineWidth, x : U32, y : U32 } -> PathNode
line = \{ lw, x, y } -> @PathNode (Line lw (x, y))

bezier : { lw : LineWidth, x1 : U32, y1 : U32, x2 : U32, y2 : U32, x3 : U32, y3 : U32 } -> PathNode
bezier = \{ lw, x1, y1, x2, y2, x3, y3 } -> @PathNode (Bezier lw (x1, y1) (x2, y2) (x3, y3))

quadraticBezier : { lw : LineWidth, x1 : U32, y1 : U32, x2 : U32, y2 : U32 } -> PathNode
quadraticBezier = \{ lw, x1, y1, x2, y2 } -> @PathNode (QuadraticBezier lw (x1, y1) (x2, y2))

arcEllipse : { lw : LineWidth, radiusX : U32, radiusY : U32, angle : Dec, largeArc : Bool, sweep : Bool, x : U32, y : U32 } -> PathNode
arcEllipse = \{ lw, radiusX, radiusY, angle, largeArc, sweep, x, y } -> @PathNode (ArcEllipse lw radiusX radiusY angle largeArc sweep (x, y))

arcCircle : { lw : LineWidth, radius : U32, largeArc : Bool, sweep : Bool, x : U32, y : U32 } -> PathNode
arcCircle = \{ lw, radius, largeArc, sweep, x, y } -> @PathNode (ArcCircle lw radius largeArc sweep (x, y))

close : { lw : LineWidth } -> PathNode
close = \{ lw } -> @PathNode (Close lw)

lineWidthToTvgt : LineWidth -> Str
lineWidthToTvgt = \lw ->
    when lw is
        NoChange -> "-"
        Set u32 -> Num.toStr u32

boolToStr : Bool -> Str
boolToStr = \b -> if b then "true" else "false"

toTvgt : PathNode -> Str
toTvgt = \@PathNode pn ->
    when pn is
        Horizontal lw x -> "(horiz \(lineWidthToTvgt lw) \(Num.toStr x))"
        Vertical lw y -> "(vert \(lineWidthToTvgt lw) \(Num.toStr y))"
        Line lw (x,y) -> "(line \(lineWidthToTvgt lw) \(Num.toStr x) \(Num.toStr y))"
        Bezier lw (x1,y1) (x2,y2) (x3,y3) -> "(bezier \(lineWidthToTvgt lw) (\(Num.toStr x1) \(Num.toStr y1)) (\(Num.toStr x2) \(Num.toStr y2)) (\(Num.toStr x3) \(Num.toStr y3)))"
        QuadraticBezier lw (x1,y1) (x2,y2) -> "(quadratic_bezier \(lineWidthToTvgt lw) (\(Num.toStr x1) \(Num.toStr y1)) (\(Num.toStr x2) \(Num.toStr y2)))"
        ArcEllipse lw radiusX radiusY angle largeArc sweep (x,y) -> "(arc_ellipse \(lineWidthToTvgt lw) \(Num.toStr radiusX) \(Num.toStr radiusY) \(Num.toStr angle) \(boolToStr largeArc) \(boolToStr sweep) (\(Num.toStr x) \(Num.toStr y)))"
        ArcCircle lw radius largeArc sweep (x,y) -> "(arc_circle \(lineWidthToTvgt lw) \(Num.toStr radius) \(boolToStr largeArc) \(boolToStr sweep) (\(Num.toStr x) \(Num.toStr y)))"
        Close lw -> "(close \(lineWidthToTvgt lw))"

expect horizontal { lw: NoChange, x: 285 } |> toTvgt == "(horiz - 285)"
expect vertical { lw: NoChange, y: 670 } |> toTvgt == "(vert - 670)"
expect line { lw: NoChange, x: 375, y: 660 } |> toTvgt == "(line - 375 660)"
expect 
    bezier { lw: NoChange, x1: 350, y1: 680, x2: 365, y2: 710, x3: 350, y3: 710 } 
    |> toTvgt == "(bezier - (350 680) (365 710) (350 710))"

expect 
    quadraticBezier { lw: NoChange, x1: 325, y1: 710, x2: 325, y2: 685 } 
    |> toTvgt == "(quadratic_bezier - (325 710) (325 685))"

expect 
    arcEllipse { lw: Set 20, radiusX: 35, radiusY: 50, angle: 1.5, largeArc: Bool.false, sweep: Bool.true, x: 300, y: 695 }
    |> toTvgt == "(arc_ellipse 20 35 50 1.5 false true (300 695))"

expect 
    arcCircle { lw: NoChange, radius: 14, largeArc: Bool.false, sweep: Bool.false, x: 275, y: 685 }
    |> toTvgt == "(arc_circle - 14 false false (275 685))"

expect close { lw: NoChange } |> toTvgt == "(close -)"

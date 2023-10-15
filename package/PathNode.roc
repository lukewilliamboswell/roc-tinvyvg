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
    Horizontal LineWidth Dec,
    Vertical LineWidth Dec,
    Line LineWidth (Dec, Dec),
    Bezier LineWidth (Dec, Dec) (Dec, Dec) (Dec, Dec),
    QuadraticBezier LineWidth (Dec, Dec) (Dec, Dec),
    ArcEllipse LineWidth Dec Dec Dec Bool Bool (Dec, Dec),
    ArcCircle LineWidth Dec Bool Bool (Dec, Dec),
    Close LineWidth,
] implements [Eq { isEq: isEq }]

isEq : PathNode, PathNode -> Bool
isEq = \@PathNode first, @PathNode second -> first == second

LineWidth : [NoChange, Set Dec]

horizontal : { lw ? LineWidth, x : Dec } -> PathNode
horizontal = \{ lw ? NoChange, x } -> @PathNode (Horizontal lw x)

vertical : { lw ? LineWidth, y : Dec } -> PathNode
vertical = \{ lw ? NoChange, y } -> @PathNode (Vertical lw y)

line : { lw ? LineWidth, x : Dec, y : Dec } -> PathNode
line = \{ lw ? NoChange, x, y } -> @PathNode (Line lw (x, y))

bezier : { lw ? LineWidth, x1 : Dec, y1 : Dec, x2 : Dec, y2 : Dec, x3 : Dec, y3 : Dec } -> PathNode
bezier = \{ lw ? NoChange, x1, y1, x2, y2, x3, y3 } -> @PathNode (Bezier lw (x1, y1) (x2, y2) (x3, y3))

quadraticBezier : { lw ? LineWidth, x1 : Dec, y1 : Dec, x2 : Dec, y2 : Dec } -> PathNode
quadraticBezier = \{ lw ? NoChange, x1, y1, x2, y2 } -> @PathNode (QuadraticBezier lw (x1, y1) (x2, y2))

arcEllipse : { lw ? LineWidth, radiusX : Dec, radiusY : Dec, angle : Dec, largeArc : Bool, sweep : Bool, x : Dec, y : Dec } -> PathNode
arcEllipse = \{ lw ? NoChange, radiusX, radiusY, angle, largeArc, sweep, x, y } -> @PathNode (ArcEllipse lw radiusX radiusY angle largeArc sweep (x, y))

arcCircle : { lw ? LineWidth, radius : Dec, largeArc : Bool, sweep : Bool, x : Dec, y : Dec } -> PathNode
arcCircle = \{ lw ? NoChange, radius, largeArc, sweep, x, y } -> @PathNode (ArcCircle lw radius largeArc sweep (x, y))

close : { lw ? LineWidth } -> PathNode
close = \{ lw ? NoChange } -> @PathNode (Close lw)

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

expect horizontal { x: 285 } |> toTvgt == "(horiz - 285.0)"
expect vertical { y: 670 } |> toTvgt == "(vert - 670.0)"
expect line { x: 375, y: 660 } |> toTvgt == "(line - 375.0 660.0)"
expect 
    bezier { x1: 350, y1: 680, x2: 365, y2: 710, x3: 350, y3: 710 } 
    |> toTvgt == "(bezier - (350.0 680.0) (365.0 710.0) (350.0 710.0))"

expect 
    quadraticBezier { x1: 325, y1: 710, x2: 325, y2: 685 } 
    |> toTvgt == "(quadratic_bezier - (325.0 710.0) (325.0 685.0))"

expect 
    arcEllipse { lw: Set 20, radiusX: 35, radiusY: 50, angle: 1.5, largeArc: Bool.false, sweep: Bool.true, x: 300, y: 695 }
    |> toTvgt == "(arc_ellipse 20.0 35.0 50.0 1.5 false true (300.0 695.0))"

expect 
    arcCircle { radius: 14, largeArc: Bool.false, sweep: Bool.false, x: 275, y: 685 }
    |> toTvgt == "(arc_circle - 14.0 false false (275.0 685.0))"

expect close {} |> toTvgt == "(close -)"

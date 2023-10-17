interface Style
    exposes [
        Style,
        flat,
        linear,
        radial,
        toText,
    ]
    imports [
        ColorIndex.{ ColorIndex },
    ]

Style := [
    Flat ColorIndex, # flat <color>
    Linear (Dec, Dec) (Dec, Dec) ColorIndex ColorIndex, # linear (<x1> <y1>) (<x2> <y2>) <color_1> <color_2>
    Radial (Dec, Dec) (Dec, Dec) ColorIndex ColorIndex, # radial (<x1> <y1>) (<x2> <y2>) <color_1> <color_2>
]
    implements [Eq { isEq: isEq }]

isEq : Style, Style -> Bool
isEq = \@Style first, @Style second -> first == second

# flat <color>
flat : ColorIndex -> Style
flat = \id -> @Style (Flat id)

# linear (<x1> <y1>) (<x2> <y2>) <color_1> <color_2>
linear : (Dec, Dec), (Dec, Dec), ColorIndex, ColorIndex -> Style
linear = \p1, p2, c1, c2 ->
    @Style (Linear p1 p2 c1 c2)

# radial (<x1> <y1>) (<x2> <y2>) <color_1> <color_2>
radial : (Dec, Dec), (Dec, Dec), ColorIndex, ColorIndex -> Style
radial = \p1, p2, c1, c2 ->
    @Style (Radial p1 p2 c1 c2)

toText : Style -> Str
toText = \@Style style ->
    when style is
        Flat id -> "(flat \(ColorIndex.toStr id))"
        Linear p1 p2 c1 c2 -> "(linear \(xyToStr p1) \(xyToStr p2) \(ColorIndex.toStr c1) \(ColorIndex.toStr c2))"
        Radial p1 p2 c1 c2 -> "(radial \(xyToStr p1) \(xyToStr p2) \(ColorIndex.toStr c1) \(ColorIndex.toStr c2))"

xyToStr : (Dec, Dec) -> Str
xyToStr = \(x, y) -> "(\(Num.toStr x) \(Num.toStr y))"

testC1 = ColorIndex.fromU32 56
testC2 = ColorIndex.fromU32 43

expect xyToStr (123456, 0) == "(123456.0 0.0)"
expect flat testC1 |> toText == "(flat 56)"
expect linear (0, 12) (234, 567) testC1 testC2 |> toText == "(linear (0.0 12.0) (234.0 567.0) 56 43)"
expect radial (0, 12) (234, 567) testC1 testC2 |> toText == "(radial (0.0 12.0) (234.0 567.0) 56 43)"
expect flat testC1 == @Style (Flat testC1)

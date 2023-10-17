interface Style
    exposes [
        Style,
        flat,
        linear,
        radial,
        toText,
    ]
    imports []

Style := [
    Flat U32, # flat <color>
    Linear (Dec, Dec) (Dec, Dec) U32 U32, # linear (<x1> <y1>) (<x2> <y2>) <color_1> <color_2>
    Radial (Dec, Dec) (Dec, Dec) U32 U32, # radial (<x1> <y1>) (<x2> <y2>) <color_1> <color_2>
]
    implements [Eq { isEq: isEq }]

isEq : Style, Style -> Bool
isEq = \@Style first, @Style second -> first == second

# flat <color>
flat : U32 -> Style
flat = \id -> @Style (Flat id)

# linear (<x1> <y1>) (<x2> <y2>) <color_1> <color_2>
linear : (Dec, Dec), (Dec, Dec), U32, U32 -> Style
linear = \p1, p2, c1, c2 ->
    @Style (Linear p1 p2 c1 c2)

# radial (<x1> <y1>) (<x2> <y2>) <color_1> <color_2>
radial : (Dec, Dec), (Dec, Dec), U32, U32 -> Style
radial = \p1, p2, c1, c2 ->
    @Style (Radial p1 p2 c1 c2)

toText : Style -> Str
toText = \@Style style ->
    when style is
        Flat id -> "(flat \(Num.toStr id))"
        Linear p1 p2 c1 c2 -> "(linear \(xyToStr p1) \(xyToStr p2) \(Num.toStr c1) \(Num.toStr c2))"
        Radial p1 p2 c1 c2 -> "(radial \(xyToStr p1) \(xyToStr p2) \(Num.toStr c1) \(Num.toStr c2))"

xyToStr : (Dec, Dec) -> Str
xyToStr = \(x, y) -> "(\(Num.toStr x) \(Num.toStr y))"

testC1 = 56
testC2 = 43

expect xyToStr (123456, 0) == "(123456.0 0.0)"
expect flat testC1 |> toText == "(flat 56)"
expect linear (0, 12) (234, 567) testC1 testC2 |> toText == "(linear (0.0 12.0) (234.0 567.0) 56 43)"
expect radial (0, 12) (234, 567) testC1 testC2 |> toText == "(radial (0.0 12.0) (234.0 567.0) 56 43)"
expect flat testC1 == @Style (Flat testC1)

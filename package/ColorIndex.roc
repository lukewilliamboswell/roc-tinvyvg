interface ColorIndex
    exposes [
        ColorIndex,
        toU32,
        fromU32,
        toStr,
    ]
    imports []

## An index for a Color a graphic's color table.
ColorIndex := U32 implements [Eq { isEq: isEq }]

isEq : ColorIndex, ColorIndex -> Bool
isEq = \@ColorIndex first, @ColorIndex second -> first == second

toU32 : ColorIndex -> U32
toU32 = \@ColorIndex u32 -> u32

fromU32 : U32 -> ColorIndex
fromU32 = \u32 -> @ColorIndex u32

toStr : ColorIndex -> Str
toStr = \@ColorIndex u32 -> Num.toStr u32

expect (fromU32 12) == (@ColorIndex 12)
expect ((fromU32 12) |> toU32) == ((@ColorIndex 12) |> toU32)
expect (fromU32 12) |> toStr == "12"

module Bitwise (adder, multiplier, grayCode) where

import Data.Word
import Data.Bits

adder :: Word32 -> Word32 -> Word32
adder a 0 = a
adder a b = (a `xor` b) `adder` shiftL (a .&. b) 1

multiplier :: Word32 -> Word32 -> Word32
multiplier a b = go a b 0
    where
        go _ 0 acc = acc
        go x y acc
            | y .&. 1 == 1  = go (shiftL x 1) (shiftR y 1) (adder acc x)
            | otherwise     = go (shiftL x 1) (shiftR y 1) acc

grayCode :: Word32 -> Word32
grayCode a = a `xor` shiftR a 1

module Bitwise (adder, multiplier) where

import Data.Word

adder :: Word32 -> Word32 -> Word32
adder a b = a + b

multiplier :: Word32 -> Word32 -> Word32
multiplier a b = a * b

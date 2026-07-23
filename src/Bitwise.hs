module Bitwise (adder, multiplier) where

import Data.Word
import Data.Bits

adder :: Word32 -> Word32 -> Word32
adder a 0 = a
adder a b = adder (xor a b) $ shiftL (a .&. b) 1

multiplier :: Word32 -> Word32 -> Word32
multiplier _ 0 = 0
multiplier a 1 = a
multiplier a b = adder (multiplier a $ b .&. 1) $ multiplier (shiftL a 1) (shiftR b 1)

{-# LANGUAGE TemplateHaskell #-}
module Main (main) where

import Data.Word
import Data.Bits
import Test.QuickCheck
import System.Exit

import Bitwise
import Boolean
import Sets
import Curves

prop_adder :: Word32 -> Word32 -> Property
prop_adder a b = adder a b === a + b

prop_multiplier :: Word32 -> Word32 -> Property
prop_multiplier a b = multiplier a b === a * b

prop_graycode :: Word32 -> Property
prop_graycode n
  | n == 0      = grayCode 0 === 0
  | otherwise   = popCount (grayCode n `xor` grayCode (n - 1)) === 1

return []

main :: IO ()
main = do
    success <- $quickCheckAll
    if success
        then return ()
        else exitFailure

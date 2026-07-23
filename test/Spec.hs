module Main (main) where

import Bitwise (adder, multiplier)
import Data.Word (Word32)
import Test.QuickCheck (quickCheck)

prop_adder :: Word32 -> Word32 -> Bool
prop_adder a b = adder a b == a + b

prop_multiplier :: Word32 -> Word32 -> Bool
prop_multiplier a b = multiplier a b == a * b

main :: IO ()
main = do
    putStrLn "--- BITWISE TESTS ---"
    quickCheck prop_adder
    quickCheck prop_multiplier

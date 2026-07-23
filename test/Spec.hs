{-# LANGUAGE TemplateHaskell #-}
module Main (main) where

import Bitwise
import Data.Word (Word32)
import Test.QuickCheck (quickCheckAll, Property, (===))
import System.Exit (exitFailure)

prop_adder :: Word32 -> Word32 -> Property
prop_adder a b = adder a b === a + b

prop_multiplier :: Word32 -> Word32 -> Property
prop_multiplier a b = multiplier a b === a * b

return []

main :: IO ()
main = do
    success <- $quickCheckAll
    if success
        then return ()
        else exitFailure

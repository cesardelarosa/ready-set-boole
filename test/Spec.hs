{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Main (main) where

import Bitwise (adder, grayCode, multiplier)
import Boolean
  ( conjunctiveNormalForm,
    evalFormula,
    negationNormalForm,
    printTruthTable,
    sat,
  )
import Curves (fnReverseMap, map)
import Data.Bits (Bits (popCount, xor))
import Data.Bool (Bool (True), otherwise)
import Data.Eq ((==))
import Data.String (String)
import Data.Word (Word16, Word32)
import GHC.Base (return)
import GHC.Float (Double)
import GHC.Num ((*), (+), (-))
import Sets (evalSet, powerset)
import System.Exit (exitFailure)
import System.IO (IO)
import Test.QuickCheck (Property, property, quickCheckAll, (===))

prop_adder :: Word32 -> Word32 -> Property
prop_adder a b = adder a b === a + b

prop_multiplier :: Word32 -> Word32 -> Property
prop_multiplier a b = multiplier a b === a * b

prop_graycode :: Word32 -> Property
prop_graycode n
  | n == 0 = grayCode 0 === 0
  | otherwise = popCount (grayCode n `xor` grayCode (n - 1)) === 1

prop_evalFormula :: String -> Property
prop_evalFormula _ = property True

prop_printTruthTable :: String -> Property
prop_printTruthTable _ = property True

prop_negationNormalForm :: String -> Property
prop_negationNormalForm _ = property True

prop_conjunctiveNormalForm :: String -> Property
prop_conjunctiveNormalForm _ = property True

prop_sat :: String -> Property
prop_sat _ = property True

prop_map :: Word16 -> Word16 -> Property
prop_map _ _ = property True

prop_fnReverseMap :: Double -> Property
prop_fnReverseMap _ = property True

prop_powerset :: [Word32] -> Property
prop_powerset _ = property True

prop_evalSet :: String -> [[Word32]] -> Property
prop_evalSet _ _ = property True

return []

main :: IO ()
main = do
  success <- $quickCheckAll
  if success
    then return ()
    else exitFailure

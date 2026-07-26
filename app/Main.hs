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
import Data.Either (Either (Left, Right))
import Data.Maybe (Maybe (Just, Nothing))
import Data.Word (Word16, Word32)
import GHC.Base (String, (++))
import GHC.Float (Double)
import Sets (evalSet, powerset)
import System.Environment (getArgs)
import System.IO (IO, print, putStrLn)
import Text.Read (readMaybe)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ("adder" : rest) -> handleBitwise "adder" rest
    ("multiplier" : rest) -> handleBitwise "multiplier" rest
    ("graycode" : rest) -> handleBitwise "graycode" rest
    ("evalformula" : rest) -> handleBoolean "evalformula" rest
    ("printtruthtable" : rest) -> handleBoolean "printtruthtable" rest
    ("nnf" : rest) -> handleBoolean "nnf" rest
    ("cnf" : rest) -> handleBoolean "cnf" rest
    ("sat" : rest) -> handleBoolean "sat" rest
    ("powerset" : rest) -> handleSets "powerset" rest
    ("evalset" : rest) -> handleSets "evalset" rest
    ("map" : rest) -> handleCurves "map" rest
    ("fnreversemap" : rest) -> handleCurves "fnreversemap" rest
    _ -> usage

-- -------------------------------------------------------------------------
-- Handlers
-- -------------------------------------------------------------------------

handleBitwise :: String -> [String] -> IO ()
handleBitwise "adder" [aStr, bStr] =
  with2Args aStr bStr (\a b -> print (adder a b))
handleBitwise "multiplier" [aStr, bStr] =
  with2Args aStr bStr (\a b -> print (multiplier a b))
handleBitwise "graycode" [aStr] =
  with1Arg aStr (\a -> print (grayCode a))
handleBitwise _ _ = putStrLn "Error: Invalid arguments for Bitwise function."

handleBoolean :: String -> [String] -> IO ()
handleBoolean "evalformula" [formula] =
  case evalFormula formula of
    Right res -> print res
    Left err -> putStrLn ("Error: " ++ err)
handleBoolean "printtruthtable" [formula] = printTruthTable formula
handleBoolean "nnf" [formula] = putStrLn (negationNormalForm formula)
handleBoolean "cnf" [formula] = putStrLn (conjunctiveNormalForm formula)
handleBoolean "sat" [formula] = print (sat formula)
handleBoolean _ _ = putStrLn "Error: Invalid arguments for Boolean function."

handleSets :: String -> [String] -> IO ()
handleSets "powerset" [setStr] =
  withListArg setStr (\set -> print (powerset set))
handleSets "evalset" [formula, setsStr] =
  withListListArg setsStr (\sets -> print (evalSet formula sets))
handleSets _ _ = putStrLn "Error: Invalid arguments for Sets function."

handleCurves :: String -> [String] -> IO ()
handleCurves "map" [aStr, bStr] =
  case (readMaybe aStr :: Maybe Word16, readMaybe bStr :: Maybe Word16) of
    (Just a, Just b) -> print (map a b)
    _ -> putStrLn "Error: arguments must be numbers (Word16)."
handleCurves "fnreversemap" [aStr] =
  case readMaybe aStr :: Maybe Double of
    (Just a) -> print (fnReverseMap a)
    _ -> putStrLn "Error: argument must be a number (Double)."
handleCurves _ _ = putStrLn "Error: Invalid arguments for Curves function."

-- -------------------------------------------------------------------------
-- Helpers for parsing
-- -------------------------------------------------------------------------

with1Arg :: String -> (Word32 -> IO ()) -> IO ()
with1Arg aStr f = case readMaybe aStr :: Maybe Word32 of
  Just a -> f a
  Nothing -> putStrLn "Error: Argument must be a number (Word32)."

with2Args :: String -> String -> (Word32 -> Word32 -> IO ()) -> IO ()
with2Args aStr bStr f = case (readMaybe aStr :: Maybe Word32, readMaybe bStr :: Maybe Word32) of
  (Just a, Just b) -> f a b
  _ -> putStrLn "Error: Arguments must be numbers (Word32)."

withListArg :: String -> ([Word32] -> IO ()) -> IO ()
withListArg setStr f = case readMaybe setStr :: Maybe [Word32] of
  Just set -> f set
  Nothing -> putStrLn "Error: Argument must be a list of Word32, e.g. \"[1,2,3]\"."

withListListArg :: String -> ([[Word32]] -> IO ()) -> IO ()
withListListArg setsStr f = case readMaybe setsStr :: Maybe [[Word32]] of
  Just sets -> f sets
  Nothing -> putStrLn "Error: Argument must be a list of lists of Word32, e.g. \"[[1,2],[3]]\"."

-- -------------------------------------------------------------------------
-- Usage
-- -------------------------------------------------------------------------

usage :: IO ()
usage =
  putStrLn
    "Usage: ready-set-boole-app <command> [args...]\n\
    \Commands:\n\
    \  [Bitwise]\n\
    \  adder <num1> <num2>\n\
    \  multiplier <num1> <num2>\n\
    \  graycode <num>\n\
    \\n\
    \  [Boolean]\n\
    \  evalformula \"<formula>\"\n\
    \  printtruthtable \"<formula>\"\n\
    \  nnf \"<formula>\"\n\
    \  cnf \"<formula>\"\n\
    \  sat \"<formula>\"\n\
    \\n\
    \  [Sets]\n\
    \  powerset \"[num1, num2,...]\"\n\
    \  evalset \"<formula>\" \"[[num1,num2], [num3]]\"\n\
    \\n\
    \  [Curves]\n\
    \  map <num1> <num2>\n\
    \  fnreversemap <double>"

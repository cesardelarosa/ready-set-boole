{-# LANGUAGE NoImplicitPrelude #-}

module Boolean
  ( evalFormula,
    printTruthTable,
    negationNormalForm,
    conjunctiveNormalForm,
    sat,
  )
where

import Data.Bool (Bool (False, True), not, (&&), (||))
import Data.Either (Either (Left, Right))
import Data.Eq ((/=), (==))
import Data.String (String)
import GHC.Base (Char, undefined, (++))
import System.IO (IO)

infix 4 ==>

(==>) :: Bool -> Bool -> Bool
True ==> False = False
_ ==> _ = True

pop1 :: Char -> (Bool -> Bool) -> [Bool] -> Either String [Bool]
pop1 _ op (x : xs) = Right (op x : xs)
pop1 c _ _ = Left ("Syntax error: Missing operand for '" ++ [c] ++ "'")

pop2 :: Char -> (Bool -> Bool -> Bool) -> [Bool] -> Either String [Bool]
pop2 _ op (b : a : xs) = Right (op a b : xs)
pop2 c _ _ = Left ("Syntax error: Missing operands for '" ++ [c] ++ "'")

evalFormula :: String -> Either String Bool
evalFormula formula = evalRPN formula []
  where
    evalRPN :: String -> [Bool] -> Either String Bool
    evalRPN [] [res] = Right res
    evalRPN [] [] = Left "Syntax error: Empty formula"
    evalRPN [] _ = Left "Syntax error: Incomplete evaluation, extra operands on stack"
    evalRPN (c : cs) stack = case c of
      ' ' -> evalRPN cs stack
      '0' -> evalRPN cs (False : stack)
      '1' -> evalRPN cs (True : stack)
      '!' -> step (pop1 c not)
      '&' -> step (pop2 c (&&))
      '|' -> step (pop2 c (||))
      '^' -> step (pop2 c (/=))
      '>' -> step (pop2 c (==>))
      '=' -> step (pop2 c (==))
      _ -> Left ("Syntax error: Invalid character '" ++ [c] ++ "'")
      where
        step transform = case transform stack of
          Right newStack -> evalRPN cs newStack
          Left err -> Left err

printTruthTable :: String -> IO ()
printTruthTable _ = undefined

negationNormalForm :: String -> String
negationNormalForm _ = undefined

conjunctiveNormalForm :: String -> String
conjunctiveNormalForm _ = undefined

sat :: String -> Bool
sat _ = undefined

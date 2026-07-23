{-# LANGUAGE NoImplicitPrelude #-}

module Boolean
  ( evalFormula,
    printTruthTable,
    negationNormalForm,
    conjunctiveNormalForm,
    sat,
  )
where

import Data.Bool (Bool (True))
import Data.String (String)
import GHC.Base (undefined)
import System.IO (IO)

evalFormula :: String -> Bool
evalFormula _ = True

printTruthTable :: String -> IO ()
printTruthTable _ = undefined

negationNormalForm :: String -> String
negationNormalForm _ = undefined

conjunctiveNormalForm :: String -> String
conjunctiveNormalForm _ = undefined

sat :: String -> Bool
sat _ = undefined

module Boolean (evalFormula, printTruthTable, negationNormalForm, conjuctiveNormalForm, sat) where

evalFormula :: String -> Bool
evalFormula _ = True

printTruthTable :: String -> IO ()
printTruthTable _ = do
    putStrLn "=== TRUTH TABLE ==="

negationNormalForm :: String -> String
negationNormalForm _ = "NNF"

conjuctiveNormalForm :: String -> String
conjuctiveNormalForm _ = "CNF"

sat :: String -> Bool
sat _ = True

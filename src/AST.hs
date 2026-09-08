{-# LANGUAGE NoImplicitPrelude #-}

data Expr
  = Const Bool
  | Var Char
  | Not Expr
  | And Expr Expr
  | Or Expr Expr
  | Xor Expr Expr
  | Impl Expr Expr
  | Equiv Expr Expr

parseRPN :: String -> Either String Expr
parseRPN formula = parseExpr []
  where
    parseExpr :: String [Expr] -> Either String Expr
    parseExpr [] [res] = Right res
    parseExpr [] [] = Left "Syntax error: Empty formula"
    parseExpr [] _ = Left "Syntax error: Incomplete evaluation, extra operands on stack"
    parseExpr (c : cs) stack = case c of
      ' ' -> parseExpr cs stack
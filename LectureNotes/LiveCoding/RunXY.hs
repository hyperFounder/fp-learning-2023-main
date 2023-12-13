--
--  RunXY.hs
--

import Data.Char 
import Control.Monad
import System.Environment 
import Parsing

--
--  Attendance - 25741155
--

type Identifier = String

data Expr = Constant Integer
          | Variable Identifier
          | Eq Expr Expr 
          | Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Gt Expr Expr 

data Program = Identifier := Expr
             | Block [Program]
             | While Expr Program
             | If Expr Program

--
--  Interpreter 
--

number :: Bool -> Integer
number True = 1
number False = 0

boolean :: Integer -> Bool
boolean i | i == 0 = False
          | otherwise = True 

type Storage = Identifier -> Integer

emptyStorage :: Storage
emptyStorage ident = error "Variable unrecognized"

updateStorage :: Storage -> Identifier -> Integer -> Storage
updateStorage m ident val queryIdent | queryIdent == ident = val 
updateStorage m ident val queryIdent | otherwise = m queryIdent 

-- updateStorage :: Storage -> Identifier -> Integer -> Storage
-- updateStorage oldStorage ident val = newStorage

--   where newStorage :: Storage  -- == Indentifier -> Integer 
--         newStorage queryIdentifier | queryIdentifier == ident = val
--                                    | otherwise = oldStorage ident 

eval :: Expr -> Storage -> Integer
eval (Constant i) m = i
eval (Variable ident) m = m ident 
eval (Eq e f) m = number (eval e m == eval f m)
eval (Gt e f) m = number (eval e m > eval f m) 
eval (Add e f) m = eval e m + eval f m 
eval (Sub e f) m = eval e m - eval f m 
eval (Mul e f) m = eval e m * eval f m

run :: Program -> Storage -> Storage
run (ident := expr) m = updateStorage m ident (eval expr m)
run (Block []) m = m
run (Block (p:ps)) m = let m' = run p m in
                         run (Block ps) m'
run (While e p) m | boolean (eval e m) =
                    let m' = run p m in
                      run (While e p) m'
run (While e p) m | otherwise = m
run (If e p) m | boolean (eval e m) = run p m
run (If e p) m | otherwise = m 

--
--  Parser 
--

-- data Program = Identifier := Expr
--              | Block [Program]
--              | While Expr Program
--              | If Expr Program

program :: Parser Program
program = assignment
  <|> block
  <|> whileStatement
  <|> ifStatement

assignment :: Parser Program
assignment =
  do id <- identifier
     symbol ":="
     e <- expr
     symbol ";"
     return (id := e)

block :: Parser Program
block =
  do symbol "{"
     ps <- many program
     symbol "}"
     return (Block ps)

whileStatement :: Parser Program
whileStatement =
  do symbol "while"
     e <- expr
     p <- program
     return (While e p)

ifStatement :: Parser Program     
ifStatement =
  do symbol "if"
     e <- expr
     p <- program
     return (If e p)
     

expr :: Parser Expr
expr = 
  do e <- expr1
     (do symbol "=="
         f <- expr
         return (Eq e f))
       <|> return e 

expr1 :: Parser Expr
expr1 = 
  do e <- expr2
     (do symbol ">"
         f <- expr1
         return (Gt e f))
       <|> return e 

expr2 :: Parser Expr
expr2 = 
  do e <- expr3
     (do symbol "+"
         f <- expr2
         return (Add e f))
       <|> return e 

expr3 :: Parser Expr
expr3 = 
  do e <- expr4
     (do symbol "-"
         f <- expr3
         return (Sub e f))
       <|> return e 

expr4 :: Parser Expr
expr4 = 
  do e <- expr5
     (do symbol "*"
         f <- expr4
         return (Mul e f))
       <|> return e 

expr5 :: Parser Expr
expr5 = constantExpr
  <|> variableExpr
  <|> parenExpr 

constantExpr :: Parser Expr
constantExpr = 
  do i <- integer
     return (Constant (toInteger i))

variableExpr :: Parser Expr
variableExpr =
  do id <- identifier
     return (Variable id) 

parenExpr :: Parser Expr
parenExpr = 
  do symbol "("
     e <- expr
     symbol ")"
     return e 

parseProgram :: String -> Program
parseProgram s =
  case parse program s of
    [(p,[])] -> p 
    _ -> error "Parse failed"
  
main :: IO ()
main =
  do args <- getArgs
     if (length args == 2)
       then do programText <- readFile (args !! 0)
               let p = parseProgram programText
               let resultStorage = run p (updateStorage emptyStorage "x" (read (args !! 1)))
               putStrLn (show (resultStorage "y"))
       else putStrLn "Usage RunXY <fname> <xval>"
     

  



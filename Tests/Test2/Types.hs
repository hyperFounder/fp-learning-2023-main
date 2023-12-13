-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

---------------------------------------------------------------------------------
-------------------------- DO **NOT** MODIFY THIS FILE --------------------------
---------------------------------------------------------------------------------

module Types where

import Control.Monad.State

--------------------------------------------------------------------------------
-- QUESTION 1
--------------------------------------------------------------------------------

penta :: Integer -> Integer
penta 0 = 0
penta 1 = 1
penta 2 = 2
penta 3 = 3
penta 4 = 4
penta n =     penta (n-5)
        + 2 * penta (n-4)
        - 3 * penta (n-3)
        + 4 * penta (n-2)
        - 5 * penta (n-1)

--------------------------------------------------------------------------------
-- QUESTION 2
--------------------------------------------------------------------------------

type CurrBalance = Int

data Transaction = Deposit
                 | Withdrawal
                 | DepositFailed
                 | WithdrawalFailed
                 deriving (Eq, Show)

type BankAccount = (CurrBalance, [Transaction])

--------------------------------------------------------------------------------
-- QUESTION 3
--------------------------------------------------------------------------------

data Bin a = Leaf
           | Node a (Bin a) (Bin a)
           deriving (Eq, Show)

ex1 :: Bin (Maybe Int)
ex1 = Node (Just 4) (Node (Just 7) Leaf Leaf) (Node (Just 1) Leaf Leaf)

ex2 :: Bin (Maybe Bool)
ex2 = Node (Just True) Leaf (Node Nothing Leaf Leaf)

ex3 :: Bin [Int]
ex3 = Node [4] (Node [7] Leaf Leaf) (Node [1,2] Leaf Leaf)

ex4 :: Bin [Int]
ex4 = Node [17,45] Leaf (Node [4,3] Leaf Leaf)

--------------------------------------------------------------------------------
-- QUESTION 4
--------------------------------------------------------------------------------

data Expr = Var     Char
          | Not     Expr
          | And     Expr Expr
          | Or      Expr Expr
          | Implies Expr Expr
          deriving (Eq, Show)

data Circuit = Input Char
             | Nand  Circuit Circuit
             deriving (Eq, Show)

expr1 :: Expr
expr1 = Not (Var 'p')

expr2 :: Expr
expr2 = And (Var 'p') (Var 'q')

expr3 :: Expr
expr3 = Or (Not (Var 'p')) (Var 'q')

--------------------------------------------------------------------------------
-- QUESTION 5
--------------------------------------------------------------------------------

data Heap a = Empty
            | HeapNode a (Heap a) (Heap a)
            deriving (Eq, Show)

heap1 :: Heap Int
heap1 = HeapNode 50 (HeapNode 100 Empty Empty) (HeapNode 200 Empty Empty)

heap2 :: Heap Int
heap2 = HeapNode 4 (HeapNode 8 Empty Empty) (HeapNode 10 Empty (HeapNode 20 Empty Empty))

heap3 :: Heap Int
heap3 = HeapNode 4 (HeapNode 8 (HeapNode 9 Empty Empty) Empty) (HeapNode 10 Empty (HeapNode 20 Empty Empty))

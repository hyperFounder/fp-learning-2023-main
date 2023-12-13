-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

module ProblemSheet10 (experiments ,
                       gameAnnotated ,
                       game ,
                       odds ,
                       oneOf ,
                       noun , verb , pronoun , properNoun , determiner , preposition ,
                       nominal ,
                       np ,
                       vp ,
                       pp ,
                       sent) where

import Types
import Parsing
import Data.Char

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

{- Monads and a game of chance -}

-- An example you can use for testing
headsOrTails :: ChanceMonad m => m Outcome
headsOrTails = do
  c <- toss
  if c == H then return Win else return Lose

{- Exercise 1.1 -}
experiments :: ChanceMonad m => m a -> Integer -> m [a]
experiments = undefined

{- Exercise 1.2 -}
gameAnnotated :: ChanceMonad m => m ([Coin],Die,Outcome)
gameAnnotated = undefined

{- Exercise 1.3 -}
game :: ChanceMonad m => m Outcome
game = undefined

{- Exercise 1.4 -}
odds :: [Outcome] -> Float
odds = undefined

{- Parsing English -}
parseTest :: Parser Tree -> String -> Maybe Tree
parseTest p s = case (parse p s) of
                  [(t,"")] -> Just t
                  _        -> Nothing

{- Exercise 2.1 -}
oneOf :: [String] -> Parser String
oneOf = undefined

{- Exercise 2.2 -}
noun :: Parser Tree
noun = undefined
verb :: Parser Tree
verb = undefined
pronoun :: Parser Tree
pronoun = undefined
properNoun :: Parser Tree
properNoun = undefined
determiner :: Parser Tree
determiner = undefined
preposition :: Parser Tree
preposition = undefined

{- Exercise 2.3 -}
nominal :: Parser Tree
nominal = undefined

space' :: Parser ()
space' = do some (sat isSpace)
            return ()

{- Exercise 2.4 -}
np :: Parser Tree
np = undefined

{- Exercise 2.5 -}
vp :: Parser Tree
vp = undefined

{- Exercise 2.6 -}
pp :: Parser Tree
pp = undefined

{- Exercise 2.7 -}
sent :: Parser Tree
sent = undefined

parseSentence :: String -> Maybe Tree
parseSentence = parseTest sent

-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

---------------------------------------------------------------------------------
-------------------------- DO **NOT** MODIFY THIS FILE --------------------------
---------------------------------------------------------------------------------

module Types where

import System.Random

-- Monads and a game of chance

data Coin    = H | T
  deriving (Show, Eq, Enum, Bounded)
data Die     = D1 | D2 | D3 | D4 | D5 | D6
  deriving (Show, Eq, Enum, Bounded)
data Outcome = Win | Lose
  deriving (Show, Eq)

class Monad m => ChanceMonad m where
  toss :: m Coin
  roll :: m Die

instance ChanceMonad [] where
  toss = [H,T]
  roll = [D1 .. D6]

instance Random Coin where
  randomR (lo,hi) g = (toEnum i , g')
    where
      (i,g') = randomR (fromEnum lo , fromEnum hi) g
  random g = randomR (minBound,maxBound) g

instance Random Die where
  randomR (lo,hi) g = (toEnum i , g')
    where
      (i,g') = randomR (fromEnum lo , fromEnum hi) g
  random g = randomR (minBound,maxBound) g

instance ChanceMonad IO where
  roll = getStdRandom (random)
  toss = getStdRandom (random)

-- Parsing English

data Sort = Sentence
          | NP
          | VP
          | PP
          | Noun
          | Verb
          | Pronoun
          | ProperNoun
          | Nominal
          | Determiner
          | Preposition
          deriving (Eq, Show)

data Tree = Branch Sort [Tree]
          | Leaf Sort String deriving (Eq, Show)

nouns :: [String]
nouns = ["flight", "breeze", "trip", "morning"]

verbs :: [String]
verbs = ["is", "prefer", "like", "need", "want", "fly"]

pronouns :: [String]
pronouns = ["me", "I", "you", "it"]

determiners :: [String]
determiners = ["these", "the" , "an", "a", "this", "that"]

prepositions :: [String]
prepositions = ["from", "to", "on", "near"]

properNouns :: [String]
properNouns = ["Alaska", "Baltimore", "Los Angeles", "Chicago"]

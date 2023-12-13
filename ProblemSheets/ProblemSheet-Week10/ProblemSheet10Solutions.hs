-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

module ProblemSheet10Solutions
  (experiments ,
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
import Control.Monad
import Data.List

{- Monads and a game of chance -}

-- An example you can use for testing
headsOrTails :: ChanceMonad m => m Outcome
headsOrTails = do
  c <- toss
  if c == H then return Win else return Lose

{- Exercise 1.1 -}
experiments :: ChanceMonad m => m a -> Integer -> m [a]
experiments _  0 = return []
experiments me n = do
  es <- experiments me (n-1)
  e  <- me
  return (e:es)

-- Using replicateM from Control.Monad
-- Tip: you can search hoogle.haskell.org by type signature
--      to find functions like this
experiments' :: ChanceMonad m => m a -> Integer -> m [a]
experiments' me n = replicateM (fromIntegral n) me

{- Exercise 1.2 -}
-- Helper 1
eyes :: Die -> Int
eyes = (+ 1) . fromEnum

-- Helper 2
outcome :: Die -> Int -> Outcome
outcome d n = if   eyes d >= n
              then Win
              else Lose

gameAnnotated :: ChanceMonad m => m ([Coin],Die,Outcome)
gameAnnotated = do
  ts <- experiments toss 6
  let noOfHeads = length (filter (== H) ts)
  r <- roll
  let o = outcome r noOfHeads
  return (ts,r,o)

{- Exercise 1.3 -}
game :: ChanceMonad m => m Outcome
game = do
  (_,_,o) <- gameAnnotated
  return o

-- Alternatively, using that m is a functor
game' :: ChanceMonad m => m Outcome
game' = (\(_,_,o) -> o) <$> gameAnnotated

{- Exercise 1.4 -}
odds :: [Outcome] -> Float
odds os = fromIntegral noOfWins / fromIntegral n
  where
    noOfWins = length (filter (== Win) os)
    n        = length os

{- Testing -}
trials :: IO Outcome -> Integer -> IO Float
trials o n = do
  os <- experiments o n
  return (odds os)

{- Parsing English -}
parseTest :: Parser Tree -> String -> Maybe Tree
parseTest p s = case (parse p s) of
                  [(t,"")] -> Just t
                  _        -> Nothing

{- Exercise 2.1 -}
-- "Naive" solution
-- Note that this depends on the order of the strings in the input list, e.g.
--   'oneOf ["these","the"  ] "these" = [("these","")]' will be OK, but
--   'oneOf ["the"  ,"these"] "these" = [("the"  ,"")]' will fail!
-- NB: For the purpose of the parsing exercises, this naive solution suffices,
-- because of the order of the determiners.
oneOf' :: [String] -> Parser String
oneOf' []     = empty
oneOf' (s:ss) = string s <|> oneOf ss

-- In order to deal with cases like 'oneOf ["the","therefore","there",]'
-- properly, you could sort the input list of strings by length (longest first),
-- like we do here:
oneOf :: [String] -> Parser String
oneOf = oneOf' . sortByLength

sortByLength :: [[a]] -> [[a]]
sortByLength = sortBy (\xs ys -> compare (length ys) (length xs))

-- Finally, a variation on oneOf' using foldr:
oneOf'' :: [String] -> Parser String
oneOf'' = foldr (\s p -> string s <|> p) empty

{- Exercise 2.2 -}
noun :: Parser Tree
noun = Leaf Noun <$> oneOf nouns
verb :: Parser Tree
verb = Leaf Verb <$> oneOf verbs
pronoun :: Parser Tree
pronoun = Leaf Pronoun <$> oneOf pronouns
properNoun :: Parser Tree
properNoun = Leaf ProperNoun <$> oneOf properNouns
determiner :: Parser Tree
determiner = Leaf Determiner <$> oneOf determiners
preposition :: Parser Tree
preposition = Leaf Preposition <$> oneOf prepositions

{- Exercise 2.3 -}
-- Helper 1
space' :: Parser ()
space' = do some (sat isSpace)
            return ()

-- Helper 2
branch :: Sort -> [Parser Tree] -> Parser Tree
branch _ [] = undefined
branch s (p:ps) = do
  v  <- p
  vs <- sequence ps'
  return (Branch s (v:vs))
    where
      ps' :: [Parser Tree]
      ps' = [space' >> q | q <- ps]

nominal :: Parser Tree
nominal = branch Nominal [noun, nominal] <|> branch Nominal [noun]

{- Exercise 2.4 -}
np :: Parser Tree
np =  branch NP [pronoun]
  <|> branch NP [properNoun]
  <|> branch NP [determiner,nominal]

{- Exercise 2.5 -}
vp :: Parser Tree
vp =  branch VP [verb,np,pp]
  <|> branch VP [verb,np]
  <|> branch VP [verb,pp]
  <|> branch VP [verb]

{- Exercise 2.6 -}
pp :: Parser Tree
pp = branch PP [preposition,np]

{- Exercise 2.7 -}
sent :: Parser Tree
sent = branch Sentence [np,vp]

parseSentence :: String -> Maybe Tree
parseSentence = parseTest sent

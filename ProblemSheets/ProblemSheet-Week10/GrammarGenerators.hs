module GrammarGenerators where

import Types
import Test.QuickCheck
import Parsing
import ProblemSheet10Solutions as Solution
import Data.List

arbitraryLexicalItem :: [String] -> Gen String
arbitraryLexicalItem = elements

arbitraryNoun :: Gen Tree
arbitraryNoun = do
  s <- arbitraryLexicalItem nouns
  return $ Leaf Noun s

arbitraryVerb :: Gen Tree
arbitraryVerb = do
  s <- arbitraryLexicalItem verbs
  return $ Leaf Verb s

arbitraryPronoun :: Gen Tree
arbitraryPronoun = do
  s <- arbitraryLexicalItem pronouns
  return $ Leaf Pronoun s

arbitraryDeterminer :: Gen Tree
arbitraryDeterminer = do
  s <- arbitraryLexicalItem determiners
  return $ Leaf Determiner s

arbitraryPreposition :: Gen Tree
arbitraryPreposition = do
  s <- arbitraryLexicalItem prepositions
  return $ Leaf Preposition s

arbitraryProperNoun :: Gen Tree
arbitraryProperNoun = do
  s <- arbitraryLexicalItem properNouns
  return $ Leaf ProperNoun s

joinNouns :: [Tree] -> Tree
joinNouns [ t ]  = Branch Nominal [t]
joinNouns (t:ts) = Branch Nominal [t, joinNouns ts]

nonnegative :: Gen (NonNegative Int)
nonnegative = arbitrary

nonnegativeInt :: Gen Int
nonnegativeInt = do
  n <- nonnegative
  return $ getNonNegative n

arbitraryNominal :: Gen Tree
arbitraryNominal = do
  n  <- nonnegativeInt `suchThat` (\m -> m > 0 && m < 30)
  ts <- vectorOf n arbitraryNoun
  return $ joinNouns ts

branchAux :: [Gen Tree] -> Gen [Tree]
branchAux []       = undefined
branchAux [ gt ]   = do t <- gt
                        return $ [t]
branchAux (gt:gts) = do t  <- gt
                        ts <-  branchAux gts
                        return $ t:ts

branch :: Sort -> [Gen Tree] -> Gen Tree
branch s []  = undefined
branch s gts = do ts <- branchAux gts
                  return $ Branch s ts

arbitraryNP' :: Gen Tree
arbitraryNP' = oneof [ branch NP [arbitraryPronoun]
                     , branch NP [arbitraryProperNoun]
                     , branch NP [arbitraryDeterminer, arbitraryNominal]
                     ]

arbitraryNP :: Int -> Gen Tree
arbitraryNP 0 = branch NP [arbitraryPronoun]
arbitraryNP 1 = branch NP [arbitraryProperNoun]
arbitraryNP 2 = branch NP [arbitraryDeterminer, arbitraryNominal]

arbitraryPP :: Gen Tree
arbitraryPP = branch PP [arbitraryPreposition, arbitraryNP']

arbitraryVP' :: Gen Tree
arbitraryVP' = oneof [ branch VP [arbitraryVerb]
                     , branch VP [arbitraryVerb, arbitraryNP']
                     , branch VP [arbitraryVerb, arbitraryNP', arbitraryPP]
                     , branch VP [arbitraryVerb, arbitraryPP]
                     ]

arbitraryVP :: Int -> Gen Tree
arbitraryVP 0 = branch VP [arbitraryVerb]
arbitraryVP 1 = branch VP [arbitraryVerb, arbitraryNP']
arbitraryVP 2 = branch VP [arbitraryVerb, arbitraryNP', arbitraryPP]
arbitraryVP 3 = branch VP [arbitraryVerb, arbitraryPP]
arbitraryVP _ = undefined

arbitrarySent :: Gen Tree
arbitrarySent = branch Sentence [arbitraryNP', arbitraryVP']

allWords :: [String]
allWords =
  nouns ++ verbs ++ pronouns ++ determiners ++ prepositions ++ properNouns

arbitrarySepWords :: Gen [String]
arbitrarySepWords = elements [nouns,verbs,pronouns,determiners,prepositions,properNouns]
  -- listOf1 . arbitraryLexicalItem $ allWords

arbitraryWords :: Gen String
arbitraryWords = do
  ss <- listOf1 . arbitraryLexicalItem $ allWords
  return $ intercalate " " ss

parseTest :: Parser Tree -> String -> Maybe Tree
parseTest p s = case parse p s of
                  [(t,"")] -> Just t
                  _        -> Nothing

arbitraryUngrammatical :: Parser Tree -> Gen String
arbitraryUngrammatical p = do
  s <- arbitraryWords `suchThat` (\s -> parseTest p s == Nothing)
  return s

shrinkWords :: [a] -> [[a]]
shrinkWords []  = []
shrinkWords xs  = init (tail (subsequences xs))

arbitrarySort :: (Sort, Maybe Int) -> Gen Tree
arbitrarySort (Sentence,_)    = arbitrarySent
arbitrarySort (NP,Just n)     = arbitraryNP n
arbitrarySort (NP,Nothing)    = undefined
arbitrarySort (VP,Just n)     = arbitraryVP n
arbitrarySort (VP,Nothing)    = undefined
arbitrarySort (PP,_)          = arbitraryPP
arbitrarySort (Noun,_)        = arbitraryNoun
arbitrarySort (Verb,_)        = arbitraryVerb
arbitrarySort (Pronoun,_)     = arbitraryPronoun
arbitrarySort (ProperNoun,_)  = arbitraryProperNoun
arbitrarySort (Nominal,_)     = arbitraryNominal
arbitrarySort (Determiner,_)  = arbitraryDeterminer
arbitrarySort (Preposition,_) = arbitraryPreposition

allSorts :: [Sort]
allSorts = [ Noun
           , Verb
           , Pronoun
           , ProperNoun
           , Determiner
           , Preposition
           , Nominal
           , NP
           , VP
           , PP
           , Sentence
           ]

allCases :: [(Sort, Maybe Int)]
allCases = concatMap f allSorts
  where
    f :: Sort -> [(Sort, Maybe Int)]
    f NP = [(NP,Just i) | i <- [0..2]]
    f VP = [(VP,Just i) | i <- [0..3]]
    f s  = [(s,Nothing)]

linearise :: Tree -> String
linearise (Leaf   _ s)  = s
linearise (Branch _ ts) = concat $ intersperse " " $ linearise <$> ts

leafCount :: Tree -> Int
leafCount (Leaf _ _)    = 1
leafCount (Branch _ ts) = sum $ leafCount <$> ts

classifyInt :: Int -> String
classifyInt n
  | n <= 2   = "[1, 2]"
  | n <= 5   = "(2, 5]"
  | n <= 10  = "(5, 10]"
  | n <= 20  = "(10, 20]"
  | n <= 50  = "(20, 50]"
  | n <= 200 = "(50, 200]"

categorise :: Tree -> String
categorise t = classifyInt (leafCount t)

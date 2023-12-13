module ProblemSheet10Marking where

import Types
import MarkingCore
import ProblemSheet10TestCases
import GrammarGenerators

import Control.Monad.Identity
import Test.QuickCheck

main :: IO ()
main = runMarking tests True
  where
    soundnessTests = makeSoundnessTest <$> allCases
    negativeTests  = makeNegativeTest  <$> allSorts
    grammarTests =
      oneOfTest : concat [ if (mi == Nothing || mi == Just 0)
                           then [makeNegativeTest s,makeSoundnessTest (s,mi)]
                           else [makeSoundnessTest (s,mi)]
                         | (s,mi) <- allCases]
    -- grammarTests   = oneOfTest : concat [ [t0, t1] | (t0, t1) <- zip soundnessTests negativeTests ]
    tests          = [ test_experiments_p
                     , test_experiments_l
                     , test_experiments_i
                     , test_gameAnnotated_l
                     , test_gameAnnotated_i
                     , test_game_l
                     , test_game_i
                     , test_odds
                     ] ++ grammarTests

{- ChanceMonad testing -}
instance Arbitrary Outcome where
  arbitrary = elements [Win,Lose]
  shrink _ = []

explanation
 = "When testing the ChanceMonad questions, your answers are tested on two different monads.\

 \ \n\nThe first is the List monad, whose instance of ChanceMonad is as in the assignment description:\
 \ \n instance ChanceMonad [] where\
 \ \n   toss = [H,T]\
 \ \n   roll = [D1 .. D6]\

 \ \n \nThe second is the Identity monad with the following 'constant' instance of ChanceMonad:\
 \ \n instance ChanceMonad Identity where\
 \ \n   toss = T\
 \ \n   roll = D3\

 \ \n \nBy testing on two different monads, we are ensuring your answers are general,\
 \ \nand can be employed on unseen instances of ChanceMonad.\n"

test_experiments_p = Test {
  mark        = 5,
  description = newSection ++
                explanation ++
                newSection ++
                "Checking that 'experiments (headsOrTails :: [Outcome]) 0' returns 'pure []'...",
  successMsg  = "You got 5 marks because 'experiments (headsOrTails :: [Outcome]) 0' returned 'pure []'.",
  failMsg     = "'experiments (headsOrTails :: [Outcome]) 0' did not return 'pure []'.",
  prop        = makeNullaryProp prop_experiments_p,
  condition   = Always
}

test_experiments_l = Test {
  mark        = 15,
  description = "Checking that 'experiments (headsOrTails :: [Outcome]) n' is correct for 'n > 0'...",
  successMsg  = "You got 15 marks because 'experiments (headsOrTails :: [Outcome]) n' is correct for n > 0.",
  failMsg     = "'experiments (headsOrTails :: [Outcome]) n' did not return the correct output for some n > 0.",
  prop        = makeUnaryPropWith prop_experiments_l (elements [1..6]) shrink,
  condition   = Always
}

test_experiments_i = Test {
  mark        = 15,
  description = "Checking that 'experiments (headsOrTails :: Identity Outcome) n' is correct for n > 0...",
  successMsg  = "You got 15 marks because 'experiments (headsOrTails :: Identity Outcome) n' is correct for n > 0.",
  failMsg     = "'experiments (headsOrTails :: Identity Outcome) n' did not return the correct output for some n > 0.",
  prop        = makeUnaryPropWith prop_experiments_i (elements [1..99]) shrink,
  condition   = Always
}


test_gameAnnotated_l = Test {
  mark        = 20,
  description = newSection ++ "Checking that 'gameAnnotated :: [([Coin],Die,Outcome)]'\
                            \ returns all possible six-rolls-and-a-toss games with their\
                            \ corresponding outcome...",
  successMsg  = "You got 20 marks because 'gameAnnotated :: [([Coin],Die,Outcome)]' is correct.",
  failMsg     = "'gameAnnotated :: [([Coin],Die,Outcome)]' did not return the correct output.",
  prop        = makeNullaryProp prop_gameAnnotated_l,
  condition   = Always
}

test_gameAnnotated_i = Test {
  mark        = 15,
  description = "Checking that 'gameAnnotated :: Identity ([Coin],Die,Outcome)'\
                \returns '([T,T,T,T,T,T],D3,Win)'...",
  successMsg  = "You got 15 marks because 'gameAnnotated :: Identity ([Coin],Die,Outcome)' is correct.",
  failMsg     = "'gameAnnotated :: Identity ([Coin],Die,Outcome)' did not return the correct output.",
  prop        = makeNullaryProp prop_gameAnnotated_i,
  condition   = Always
}

test_game_l = Test {
  mark        = 20,
  description = newSection ++ "Checking that 'game :: [Outcome]'\
                            \ returns all possible outcomes of six-rolls-and-a-toss...",
  successMsg  = "You got 20 marks because 'game :: [Outcome]' is correct.",
  failMsg     = "'game :: [Outcome]' did not return the correct output.",
  prop        = makeNullaryProp prop_game_l,
  condition   = Always
}

test_game_i = Test {
  mark        = 15,
  description = "Checking that 'game :: Identity Outcome' returns 'Win'...",
  successMsg  = "You got 15 marks because 'game :: Identity Outcome' is correct.",
  failMsg     = "'game :: Identity Outcome' did not return the correct output.",
  prop        = makeNullaryProp prop_game_i,
  condition   = Always
}

test_odds = Test {
  mark        = 35,
  description = newSection ++ "Checking that 'odds xs :: Float' returns the proportion of 'Win' in 'xs : [Outcome]'...",
  successMsg  = "You got 35 marks because 'odds xs :: Float' is correct.",
  failMsg     = "'odds :: Float' did not return the correct output.",
  prop        = makeUnaryProp prop_odds,
  condition   = Always
}

{- Parsing testing -}
colloquial :: Sort -> String
colloquial Sentence    = "sentence"
colloquial NP          = "NP"
colloquial VP          = "VP"
colloquial PP          = "PP"
colloquial Noun        = "noun"
colloquial Verb        = "verb"
colloquial Pronoun     = "pronoun"
colloquial ProperNoun  = "proper noun"
colloquial Nominal     = "nominal"
colloquial Determiner  = "determiner"
colloquial Preposition = "preposition"

isLexicalSort :: Sort -> Bool
isLexicalSort Noun        = True
isLexicalSort Verb        = True
isLexicalSort Pronoun     = True
isLexicalSort ProperNoun  = True
isLexicalSort Determiner  = True
isLexicalSort Preposition = True
isLexicalSort _           = False

oneOfTest :: Test
oneOfTest = Test
  {
    mark        = m
  , description = newSection ++ "Checking that your implementation of 'oneOf' is correct..."
  , successMsg  = "You got " ++ show m ++ " marks because your implementation\
                   \ of 'oneOf' worked correctly."
  , failMsg     = "Your implementation of 'oneOf' did not work correctly."
  , prop        = makeUnaryPropWith prop_oneOfCorrect arbitrarySepWords shrinkWords
  , condition   = Always
  }
  where
    m = 35

makeSoundnessTest :: (Sort, Maybe Int) -> Test
makeSoundnessTest (s,mi) = Test
  {
    mark        = m
  , description = d mi
  , successMsg  = "You got " ++ show m ++ " marks because you parser for '" ++
                   show s ++ "' parsed " ++ colloquial s ++ "s correctly."
  , failMsg     = "You parser for '" ++ show s ++ "' did not parse " ++
                  colloquial s ++ "s correctly."
  , prop        = makeUnaryPropWith (makeSoundnessProp s) (arbitrarySort (s,mi)) (\_ -> [])
  , condition   = Always
  }
  where
    t :: Int
    t = if s == VP then 4 else 3
    d :: Maybe Int -> String
    d Nothing  = "Checking that your parser for '" ++ show s ++ "' parses "
                 ++ colloquial s ++ "s correctly..."
    d (Just n) = "Checking that your parser for '" ++ show s ++ "' parses "
                 ++ colloquial s ++ "s correctly (case "
                 ++ show (n+1) ++ " of " ++ show t ++ ")..."
    m :: Int
    m = if s == Noun then
          4
        else if isLexicalSort s then
          5
        else if s == Sentence then
          28
        else if s == VP then
          8
        else if s == NP then
          case mi of Just 0 -> 11
                     Just 1 -> 11
                     Just 2 -> 11
                     _      -> undefined
        else
          33

makeNegativeTest :: Sort -> Test
makeNegativeTest s = Test
  {
    mark        = m
  , description = newSection ++
                  "Checking that you parser for '" ++ show s ++ "' rejects\
                   \ ungrammatical sentences..."
  , successMsg  = "You got " ++ show m ++ " marks because your parser for '"
                  ++ show s ++ "' rejected ungrammatical strings as expected."
  , failMsg     = "Your parser for '" ++ show s ++ "' accepted an\
                   \ ungrammatical phrase that it should have rejected."
  , prop        = makeUnaryPropWith (makeNegativeProp s)
                  (arbitraryUngrammatical p) (\_ -> [])
  , condition   = Always
  }
  where
    m = if s == Noun then
          1
        else if isLexicalSort s then
          1
        else if s == Sentence then
          2
        else if s == VP then
          3
        else
          2
    p = selectParserSolution s

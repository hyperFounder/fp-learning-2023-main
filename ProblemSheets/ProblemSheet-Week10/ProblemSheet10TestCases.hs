module ProblemSheet10TestCases where

import Types
import TestCasesUtils
import qualified ProblemSheet10          as Student
import qualified ProblemSheet10Solutions as Solution

import Control.DeepSeq
import Control.Monad.Identity
import Test.QuickCheck

import GrammarGenerators
import Parsing

{- ChanceMonad tests -}
headsOrTails :: ChanceMonad m => m Outcome
headsOrTails = do
  c <- toss
  if c == H then return Win else return Lose

instance NFData Outcome where
  rnf _ = ()

instance NFData Coin where
  rnf _ = ()

instance NFData Die where
  rnf _ = ()

instance ChanceMonad Identity where
  roll = pure D3
  toss = pure T

prop_experiments_l :: Integer -> Property
prop_experiments_l n =
  (n > 0) ==> p_seteq (Student.experiments   (headsOrTails :: [Outcome]) n)
                      (Solution.experiments (headsOrTails :: [Outcome]) n)

prop_experiments_i :: Integer -> Property
prop_experiments_i n =
  (n > 0) ==> Student.experiments   (headsOrTails :: Identity Outcome) n
           ~= Solution.experiments (headsOrTails :: Identity Outcome) n

prop_experiments_p :: Property
prop_experiments_p = (Student.experiments (headsOrTails :: [Outcome]) 0) ~= pure []

prop_gameAnnotated_l :: Property
prop_gameAnnotated_l = p_seteq (Student.gameAnnotated   :: [([Coin],Die,Outcome)])
                               (Solution.gameAnnotated :: [([Coin],Die,Outcome)])

prop_gameAnnotated_i :: Property
prop_gameAnnotated_i = (Student.gameAnnotated   :: Identity ([Coin],Die,Outcome))
                    ~= (Solution.gameAnnotated :: Identity ([Coin],Die,Outcome))

prop_game_l :: Property
prop_game_l = (p_seteq (Student.game   :: [Outcome])
                       (        game'  :: [Outcome]))
              .||.
              (p_seteq (Student.game   :: [Outcome])
                       (Solution.game  :: [Outcome]))
  where
    game' = do
      (_,_,o) <- Student.gameAnnotated
      return o

prop_game_i :: Property
prop_game_i = ((Student.game   :: Identity Outcome)
            ~= (Solution.game :: Identity Outcome))
          .||. ((game' :: Identity Outcome)
            ~=  (Solution.game :: Identity Outcome))
  where
    game' = do
      (_,_,o) <- Student.gameAnnotated
      return o

prop_odds :: [Outcome] -> Property
prop_odds xs = (length xs > 0) ==> Student.odds xs ~= Solution.odds xs

{- Parsing tests -}
instance NFData Tree where
  rnf (Leaf _ s)        = rnf s
  rnf (Branch _ [])     = ()
  rnf (Branch _ (t:ts)) = rnf <$> ts `seq` rnf t

prop_oneOfCorrect :: [String] -> Property
prop_oneOfCorrect ss =
  counterexample msg (null fails)
  where
    check :: String -> Bool
    check s = stu == sol
      where
        stu = deepseq (parse (Student.oneOf  ss) s) (parse (Student.oneOf  ss) s)
        sol = parse (Solution.oneOf ss) s

    fails = filter (not . check) ss
    cx    = deepseq
              (parse (Student.oneOf ss) (head fails))
              (parse (Student.oneOf ss) (head fails))
    msg = "Your implementation of 'oneOf' did not work correctly\
           \ on the following list of strings: " ++ show ss ++ ". " ++ "\n" ++
          "'parse (oneOf " ++ show ss ++ ") " ++ show (head fails) ++ "' gave "
          ++ show (fst . head $ cx)  ++ " but "
          ++ show (fst . head $ parse (Solution.oneOf ss) (head fails)) ++ " was expected."

prop_sortSound :: Parser Tree -> Tree -> Property
prop_sortSound p t = counterexample msg test
  where
    stu  = deepseq (parseTest p (linearise t)) (parseTest p (linearise t))
    test = stu == Just t
    msg  = "Your parser was expected to parse the phrase\n\n    "
           ++ show (linearise t) ++ "\n\nas\n\n    "
           ++ show t ++ "\n\n"
           ++ "but it"
           ++ (case stu of
                Nothing -> " rejected it as ungrammatical (i.e. returned 'Nothing')."
                Just t' ->
                  " constructed the following incorrect parse tree:\n\n    "
                  ++ show t')

selectParserStudent :: Sort -> Parser Tree
selectParserStudent Sentence    = Student.sent
selectParserStudent NP          = Student.np
selectParserStudent VP          = Student.vp
selectParserStudent PP          = Student.pp
selectParserStudent Noun        = Student.noun
selectParserStudent Verb        = Student.verb
selectParserStudent Pronoun     = Student.pronoun
selectParserStudent ProperNoun  = Student.properNoun
selectParserStudent Nominal     = Student.nominal
selectParserStudent Determiner  = Student.determiner
selectParserStudent Preposition = Student.preposition

makeSoundnessProp :: Sort -> Tree -> Property
makeSoundnessProp = prop_sortSound . selectParserStudent

makeNegativeProp :: Sort -> String -> Property
makeNegativeProp sort s = parseTest (selectParserStudent sort) s ~= Nothing

selectParserSolution :: Sort -> Parser Tree
selectParserSolution Sentence    = Solution.sent
selectParserSolution NP          = Solution.np
selectParserSolution VP          = Solution.vp
selectParserSolution PP          = Solution.pp
selectParserSolution Noun        = Solution.noun
selectParserSolution Verb        = Solution.verb
selectParserSolution Pronoun     = Solution.pronoun
selectParserSolution ProperNoun  = Solution.properNoun
selectParserSolution Nominal     = Solution.nominal
selectParserSolution Determiner  = Solution.determiner
selectParserSolution Preposition = Solution.preposition

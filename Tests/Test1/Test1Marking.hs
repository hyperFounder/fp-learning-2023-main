module Test1Marking where

import MarkingCore
import Test1TestCases
import TestCasesUtils
import Types
import qualified Test1 as Student

import Test.QuickCheck
import Control.Monad
import Data.List
import MarkingCore
import GHC.Exts (the)

main :: IO ()
main = runMarking tests True
  where
    tests = [                                     -- Total: 8 marks
              test_evenMajority_false_empty       --   1 mark
            , test_evenMajority_true_singleton    --   1 mark
            , test_evenMajority_false_singleton   --   1 mark
            , test_evenMajority_false_evenSplit   --   1 mark
            , test_evenMajority_true_large        --   2 marks
            , test_evenMajority_false_large       --   2 marks
                                                  -- Total: 8 marks
            , test_get5SmoothNumbers_zero         --   1 mark
            , test_get5SmoothNumbers_nonPositive  --   1 mark
            , test_get5SmoothNumbers_upTo25       --   2 marks
            , test_get5SmoothNumbers_upTo50       --   2 marks
            , test_get5SmoothNumbers_upTo1000     --   2 marks

                                                  -- Total: 8 marks
            , test_comesBeforeTerminalStop        --   -->  1 mark
            , test_comesBeforeInitialStop         --   -->  1 mark
            , test_comesBeforeIrreflexive         --   -->  2 marks
            , test_comesBeforeCorrect             --   -->  4 marks
                                                  -- Total: 8 marks
            , test_countApplicationsConstantTrue  --   -->  1 mark
            , test_countApplicationsRecursiveStep --   -->  3 mark
            , test_countApplicationsEasy          --   -->  1 mark
            , test_countApplicationsHard          --   -->  3 mark
                                                  -- Total: 8 marks
            , test_question5
            ]

-------------------------------------------------------------------------------
-- Tests: Question 1: Even majority
-------------------------------------------------------------------------------

test_evenMajority_false_empty = Test
  { mark        = getMarks m
  , description = newSection
                  ++
                  "Checking that 'evenMajority' returns False for the empty\
                   \ list..."
  , successMsg  = "You got " ++ show m ++ " because your 'evenMajority' function returned\
                   \ False for the empty list."
  , failMsg     = "Your 'evenMajority' function did not work correctly for the\
                   \ empty list."
  , prop        = makeNullaryProp prop_evenMajority_empty
  , condition   = Always
  }
    where
      m = Marks 1

test_evenMajority_true_singleton = Test
  { mark        = getMarks m
  , description = "Checking that 'evenMajority' returns True for lists of the\
                   \ form [n] where n is even..."
  , successMsg  = "You got " ++ show m ++ " because your 'evenMajority' function returned\
                   \ True for lists of the form [n] where n is even."
  , failMsg     = "Your 'evenMajority' function did not work correctly for\
                   \ lists of the form [n] where n is even."
  , prop        = makeUnaryPropWith
                   prop_evenMajority_true
                   ((\x -> [x]) <$> arbitraryEven)
                   (const []) -- Do not shrink the singleton list
  , condition   = Always
  }
    where
      m = Marks 1

test_evenMajority_false_singleton = Test
  { mark        = getMarks m
  , description = "Checking that 'evenMajority' returns False for lists of the\
                   \ form [n] where n is odd..."
  , successMsg  = "You got " ++ show m ++ " because your 'evenMajority' function returned\
                   \ False for lists of the form [n] where n is odd."
  , failMsg     = "Your 'evenMajority' function did not work correctly for\
                   \ lists of the form [n] where n is odd."
  , prop        = makeUnaryPropWith
                   prop_evenMajority_false
                   ((\x -> [x]) <$> arbitraryOdd)
                   (const []) -- Do not shrink the singleton list
  , condition   = Always
  }
    where
      m = Marks 1

test_evenMajority_false_evenSplit = Test
  { mark        = getMarks m
  , description = "Checking that 'evenMajority' returns False for lists with\
                   \ one odd element and one even element..."
  , successMsg  = "You got " ++ show m ++ " because your 'evenMajority' function returned\
                   \ False for lists with one odd element and one even element."
  , failMsg     = "Your 'evenMajority' function did not work correctly for\
                   \ lists with one odd element and one even element."
  , prop        = makeUnaryPropWith
                   prop_evenMajority_false
                   (arbitraryEvensAndOdds 1 1)
                   (const []) -- Do not shrink the two element list
  , condition   = Always
  }
    where
      m = Marks 1

test_evenMajority_true_large = Test
  { mark        = getMarks m
  , description = "Checking that 'evenMajority' returns True for arbitrary\
                  \ lists with more even than odd numbers..."
  , successMsg  = "You got " ++ show m ++ " because your 'evenMajority'\
                  \ function returned True for arbitrary lists with more even\
                  \ than odd numbers."
  , failMsg     = "Your 'evenMajority' function did not work correctly for\
                  \ arbitrary lists with more even than odd numbers."
  , prop        = makeUnaryPropWith
                   prop_evenMajority_true
                   (arbitraryLength 10 100 arbitraryMoreEvens)
                   shrinkEvens
  , condition   = Always
  }
    where
      m = Marks 2

test_evenMajority_false_large = Test
  { mark        = getMarks m
  , description = "Checking that 'evenMajority' returns False for arbitrary \
                  \ lists with with more (or equal) odd numbers than even..."
  , successMsg  = "You got " ++ show m ++ " because your 'evenMajority'\
                  \ function returned\
                  \ False for arbitrary lists with more (or equal) odd numbers\
                  \ than even."
  , failMsg     = "Your 'evenMajority' function did not work correctly for\
                  \ arbitrary lists with more (or equal) odd numbers than even."
  , prop        = makeUnaryPropWith
                   prop_evenMajority_false
                   (arbitraryLength 10 100 arbitraryMoreOdds)
                   shrinkOdds
  , condition   = Always
  }
    where
      m = Marks 2

-------------------------------------------------------------------------------
-- Tests: Question 2: 5-smooth numbers
-------------------------------------------------------------------------------

test_get5SmoothNumbers_zero = Test
  { mark        = getMarks m
  , description = newSection
                  ++
                  "Checking that 'get5SmoothNumbers' returns the empty list\
                  \ on the input 0..."
  , successMsg  = "You got " ++ show m ++ " because your 'get5SmoothNumbers'\
                  \ function returned the empty list on the input 0."
  , failMsg     = "Your 'get5SmoothNumbers' did not work correctly on the input\
                  \ 0."
  , prop        = makeNullaryProp (prop_get5SmoothNumbers_empty 0)
  , condition   = Always
  }
    where
      m = Marks 1

test_get5SmoothNumbers_nonPositive = Test
  { mark        = getMarks m
  , description = "Checking that 'get5SmoothNumbers' returns the empty list\
                  \ on negative inputs..."
  , successMsg  = "You got " ++ show m ++ " because your 'get5SmoothNumbers' returned\
                  \ the empty list on negative inputs."
  , failMsg     = "Your 'get5SmoothNumbers' did not work correctly on\
                  \ negative inputs."
  , prop        = makeUnaryPropWith
                    prop_get5SmoothNumbers_empty
                    arbitraryNegative
                    (\n -> enumFromTo (n + 1) (-1))
  , condition   = Always
  }
    where
      m = Marks 1

test_get5SmoothNumbers_upTo25 = Test
  { mark        = getMarks m
  , description = "Checking that 'get5SmoothNumbers' returns the correct numbers\
                  \ up to and including 25..."
  , successMsg  = "You got " ++ show m ++ " because your 'get5SmoothNumbers'\
                  \ returned the correct numbers up to and including 25."
  , failMsg     = "Your 'get5SmoothNumbers' did not work correctly on\
                  \ the input 25."
  , prop        = makeNullaryProp' prop_get5SmoothNumbers_upTo25 10000000
  , condition   = Always
  }
    where
      m = Marks 2

test_get5SmoothNumbers_upTo50 = Test
  { mark        = getMarks m
  , description = "Checking that 'get5SmoothNumbers' returns the correct numbers\
                  \ up to and including 50..."
  , successMsg  = "You got " ++ show m ++ " because your 'get5SmoothNumbers' returned\
                  \ the correct numbers up to and including 50."
  , failMsg     = "Your 'get5SmoothNumbers' did not work correctly on\
                  \ the input 50."
  , prop        = makeNullaryProp' prop_get5SmoothNumbers_upTo50 10000000
  , condition   = Always
  }
    where
      m = Marks 2

test_get5SmoothNumbers_upTo1000 = Test
  { mark        = getMarks m
  , description = "Checking that 'get5SmoothNumbers' returns the correct numbers\
                  \ up to and including 1000..."
  , successMsg  = "You got " ++ show m ++ " because your 'get5SmoothNumbers'\
                  \ returned the correct numbers up to and including 1000."
  , failMsg     = "Your 'get5SmoothNumbers' did not work correctly on\
                  \ the input 1000."
  , prop        = makeNullaryProp' prop_get5SmoothNumbers_upTo1000 15000000
  , condition   = Always
  }
    where
      m = Marks 2

-------------------------------------------------------------------------------
-- Tests: Question 3: Train stops
-------------------------------------------------------------------------------

test_comesBeforeTerminalStop :: Test
test_comesBeforeTerminalStop = Test
  { mark        = getMarks m
  , description = newSection
                  ++
                  "Checking that your 'comesBefore' function correctly"
                  ++
                  " determines that all stops besides 'BirminghamNewStreet'"
                  ++
                  " come before 'BirminghamNewStreet'..."
  , successMsg  = "You got " ++ show m ++ " as your 'comesBefore' function"
                  ++
                  " correctly determined that all stops besides 'BirminghamNewStreet'"
                  ++
                  " come before 'BirminghamNewStreet'."
  , failMsg     = "Your 'comesBefore' function incorrectly determined that "
                  ++
                  " a stop besides 'BirminghamNewStreet' comes before"
                  ++
                  " 'BirminghamNewStreet'."
  , prop        = makeUnaryPropWith
                    prop_comesBeforeTerminalStop
                    allExceptNewStreet
                    shrink
  , condition   = Always
  }
    where
      m = Marks 1

test_comesBeforeInitialStop :: Test
test_comesBeforeInitialStop = Test
  { mark        = getMarks m
  , description = "Checking that your 'comesBefore' function correctly"
                  ++
                  " determines that no stop"
                  ++
                  " comes before 'Redditch'..."
  , successMsg  = "You got " ++ show m ++ " as your 'comesBefore' function"
                  ++
                  " correctly determined that no stop"
                  ++
                  " comes before 'Redditch'."
  , failMsg     = "Your 'comesBefore' function incorrectly determined that"
                  ++
                  " a stop comes before 'Redditch'."
  , prop        = makeUnaryProp prop_comesBeforeInitialStop
  , condition   = Always
  }
    where
      m = Marks 1

test_comesBeforeIrreflexive :: Test
test_comesBeforeIrreflexive = Test
  { mark        = 2
  , description = "Checking that your 'comesBefore' function correctly"
                  ++
                  " determines that no stop"
                  ++
                  " comes before itself..."
  , successMsg  = "You got " ++ show m ++ " marks as your 'comesBefore' function"
                  ++
                  " correctly determined that no stop"
                  ++
                  " comes before itself."
  , failMsg     = "Your 'comesBefore' function incorrectly determined that"
                  ++
                  " a stop came before itself."
  , prop        = makeUnaryProp prop_comesBeforeIrreflexive
  , condition   = Always
  }
    where
      m = Marks 2

test_comesBeforeCorrect :: Test
test_comesBeforeCorrect = Test
  { mark        = getMarks m
  , description = "Checking that your 'comesBefore' function is correct..."
  , successMsg  = "You got " ++ show m ++ " as your 'comesBefore' function"
                  ++
                  " worked correctly."
  , failMsg     = "Your 'comesBefore' function did not work correctly."
  , prop        = makeBinaryProp prop_comesBeforeCorrect
  , condition   = Always
  }
    where
      m = Marks 4

-------------------------------------------------------------------------------
-- Tests: Question 4: Repeated applications of a function
-------------------------------------------------------------------------------

test_countApplicationsConstantTrue :: Test
test_countApplicationsConstantTrue = Test
  { mark        = getMarks m
  , description = newSection ++
                  "Checking that your 'countApplications' function returns '0'\
                  \ when the termination condition is constantly 'True' i.e.\
                  \ '(\\_ -> True)'..."
  , successMsg  = "You got " ++ show m ++ " because your 'countApplications'\
                  \ function worked correctly when called with the constantly true\
                  \ termination condition."
  , failMsg     = "Your 'countApplications' function did not work correctly when\
                  \ called with the constantly true termination condition."
  , prop        = makeUnaryProp prop_CountApplicationsConstantTrue
  , condition   = Always
  }
    where
      m = Marks 1

test_countApplicationsRecursiveStep :: Test
test_countApplicationsRecursiveStep = Test
  { mark        = getMarks m
  , description = "Checking that your 'countApplications' function performs the\
                  \ recursive step correctly by checking the difference between "
                  ++ indented (singleQuotes $ "countApplications divideBy2 odd 8")
                  ++ "and"
                  ++ indented (singleQuotes $ "countApplications divideBy2 odd 4")
                  ++ "is 1..."
  , successMsg  = "You got " ++ show m ++ " because your 'countApplications'\
                  \ performs the recursive step correctly."
  , failMsg     = "Your 'countApplications' function did not perform the\
                  \ recursive step correctly when tested on "
                  ++ indented (singleQuotes $ "countApplications divideBy2 odd 8")
                  ++ "and"
                  ++ indented ((singleQuotes $ "countApplications divideBy2 odd 4") ++ ".")
  , prop        = makeNullaryProp prop_CountApplicationsRecursiveStep
  , condition   = Always
  }
    where
      m = Marks 3

test_countApplicationsEasy :: Test
test_countApplicationsEasy = Test
  { mark        = getMarks m
  , description = "Checking that your 'countApplications' function returns '1'"
                  ++ " when it is called like "
                  ++ indented
                       ((singleQuotes $
                          "countApplications (\\x -> x + 42) (\\x -> x > 0) 0") ++ "...")
  , successMsg  = "You got " ++ show m ++ " because your\
                  \ 'countApplications' function returned '1'"
                  ++ " when it was called like "
                  ++ indented
                       ((singleQuotes $
                          "countApplications (\\x -> x + 42) (\\x -> x > 0) 0") ++ ".")
  , failMsg     = "Your 'countApplications' function did not return '1'"
                  ++ " when it was called like "
                  ++ indented
                       ((singleQuotes $
                          "countApplications (\\x -> x + 42) (\\x -> x > 0) 0") ++ ".")
  , prop        = makeNullaryProp prop_countApplicationsEasy
  , condition   = Always
  }
    where
      m = Marks 1

test_countApplicationsHard :: Test
test_countApplicationsHard = Test
  { mark        = getMarks m
  , description = "Checking that your function 'countApplications' returns 'k'\
                  \ when it is called like"
                  ++ indented
                       ((singleQuotes $
                          "countApplications (\\x -> x - 1) (\\x -> x <= 0) k")
                         ++ "...")
  , successMsg  = "You got " ++ show m ++ " as your 'countApplication'"
                  ++ " returned 'k' when called like"
                  ++ (indented . singleQuotes $
                        "countApplications (\\x -> x - 1) (\\x -> x <= 0) k")
  , failMsg     = "Your 'countApplications' did not work correctly when called\
                  \ like "
                  ++ (indented . singleQuotes $
                        "countApplications (\\x -> x - 1) (\\x -> x <= 0) k")
  , prop        = makeUnaryPropWith
                    prop_countApplicationsHard
                    smallPosInt
                    shrink
  , condition   = Always
  }
    where
      m = Marks 3

-------------------------------------------------------------------------------
-- Tests: Question 5: Higher order functions
-------------------------------------------------------------------------------

test_question5 :: Test
test_question5 = Test
  { mark        = getMarks m
  , description = newSection ++
                  "Checking that your function 'f' terminates for all\
                  \ terminating inputs by testing an instance of it where\
                  \ type variables 'a' and 'r' are instantiated to 'Bool'..."
  , successMsg  = "You got " ++ show m ++ " because the function 'f' you wrote\
                  \ is well-defined and is terminating for all terminating inputs."
  , failMsg     = "Your function 'f' does not seem to be well-defined i.e. it\
                  \ either crashes or is not terminating."
  , prop        = makeNullaryProp' prop_functionIsCorrect 1000000
  , condition   = Always
  }
    where
      m = Marks 8

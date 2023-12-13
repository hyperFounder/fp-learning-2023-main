#!/bin/sh

if [ "$1" = "" ]
then
    echo "You forgot to add the assignment name, e.g. 'Assessed1'."
    echo "Please run the script again with the right argument."
    exit 1
fi

if ! [ -f "$1.hs" ]
then
    echo "File '$1.hs' not found."
    echo "Are you in the correct directory?"
    exit 1
fi

echo "Trying to compile your submission..."

# Create temporary directory
temp_dir=$(mktemp -d)

ghc $1.hs -odir $temp_dir -hidir $temp_dir

if [ $? -ne 0 ]
then
    echo ""
    echo "Your file '$1.hs' did not compile."
    echo "Please fix it before submitting."
    exit 1
fi

if ! [ -f "$temp_dir/$1.o" ]
then
    echo ""
    echo "The module name in '$1.hs' does match not the filename '$1'."
    echo "Please make sure you that"
    echo -e "\t(i) your file is called something like 'TestX.hs'"
    echo -e "\t(ii) you did not change the top of the template"
    echo "and try again."
    exit 1
fi

ghc -XSafe $1.hs -odir $temp_dir -hidir $temp_dir

if [ $? -ne 0 ]
then
    echo ""
    echo "Your file did not compile with '-XSafe.'"
    echo "Did you remove '{-# LANGUAGE Safe #-}' from the template?"
    exit 1
fi

# Create file for ensuring type signatures have not been modified

cat >> $temp_dir/Signatures.hs << 'END'
{-# LANGUAGE Safe #-}
module Signatures where

import Types
import Test1

{- QUESTION 1 -}

evenMajorityTest :: [Int] -> Bool
evenMajorityTest = evenMajority

{- QUESTION 2 -}

get5SmoothNumbersTest :: Int -> [Int]
get5SmoothNumbersTest = get5SmoothNumbers

{- QUESTION 3 -}

comesBeforeTest :: TrainStop -> TrainStop -> Bool
comesBeforeTest = comesBefore

{- QUESTION 4 -}

countApplicationsTest :: (a -> a) -> (a -> Bool) -> a -> Int
countApplicationsTest = countApplications

{- QUESTION 5 -}

fTest :: (a -> a -> r) -> ((a -> r) -> a) -> r
fTest = f
END

ghc -XSafe $temp_dir/Signatures.hs -odir $temp_dir -hidir $temp_dir

if [ $? -ne 0 ]
then
    echo ""
    echo "Your file did not compile with the correct type signatures."
    echo "Did you modify the type signatures from the template?"
    exit 1
fi

echo ""
echo "All checks passed."
echo "You are ready to submit!"

# Cleanup temporary directory
rm -r $temp_dir

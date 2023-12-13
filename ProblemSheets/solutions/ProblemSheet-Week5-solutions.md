# Problem Sheet for Week 5 - Solutions 

## Text Messaging

#### Exercise 1a.

```haskell
phoneKeyboard :: Button -> [Char]
phoneKeyboard '1' = "1"
phoneKeyboard '2' = "ABC2"
phoneKeyboard '3' = "DEF3"
phoneKeyboard '4' = "GHI4"
phoneKeyboard '5' = "JKL5"
phoneKeyboard '6' = "MNO6"
phoneKeyboard '7' = "PQRS7"
phoneKeyboard '8' = "TUV8"
phoneKeyboard '9' = "WXYZ9"
phoneKeyboard '0' = " 0"
phoneKeyboard '#' = ".,"
phoneKeyboard  _  = undefined -- avoid warnings

phoneToString :: [(Button, Presses)] -> Text
phoneToString bps = phoneToStringHelper bps False

-- The second argument indicates whether we need to capitalize or not.
phoneToStringHelper :: [(Button, Presses)] -> Bool -> Text
phoneToStringHelper []               _ = []
phoneToStringHelper (('*', p) : bps) _ = phoneToStringHelper
                                          bps ((p `mod` 2) == 1)
phoneToStringHelper ((b  , p) : bps) u = if   u
                                         then c         : r
                                         else toLower c : r
  where
    cs = phoneKeyboard b
    n  = length cs
    c  = cs !! ((p - 1) `mod` n)
    r  = phoneToStringHelper bps False
```

#### Exercise 1b.

```haskell
stringToPhone :: Text -> [(Button, Presses)]
stringToPhone = concatMap charToPhone

charToPhone :: Char -> [(Button, Presses)]
charToPhone c = if   isUpper c
                then ('*',1) : [(b,p)]
                else           [(b,p)]
  where
    -- Do brute force search to avoid writing everything out by hand :)
    (b,p) = head [(b',p'+1) | b' <- '#' : ['0'..'9']    ,
                              let cs = phoneKeyboard b' ,
                              let n  = length cs - 1    ,
                              p' <- [0..n]              ,
                              toUpper c == cs !! p']
```

#### Exercise 1c.

```haskell
fingerTaps :: Text -> Presses
fingerTaps t = sum (map snd (stringToPhone t))
```

## Using Maybe Types

1. Rewrite the `head` and `tail` functions from the prelude so that
    they use the `Maybe` type constructor to indicate when provided
    the argument was empty.

	```haskell
    headMaybe :: [a] -> Maybe a
    headMaybe [] = Nothing
    headMaybe (x:_) = Just x

    tailMaybe :: [a] -> Maybe [a]
    tailMaybe [] = Nothing
    tailMaybe (_:xs) = Just xs
    ```

1. Similarly, rewrite `take :: Int -> [a] -> [a]` to use `Maybe` to indicate
    when the index is longer than the list.

	```haskell
    takeMaybe :: Int -> [a] -> Maybe [a]
    takeMaybe n [] | n == 0 = Just []
                              | otherwise = Nothing
	takeMaybe 0 x = Just []
    takeMaybe n (x:xs) =
        case takeMaybe (n-1) xs of
              Nothing -> Nothing
              Just r -> Just (x:r)
    ```

1.  A common use of the `Either` type constructor is to return information
    about a possible error condition.  Rewrite the function `zip` from the
	prelude as
	```hs
	zipEither :: [a] -> [b] -> Either String [(a,b)]
	```
	so that we only get the list of pairs when the two arguments have
	the same length.  If this is not the case, use the `String` to report
	which argument was smaller.

	```haskell
	zipEither :: [a] -> [b] -> Either String [(a,b)]
	zipEither [] [] = Right []
	zipEither [] (_:_) = Left "Left list too small"
	zipEither (_:_) [] = Left "Right list too small"
	zipEither (x:xs) (y:ys) =
	  case zipEither xs ys of
		Left msg -> Left msg
		Right r -> Right ((x,y):r)
	```

## Type Retractions

1. Recall the data type
    ```hs
	data WeekDay = Mon | Tue | Wed | Thu | Fri | Sat | Sun
				   deriving (Show, Read, Eq, Ord, Enum)
    ```
	defined in the Lecture Notes.  Define a new data type which
	represents just the **working days** of the week.  Show that
	it is a retract of the above type.

    You are expected to defined the following type and write the
    following two functions:

	```haskell
	data WorkingDay = Mon' | Tue' | Wed' | Thu' | Fri'
	  deriving (Eq, Show)

	toWeekDay :: WorkingDay -> WeekDay
	toWeekDay Mon' = Mon
	toWeekDay Tue' = Tue
	toWeekDay Wed' = Wed
	toWeekDay Thu' = Thu
	toWeekDay Fri' = Fri

	toWorkingDay :: WeekDay -> WorkingDay
	toWorkingDay Mon = Mon'
	toWorkingDay Tue = Tue'
	toWorkingDay Wed = Wed'
	toWorkingDay Thu = Thu'
	toWorkingDay Fri = Fri'
	toWorkingDay Sat = Fri'
	toWorkingDay Sun = Mon'
	```

1.  Show that the type `Maybe a` is a retract of the type `[a]`.
    You are expected to write the following two functions:

	```haskell
    toList :: Maybe a -> [a]
    toList Nothing = []
    toList (Just x) = [x]

    toMaybe :: [a] -> Maybe a
    toMaybe [] = Nothing
    toMaybe (x:_) = Just x
    ```


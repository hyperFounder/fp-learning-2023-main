# Problem Sheet for Week 5

## Text messaging
(From "Haskell Programming")

Remember old-fashioned phone inputs for writing text, where
you had to press a button multiple times to get different letters to
come up? You may still have to do this when you try to search for a
movie to watch using your television remote control. You’re going to
write code to translate sequences of button presses into strings and
vice versa.
Here is the layout of the phone:
```
-----------------------------------------
| 1      | 2 ABC | 3 DEF  |
-----------------------------------------
| 4 GHI  | 5 JKL | 6 MNO  |
-----------------------------------------
| 7 PQRS | 8 TUV | 9 WXYZ |
-----------------------------------------
| *      | 0     | # .,   |
-----------------------------------------
```
The star (`*`) capitalizes the next letter (if you press it twice, then it reverts to lower case).  If there are multiple occurrences of `*` in a row, then it is the last one which will determine the capitalization.  `0` is your space bar. To represent the digit itself, you press that digit once more than the letters it represents. If you press a button one more than is required to type the digit, it wraps around to the first letter. For example:
```
2 -> 'a'
22 -> 'b'
222 -> 'c'
2222 -> '2'
22222 -> 'a'
0 -> ' '
00 -> '0'
000 -> ' '
1 -> '1'
11 -> '1'
111 -> '1'
```
You will not need to type '#', so
```
# -> '.'
## -> ','
### -> '.'
```

 Consider the following datatypes:
```haskell
-- Valid buttons are ['0'..'9']++['*','#']
type Button = Char
-- Valid presses are [1..]
type Presses = Int
-- Valid text consists of
-- ['A'..'Z']++['a'...'z']++['0'..'9']++['.',',',' ']
type Text = String
```
#### Exercise 1a.
Write a function
```haskell
phoneToString :: [(Button, Presses)] -> Text
phoneToString = undefined
```
that takes a list of buttons and the number of times to press them and gives back the corresponding text, e.g.
```hs
phoneToString [('*',1),('6',5),('5',4)] = "M5"
```

#### Exercise 1b.
Write a function
```haskell
stringToPhone :: Text -> [(Button, Presses)]
stringToPhone = undefined
```
taking a string to a list of buttons and the number of times that they need to be pressed, e.g.
```hs
stringToPhone "Hi, students." = [('*',1),('4',2),('4',3),('#',2),('0',1),('7',4),('8',1),('8',2),('3',1),('3',2),('6',2),('8',1),('7',4),('#',1)]
```

#### Exercise 1c.
Write a function
```haskell
fingerTaps :: Text -> Presses
fingerTaps = undefined
```
that computes the minimal number of button presses needed to input the given string, e.g.
```hs
fingerTaps "Hi, students." = 27
```

## Using Maybe Types

1. Rewrite the `head` and `tail` functions from the prelude so that
    they use the `Maybe` type constructor to indicate when provided
    the argument was empty.

	```haskell
    headMaybe :: [a] -> Maybe a
    headMaybe = undefined

    tailMaybe :: [a] -> Maybe [a]
    tailMaybe = undefined
    ```

1. Similarly, rewrite `take :: Int -> [a] -> [a]` to use `Maybe` to indicate
    when the index is longer than the list.

	```haskell
    takeMaybe :: Int -> [a] -> Maybe [a]
    takeMaybe = undefined
    ```

1.  A common use of the `Either` type constructor is to return information
    about a possible error condition.  Rewrite the function `zip` from the
	prelude as

	```haskell
	zipEither :: [a] -> [b] -> Either String [(a,b)]
    zipEither = undefined
	```
	so that we only get the list of pairs when the two arguments have
	the same length.  If this is not the case, use the `String` to report
	which argument was smaller.

## Type Retractions

1. Recall the data type
    ```haskell
	data WeekDay = Mon | Tue | Wed | Thu | Fri | Sat | Sun
				   deriving (Show, Read, Eq, Ord, Enum)
    ```
	defined in the Lecture Notes.  Define a new data type which
	represents just the **working days** of the week.  Show that
	it is a retract of the above type.

    You are expected to define the following type and write the
    following two functions:

	```haskell
	data WorkingDay = ???

	toWeekDay :: WorkingDay -> WeekDay
    toWeekDay = undefined

	toWorkingDay :: WeekDay -> WorkingDay
    toWorkingDay = undefined
    ```

1.  Show that the type `Maybe a` is a retract of the type `[a]`.
    You are expected to write the following two functions:

	```hs
    toList :: Maybe a -> [a]
    toList = undefined

    toMaybe :: [a] -> Maybe a
    toMaybe = undefined
    ```


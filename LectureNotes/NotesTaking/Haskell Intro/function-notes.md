### Pattern Matching

- Pattern matching is used to specify patterns to which some data should conform and to deconstruct the data according to those patterns.
- A pattern like ```x:xs``` will bind the head of the list to x and the rest of it to xs. 
  - If the list has only a single element, then ```xs``` will simply be the empty list.
  - ```_``` means a generic variable.

- Examples, check if a list is empty

```haskell
isEmpty :: [a] -> Bool
isEmpty [] = True
isEmpty (_:_) = False
```

- Example, return the head of a list
```haskell
head' :: [a] -> a
head' [] = error "Cant call head on an empty list!"
head' (x:_) = x
```
- Example: Extracting values from ordered pairs

```haskell
first :: (a, b) -> a
first (x, y) = x
```
### Curried Functions

- In mathematics and computer science, ```currying``` is the technique of translating the evaluation of a ```function that takes multiple arguments into evaluating a sequence of functions, each with a single argument.```

### Guards

- As an alternative to using conditional expressions, functions can also be defined using ```guarded equations```, in which a sequence of logical expressions called guards is used to choose between a sequence of results of the same type.
- Example

```haskell
bmiTell :: Double -> [Char]
bmiTell bmi 
  | bmi <= 18.5 = "You're underweight, eat more"
  | bmi <= 25.0 && bmi >= 18.5 = "You're looking good"
  | otherwise = "You're obese. Go see a doctor"
```

### Where Keyword

- In this section, you’ll learn how to use Haskell’s where keyword to store the results of intermediate computations, which provides similar functionality.
- Example

```haskell
bmiTell' :: Double -> Double -> [Char]
bmiTell' weight height 
  | bmi <= skinny = "You're underweight, eat more"
  | bmi <= normal = "You're looking good"
  | otherwise = "You're obese. Go see a doctor"
  where 
    bmi = (weight / height ^ 2) * 10000
    skinny = 18
    normal = 25
```
- Example 2: Write a function that takes a list of weight/height pairs and returns a list of BMIs

```haskell
-- (Weight, Height)
funcBMI :: [(Double, Double)] -> [Double]
funcBMI list = [bmi w h | (w,h) <- list]
  where
    -- Adding a BMI Type Annotation
    bmi :: Double -> Double -> Double
    bmi w h = (w / (h ^2)) * 10000
```

### Let Keyword

- ```let keyword ``` is used to declare ```local``` variables
- ```let expressions```, on the other hand, allow you to bind to variables anywhere and are expressions themselves.
- Write a function to return a cylinder's surface area

```haskell
-- Surface Area = 2πrh + 2πr^2
-- The in keyword is used to specify the expression that represents the result of the function

cylinder :: Double -> Double -> Double
cylinder h r =
let sideArea = 2 * pi * r * h
topArea = 2 * pi * r^2
in sideArea + topArea
```

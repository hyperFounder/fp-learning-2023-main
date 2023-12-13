## Lamba Expressions 

- As an alternative to defining functions using equations, functions can also be constructed using lambda expressions
- ```lambda expressions``` comprise of a pattern for each of the arguments, a body that specifies how the result can be calculated in terms of the arguments
- They are ```nameless functions.```
 
### Here's the basic syntax of a lambda expression in Haskell:

```haskell
(\parameter1 parameter2 ... -> expression)
```

Here's a breakdown:

- The symbol \ represents the Greek letter lambda, written as ```λ```
- parameter1, parameter2, etc. are the parameters of the function.
- -> separates the parameters from the body of the function.
- expression is the body of the function, where you can use the parameters.

## Case Expresions

A ```case``` expression is used to perform pattern matching and make decisions based on the structure of a value. Here is an example:

```haskell
classifyNum :: Int -> String
classifyNum n = case n of
  0 -> "Zero"
  1 -> "One"
  2 -> "Two"
  _ -> "Other"
```
### What is a parser?
A parser is a program that takes a string of characters as input, and produces some form of tree that makes the syntactic structure of the string explicit.

- For example, the string ```2*3+4``` could be parsed into the following expression tree:
```haskell
    +
   / \
  *   4
 / \
2   3
```
### Parsers as functions

- In Haskell, a ``parser`` can naturally be viewed directly as a function that takes a string and produces a tree.
```haskell
type Parser = String -> [(Tree,String)]
```
- Finally, different ```parsers``` will likely return different kinds of trees, or more generally, any kind of value. For example, a parser for numbers might return an integer value.
```haskell
type Parser a = String -> [(a,String)]
```
- This declaration states that a parser of type ```a``` is a function that takes an input string and produces a list of results, each of which is a pair comprising a result value of type ```a``` and an output string.
  - Alternatively, the ```parser type``` can also be read as a rhyme in the style of Dr Seuss!
````text
A parser for things
Is a function from strings To lists of pairs
Of things and strings
````
### Basic definitions
- To allow the Parser type to be made into instances of classes, it is first redefined using newtype, with a dummy constructor called ```P```:
```haskell
newtype Parser a = P (String -> [(a,String)])
```
- ```Parser``` of this type can then be applied to an input string using a function that simply removes the dummy constructor:
```haskell
parse :: Parser a -> String -> [(a,String)] 
parse (P p) inp = p inp
```
- Lets define our first parsing primitive function called ```item```, which fails if the input string is empty and succeeds with the first character as the result value:
```haskell
item :: Parser Char
item = P (\inp -> case inp of
                     []     -> []
                     (x:xs) -> [(x,xs)])
```
- For example
```haskell
> parse item ""
[]
> parse item "abc"
[('a',"bc")]
```
### Sequencing parsers

- We now make the ```parser``` type into an instance of the ```functor```, ```applicative``` and ```monad``` classes, in order that the do notation can then be used to combine parsers in sequence.
- Let's make the ```Parser``` type into a ```functor```:
```haskell
instance Functor Parser where
  -- fmap :: (a -> b) -> Parser a -> Parser b
  fmap g p = P (\inp -> case parse p inp of
                           []        -> []
                           [(v,out)] -> [(g v, out)])
```
- That is, ```fmap``` applies a function to the result value of a ```parser``` if the ```parser``` succeeds, and propagates the failure otherwise.
- For example:
```haskell
> parse (fmap toUpper item) "abc"
[('A',"bc")]
> parse (fmap toUpper item) ""
[]
```
- Now, we can make the ```Parser``` type into an ```applicative``` functor:
```haskell
instance Applicative Parser where
  -- pure :: a -> Parser a
  pure v = P (\inp -> [(v,inp)])
  -- <*> :: Parser (a -> b) -> Parser a -> Parser b
  pg <*> px = P (\inp -> case parse pg inp of
                   []         -> []
                   [(g, out)] -> parse (fmap g px) out)
```
- Finally, we can make the ```Parser``` type into a monad:
```haskell
instance Monad Parser where
  -- (>>=) :: Parser a -> (a -> Parser b) -> Parser b
  p >>= f = P (\inp -> case parse p inp of
                          []        -> []
                          [(v,out)] -> parse (f v) out)
```
- That is, the parser ```p >>= f``` fails if the application of the parser ```p``` to the input string ```inp``` fails, and otherwise applies the function ```f``` to the result value ```v``` to give another parser ```f v```,which is then applied to the output string out that was produced by the first parser to give the final result.


### Parsing Arithmetic Expressions

- In this example, we consider arithmetic expressions that are built up from natural numbers using addition, multiplication and parentheses only. For example,```2+3+4``` means ```2+(3+4)```, while ```2*3+4``` means ```(2*3)+4```.
```haskell
expr ::= term (+ expr | ε)
term :: = factor (* term | ε)
factor ::= (expr) | nat
nat ::= 0 | 1 | 2 ...
```
- The above ```grammar``` can now be translated into a ```parser``` for expressions, by simply rewriting the rules using parsing primitives:
```haskell
expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             pure (t + e)
           <|> pure t

term :: Parser Int
term = do f <- factor
          do symbol "*"
             t <- term
             pure (f * t)
           <|> pure f

factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")"
            pure e
          <|> natural
```
- Note: The above ```parsers``` return the integer value of the expression that was ```parsed```, rather than some form of expression tree.
- Defining our ````evaluating function:````
```haskell
eval :: String -> Int
eval xs = case parse expr xs of
             [(n,[])]  -> n
             [(_,out)] -> error ("Unused input " ++ out)
             []        -> error "Invalid input"
```
- For example
```haskell
> eval "2*3+4"
10
> eval "2+3*4+2"
16
> eval "(2+3)*(4+2)"
30
> eval "one plus two"
*** Exception: Invalid input
```





### Recursive Types


- In haskell, new types can be declared in terms of themselves. That is, data types can be **recursive**.

```haskell
data Nat = Zero | Succ Nat
```
```haskell
Zero
Succ Zero
Succ (Succ Zero)
Succ (Succ (Succ Zero)) 
.
```
- That is, a value of type ```Nat``` is either ```Zero```, or of the form ```Succ n``` for some value ```n``` of type ```Nat```.

- In this manner, values of type ```Nat``` correspond to ```natural numbers``` with ```Zero``` ```representing``` the ```number 0```,
- ```Succ``` representing the ```successor function (1+).``` 
- For example, ```Succ (Succ (Succ Zero ))``` represents ```1 +(1 +(1 + 0)) = 3.```
- There is an ```isomorphism``` between ```Nat``` and ```Int``` via:
```haskell
nat2Int :: Nat -> Int
nat2Int Zero = 0
nat2Int (Succ n) = 1 + (nat2Int n)
```
```haskell
int2Nat :: Int -> Nat
int2Nat 0 = Zero
int2Nat n = Succ (int2Nat (n-1))
```
- For example, using these functions,``` two natural numbers``` can be ```added``` together by:
```haskell
add :: Nat -> Nat -> Int
add m n = nat2Int (m) + nat2Int (n)
```
- For example, ```add Zero (Succ Zero)``` returns ```1```.
### Lists

- The type of ```lists``` is predefined by
```haskell
data [a] = [] | a : [a]  -- not quite a Haskell definition (syntactically wrong)
```
- This is an example of a ```recursive``` data type definition. We have the following types for the list constructors:

```haskell
[]  :: [a]
(:) :: a -> [a] -> [a]
```
- If we don't care about ```syntax```, we can define an ```isomorphic``` version as follows:
```haskell
data List a = Nil | Cons a (List a)
```
- Then the ```types of the constructors``` are

```haskell
Nil  :: List a
Cons :: a -> List a -> List a
```

#### Example

- The native list `````[1,2,3]````` is written as `````1 : 2 : 3 : []`````
- The native list `````[1,2,3]````` is also written ```Cons 1 (Cons 2 (Cons 3 Nil))``` in our ```isomorphic version.``` 
- Let's define the ```isomorphism``` to make this clear:

```haskell
nativelist2ourlist :: [a] -> List a
nativelist2ourlist []     = Nil
nativelist2ourlist (x:xs) = Cons x (nativelist2ourlist xs)

ourlist2nativelist :: List a -> [a]
ourlist2nativelist Nil         = []
ourlist2nativelist (Cons x xs) = x:ourlist2nativelist xs
```

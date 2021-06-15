module E2

palindrome : Nat -> String -> Bool
palindrome len str =
  if length str < len then
    False
  else
    reverse str == str


counts : String -> (Nat, Nat)
counts str =
  (length (words str), length str)


top_ten : Ord a => List a -> List a
top_ten list =
  take 10 (reverse (sort list))


over_length : Nat -> List String -> Nat
over_length len list =
  length wordsLongerThanLen
  where
    longerThanLen : String -> Bool
    longerThanLen str = (length str) > len

    wordsLongerThanLen : List String
    wordsLongerThanLen = filter longerThanLen list

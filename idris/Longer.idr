longer : String -> String -> Nat
longer word1 word2
  = let len1 = length word1
        len2 = length word2
        len3 = len1 + len2 in
        len3

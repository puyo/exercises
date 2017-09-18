let rec sum xs =
  match xs with
    | []       -> 0                (* yield 0 if xs has the form [] *)
    | x :: xs' -> x + sum xs'      (* recursive call if xs has the form x::xs' for suitable x and xs' *)
;;

print_endline "hi";
print_int sum [1;2;3;4;5]

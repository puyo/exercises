fizzbuzz = fn
  0, 0, _ -> "FizzBuzz"
  0, _, _ -> "Fizz"
  _, 0, _ -> "Buzz"
  _, _, a -> a
end

IO.puts fizzbuzz.(0, 0, 1)
IO.puts fizzbuzz.(0, 1, 1)
IO.puts fizzbuzz.(1, 0, 1)
IO.puts fizzbuzz.(1, 1, 1203)

remfb = fn n -> fizzbuzz.(rem(n, 3), rem(n, 5), n) end

IO.puts remfb.(10)
IO.puts remfb.(11)
IO.puts remfb.(12)
IO.puts remfb.(13)
IO.puts remfb.(14)
IO.puts remfb.(15)
IO.puts remfb.(16)

add_both = &(&1 + &2 + 1)
IO.puts add_both.(1, 2)


speak = &IO.puts/1
speak.("hi there")

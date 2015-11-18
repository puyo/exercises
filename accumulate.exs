# # Accumulate

# For example, given the collection of numbers:

# - 1, 2, 3, 4, 5

# And the operation:

# - square a number

# Your code should be able to produce the collection of squares:

# - 1, 4, 9, 16, 25

# ## Optional Extras

# - Square Root a Number
# - Cube a number
# - Even and Odd
# - Or return an object containing all of those things:

#   ```
#   {
#     original: [1, 2, 3, 4, 5],
#     squares: [...],
#     squareRoots: [...],
#     cubes: [...],
#     evenAndOdd: [true, false, true]
#   }
#   ```

# ## Restrictions

# Keep your hands off that collect/map/fmap/whatchamacallit functionality
# provided by your standard library!

# Solve this one yourself using other basic tools instead.

# (I don't think Elixir *has* more basic tools...)

square = fn x -> x * x end
cube = fn x -> x * x * x end
even = fn x -> rem(x, 2) == 0 end
root = fn x -> :math.sqrt(x) end

x = [1, 2, 3, 4, 5]
IO.inspect x
IO.inspect Enum.map(x, square)
IO.inspect Enum.map(x, cube)
IO.inspect Enum.map(x, even)
IO.inspect Enum.map(x, root)

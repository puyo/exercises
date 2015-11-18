# # Allergies Warmup

# An allergy test produces a single numeric score which contains the
# information about all the allergies the person has (that they were tested
# for).

# The list of items (and their value) that were tested are:

# * eggs (1)
# * peanuts (2)
# * shellfish (4)
# * strawberries (8)
# * tomatoes (16)
# * chocolate (32)
# * pollen (64)
# * cats (128)

# So if Tom is allergic to peanuts and chocolate, he gets a score of 34.

# Now, given just that score of 34, your program should be able to say:

# - Whether Tom is allergic to any one of those allergens listed above.
# - All the allergens Tom is allergic to.

defmodule Allergies do
  use Bitwise, only_operators: true

  @allergens String.split "eggs peanuts shellfish strawberries tomatoes chocolate pollen cats"

  def allergic?(code, allergen) do
    index = Enum.find_index @allergens, fn x -> x == allergen end
    is_match?(code, index)
  end

  def allergens(code) do
    @allergens
      |> Enum.with_index
      |> Enum.filter(fn {_, index} -> is_match?(code, index) end)
      |> Enum.map(fn {item, _} -> item end)
  end

  defp is_match?(code, index) do
    (code &&& (1 <<< index)) > 0
  end
end

IO.inspect Allergies.allergens(4)  # shellfish
IO.inspect Allergies.allergens(34) # peanuts, chocolate
IO.inspect Allergies.allergic?(34, "peanuts") # true
IO.inspect Allergies.allergic?(34, "shellfish") # false

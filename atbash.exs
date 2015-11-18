# The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the alphabet such that the resulting alphabet is backwards. The first letter is replaced with the last letter, the second with the
# second-last, and so on.

# An Atbash cipher for the Latin alphabet would be as follows:

# ```plain
# Plain:  abcdefghijklmnopqrstuvwxyz
# Cipher: zyxwvutsrqponmlkjihgfedcba
# ```

# It is a very weak cipher because it only has one possible key, and it is a
# simple monoalphabetic substitution cipher. However, this may not have been an issue in the cipher's time.

# ## Examples
# - Encoding "test" gives "gvhg"
# - Decoding "gvhg" gives "test"

defmodule Atbash do
  @atoz Enum.zip ?a..?z, ?z..?a
  @forward Enum.reduce @atoz, %{}, fn {c0, c1}, acc ->
    Map.put(acc, c0, c1)
  end
  @backward Enum.reduce @atoz, %{}, fn {c0, c1}, acc ->
    Map.put(acc, c1, c0)
  end

  def encode(word) do
    tr word, @forward
  end

  def decode(word) do
    tr word, @backward
  end

  defp tr(word, map) do
    to_string word
      |> String.to_char_list
      |> Enum.map &Dict.get(map, &1)
  end
end

IO.inspect Atbash.encode("test") # gvhg
IO.inspect Atbash.decode("gvhg") # test

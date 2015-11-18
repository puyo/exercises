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
  @alphabet "abcdefghijklmnopqrstuvwxyz"
  @chars String.split(@alphabet, "")
  @reverse_chars String.split(String.reverse(@alphabet), "")

  def encode(word) do
    Enum.join word
      |> String.codepoints
      |> Enum.map fn c -> encode_char(c, @chars, @reverse_chars) end
  end

  def decode(word) do
    Enum.join word
      |> String.codepoints
      |> Enum.map fn c -> encode_char(c, @chars, @reverse_chars) end
  end

  defp encode_char(c, from, to) do
    Enum.at to, Enum.find_index(from, fn x -> x == c end)
  end
end

IO.inspect Atbash.encode("test") # gvhg
IO.inspect Atbash.decode("gvhg") # test

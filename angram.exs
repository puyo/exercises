# Given `"listen"` and a list of candidates like `"enlists" "google" "inlets"
# "banana"` the program should return a list containing `"inlets"`.

defmodule Angram do
  def angrams(word, all_words) do
    sw = sorted(word)
    all_words |> Enum.filter fn w -> sw == sorted(w) end
  end

  defp sorted(word) do
    word |> String.codepoints |> Enum.sort
  end
end

IO.inspect Angram.angrams("listen", ~w(enlists google inlets))

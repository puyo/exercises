defmodule PrintCentered do
  def center(words) do
    width = words |> Enum.map(&String.length/1) |> Enum.max
    Enum.each(words, fn w ->
      IO.puts pad_centered(w, width)
    end)
  end

  defp pad_centered(word, width) do
    spaces = width - String.length(word)
    r = div(spaces, 2)
    l = spaces - r
    [
      String.duplicate(" ", l),
      word,
      String.duplicate(" ", r)
    ] |> Enum.join
  end
end

PrintCentered.center(["∂∂∂∂∂", "∂og", "giraffe", "elephant man"])

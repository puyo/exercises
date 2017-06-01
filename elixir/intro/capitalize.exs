defmodule Caps do

  def capitalize_sentences(text) do
    _upper(text)
  end

  defp _upper(text)
  defp _upper(""), do: ""
  defp _upper(<< head :: utf8, tail :: binary >>) do
    String.upcase(<<head>>) <> _lower(tail)
  end

  defp _lower(text)
  defp _lower(""), do: ""
  defp _lower(". " <> rest), do: ". " <> _upper(rest)
  defp _lower(<< head :: utf8, tail :: binary >>) do
    String.downcase(<<head>>) <> _lower(tail)
  end
end

IO.inspect Caps.capitalize_sentences("oh. a DOG. woof. ") # "Oh. A dog. Woof. "

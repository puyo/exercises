defmodule MyList do
  def span(from, to) when is_integer(from) and is_integer(to) do
    _span(from, to)
  end
  defp _span(from, to) when from < to, do: [from | _span(from + 1, to)]
  defp _span(from, to) when from > to, do: [from | _span(from - 1, to)]
  defp _span(from, _to), do: [from]

  def primes(n) when n > 2 do
    multiples = for x <- 2..n, y <- 2..n, x <= y, do: x*y
    Enum.to_list(2..n) -- multiples
  end
end

IO.inspect MyList.primes(50)

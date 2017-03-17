defmodule MyList do
  def mapsum([], _func), do: 0
  def mapsum([head | tail], func) do
    func.(head) + mapsum(tail, func)
  end

  def max([]), do: nil
  def max([head | tail]), do: _max(tail, head)
  defp _max([], best), do: best
  defp _max([head | tail], best) when head > best do
    _max(tail, head)
  end
  defp _max([_head | tail], best) do
    _max(tail, best)
  end

  def caesar(list, n)
  def caesar([], _), do: []
  def caesar([head | tail], n) do
    r = rem(head - ?a + n, ?z - ?a + 1) + ?a
    [ r | caesar(tail, n)]
  end

  def span(from, to) when is_integer(from) and is_integer(to) do
    _span(from, to)
  end
  defp _span(from, to) when from < to, do: [from | _span(from + 1, to)]
  defp _span(from, to) when from > to, do: [from | _span(from - 1, to)]
  defp _span(from, _to), do: [from]

  def primes(n) when n > 2 do
    all = for x <- 2..n, y <- 2..n, x <= y, do: x*y
    Enum.to_list(2..n) -- all
  end
end

# IO.puts MyList.mapsum([1,2,3], &(&1 * &1))

# IO.puts MyList.max([1,20,3])
# IO.puts MyList.max([])

# IO.puts MyList.caesar('ryvkve', 13)

# IO.inspect MyList.span(1, 1)
# IO.inspect MyList.span(1, 10)
# IO.inspect MyList.span(10, 1)
# IO.inspect MyList.span(10.5, 1)

IO.inspect MyList.primes(50)

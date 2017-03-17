defmodule Functions do
  def sum(1), do: 1
  def sum(n), do: n + sum(n - 1)

  def gcd(x, 0), do: x
  def gcd(x, y), do: gcd(y, rem(x, y))
end

IO.puts Functions.sum(4) # => 4 + 3 + 2 + 1 = 10

IO.puts Functions.gcd(15, 21)
IO.puts Functions.gcd(15, 11)


defmodule Chop do
  def guess(actual, min..max) do
    h = halfway(min..max)
    IO.puts "Is it #{h}"
    _guess(actual, h, min..max)
  end

  defp _guess(actual, actual, _), do: actual
  defp _guess(actual, current, min..max) when actual < current do
    guess(actual, min..current)
  end
  defp _guess(actual, current, min..max) when actual > current do
    guess(actual, current..max)
  end
  defp halfway(a..b), do: a + div(b - a, 2)
end

IO.puts "-"
IO.puts Chop.guess(274, 1..1000)
IO.puts Chop.guess(11, 10..20)


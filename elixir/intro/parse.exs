
defmodule Parse do
  def printable?(str) do
    Enum.all?(str, fn x -> x in ?\s..?~ end)
  end

  def anagram?(word1, word2) do
    sorted1 = word1 |> String.codepoints |> Enum.sort
    sorted2 = word2 |> String.codepoints |> Enum.sort
    sorted1 === sorted2
  end

  # cheaty regex version

  # @calc_regexp ~r"(\d+) ([+*/\-]) (\d+)"
  # def calculate(expr) do
  #   [_, x, op, y] = Regex.run @calc_regexp, List.to_string(expr)
  #   IO.inspect [String.to_integer(x), op, String.to_integer(y)]
  #   do_calc(String.to_integer(x), op, String.to_integer(y))
  # end

  # defp do_calc(x, "+", y), do: x + y
  # defp do_calc(x, "-", y), do: x - y
  # defp do_calc(x, "*", y), do: x * y
  # defp do_calc(x, "/", y), do: x / y


  # version with no regex

  def calculate(expr) do
    {x, rest} = number(expr)
    rest = Enum.drop_while(rest, fn x -> x == ?\s end)
    [op|rest] = rest
    rest = Enum.drop_while(rest, fn x -> x == ?\s end)
    {y, rest} = number(rest)
    do_calc(x, op, y)
  end

  def number([ ?- | tail ]) do
    {val, rest} = _number_digits(tail, 0)
    {val * -1, rest}
  end
  def number([ ?+ | tail ]), do: _number_digits(tail, 0)
  def number(str), do: _number_digits(str, 0)

  defp _number_digits([ digit | tail ], value)
  when digit in '0123456789' do
    _number_digits(tail, value*10 + digit - ?0)
  end
  defp _number_digits(rest, value), do: {value, rest}

  defp do_calc(x, ?+, y), do: x + y
  defp do_calc(x, ?-, y), do: x - y
  defp do_calc(x, ?*, y), do: x * y
  defp do_calc(x, ?/, y), do: x / y
end

Parse.printable?([1,2,3]) |> IO.inspect
Parse.printable?('one') |> IO.inspect

Parse.anagram?("one", "oen") |> IO.inspect
Parse.anagram?("ona", "oen") |> IO.inspect

Parse.calculate('119 + -24') |> IO.inspect

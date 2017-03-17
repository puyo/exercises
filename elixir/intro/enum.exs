# deck = for rank <- '23456789TJQKA', suit <- 'CDHS', do: [suit, rank]

# IO.inspect [68, 68]
# IO.inspect deck

defmodule MyList do
  def all?([], _), do: true
  def all?([h|t], f) do
    if not f.(h) do
      false
    else
      all?(t, f)
    end
  end

  def each([], _) do
    nil
  end
  def each([h|t], f) do
    f.(h)
    each(t, f)
  end

  def filter([], _f), do: []
  def filter([h|t], f) do
    if f.(h) do
      [h|filter(t, f)]
    else
      filter(t, f)
    end
  end

  def split(enum, count) do
    _split([], enum, count)
  end
  defp _split(l, r, 0) do
    {l, r}
  end
  defp _split(l, [h|t], count) when count > 0 do
    _split([h|l], t, count - 1)
  end

  def take(_, 0) do
    []
  end
  def take([h|t], count) when count > 0 do
    [h|take(t, count - 1)]
  end

  def flatten([]) do
    []
  end
  def flatten([h|t]) when is_list(h) do
    flatten(h) ++ flatten(t)
  end
  def flatten([h|t]) do
    [h|flatten(t)]
  end
end

MyList.all?([5,1,2,5], fn x -> x >= 1 end) |> IO.inspect
MyList.all?([5,1,2,5], fn x -> x > 1 end) |> IO.inspect
MyList.filter([5,1,2,5], fn x -> x < 4 end) |> IO.inspect
MyList.each([5,1,2,5], fn x -> IO.inspect x end)

IO.inspect MyList.split([5,1,2,5], 3) # {[5,1,2], [5]}
IO.inspect MyList.take([5,1,2,5], 3) # {[5,1,2}

IO.inspect MyList.flatten([5,[1,[2]],[[[3]]]]) # [5,1,2,3]

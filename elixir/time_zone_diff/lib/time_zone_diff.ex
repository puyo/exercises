defmodule TimeZoneDiff do
  def time_zone_changes(time_zone) do
    year = DateTime.utc_now().year
    midnight = ~T[00:00:00.000]

    {:ok, start_of_year} = Date.new(year, 1, 1)
    {:ok, end_of_year} = Date.new(year + 1, 1, 1)
    {:ok, from_dt} = DateTime.new(start_of_year, midnight, "Etc/UTC")
    {:ok, until_dt} = DateTime.new(end_of_year, midnight, "Etc/UTC")
    {:ok, periods} = Tzdata.periods(time_zone)

    {from_gregorian, _} = from_dt |> DateTime.to_gregorian_seconds()
    {until_gregorian, _} = until_dt |> DateTime.to_gregorian_seconds()

    periods
    |> Enum.filter(fn %{from: %{utc: utc_from}} ->
      utc_from != :min &&
        from_gregorian <= utc_from && utc_from <= until_gregorian
    end)
    |> Enum.map(fn %{from: %{utc: utc_from}, zone_abbr: zone} ->
      {utc_from |> DateTime.from_gregorian_seconds(), time_zone, zone}
    end)
  end

  def all_time_zone_changes(time_zones) do
    time_zones
    |> Enum.flat_map(&time_zone_changes/1)
    |> Enum.sort_by(fn {dt, _, _} -> DateTime.to_unix(dt) end)
  end
end

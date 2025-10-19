defmodule TimeZoneDiffTest do
  use ExUnit.Case

  test "greets the world" do
    # TimeZoneDiff.time_zone_changes("US/Eastern") |> IO.inspect()
    # TimeZoneDiff.time_zone_changes("Australia/Sydney") |> IO.inspect()

    TimeZoneDiff.all_time_zone_changes(["US/Eastern", "Australia/Sydney", "Europe/Amsterdam"]) |> IO.inspect()
  end
end

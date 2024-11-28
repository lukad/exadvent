defmodule Elixir.Advent.Solutions.Year2022.Day04 do
  @moduledoc false

  use Advent.Solution,
    year: 2022,
    day: 4,
    example_input: """
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """,
    example_output: [2, 4]

  defp parse(input) do
    input
    |> String.split(~r/,|-|\n/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
  end

  def part_one(input) do
    input
    |> parse()
    |> Enum.count(fn [a, b, c, d] -> (a >= c && b <= d) || (c >= a && d <= b) end)
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.count(fn [a, b, c, d] -> a <= d && b >= c end)
  end
end

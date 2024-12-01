defmodule Elixir.Advent.Solutions.Year2024.Day01 do
  @moduledoc false

  use Advent.Solution,
    year: 2024,
    day: 1,
    example_input: """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """,
    example_output: [11, 31]

  defp parse(input) do
    input
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> {a, b} end)
    |> Enum.unzip()
  end

  def part_one(input) do
    {left, right} = parse(input)
    left = Enum.sort(left)
    right = Enum.sort(right)

    Enum.zip([left, right])
    |> Enum.reduce(0, fn {a, b}, sum ->
      sum + abs(a - b)
    end)
  end

  def part_two(input) do
    {left, right} = parse(input)
    right_counts = Enum.frequencies(right)

    left
    |> Enum.reduce(0, fn x, sum ->
      sum + x * Map.get(right_counts, x, 0)
    end)
  end
end

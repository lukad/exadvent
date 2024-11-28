defmodule Advent.Solutions.Year2022.Day01 do
  use Advent.Solution,
    year: 2022,
    day: 1,
    example_input: """
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    """,
    example_output: [24000, 45000]

  def parse_stacks(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn lines ->
      lines
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
  end

  def part_one(input) do
    input
    |> parse_stacks()
    |> Enum.max()
  end

  def part_two(input) do
    input
    |> parse_stacks()
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end
end

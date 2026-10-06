defmodule Elixir.Advent.Solutions.Year2025.Day01 do
  @moduledoc false

  use Advent.Solution,
    year: 2025,
    day: 1,
    example_input: """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """,
    example_output: [3, 6]

  def part_one(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn turn, {dial, count} ->
      dial = Integer.mod(dial + turn, 100)
      count = if dial == 0, do: count + 1, else: count
      {dial, count}
    end)
    |> elem(1)
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn turn, {dial, count} ->
      offset = if turn >= 0, do: dial, else: Integer.mod(-dial, 100)
      crossings = div(offset + abs(turn), 100)
      {Integer.mod(dial + turn, 100), count + crossings}
    end)
    |> elem(1)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "L" <> rest -> -String.to_integer(rest)
      "R" <> rest -> String.to_integer(rest)
    end)
  end
end

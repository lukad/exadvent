defmodule Elixir.Advent.Solutions.Year2022.Day03 do
  @moduledoc false

  use Advent.Solution,
    year: 2022,
    day: 3,
    example_input: """
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    """,
    example_output: [157, 70]

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
    |> Enum.map(&Enum.chunk_every(&1, div(length(&1), 2)))
    |> Enum.map(fn [left, right] -> MapSet.intersection(MapSet.new(left), MapSet.new(right)) end)
    |> Enum.flat_map(&MapSet.to_list/1)
    |> Enum.map(&to_priority/1)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] -> a |> MapSet.intersection(b) |> MapSet.intersection(c) end)
    |> Enum.flat_map(&MapSet.to_list/1)
    |> Enum.map(&to_priority/1)
    |> Enum.sum()
  end

  defp to_priority(char) when char in ?a..?z, do: 1 + char - ?a
  defp to_priority(char) when char in ?A..?Z, do: 1 + char - ?A + 26
end

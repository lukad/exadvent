defmodule Advent.Solutions.Year2023.Day02 do
  @moduledoc false

  use Advent.Solution,
    year: 2023,
    day: 2,
    example_input: """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """,
    example_output: [8, 2286]

  defp parse_game(input) do
    [<<"Game ", id::binary>>, rest] = String.split(input, ": ", trim: true)
    id = String.to_integer(id)

    sets =
      rest
      |> String.split("; ", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(", ", trim: true)
        |> Enum.map(fn cube ->
          [count, color] = String.split(cube, " ", trim: true)
          {color, String.to_integer(count)}
        end)
        |> Enum.into(%{})
      end)
      |> Enum.reduce(fn acc, set ->
        Map.merge(acc, set, fn _, a, b -> max(a, b) end)
      end)

    %{id: id, colors: sets}
  end

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_game/1)
    |> Enum.filter(fn %{colors: colors} ->
      colors["red"] <= 12 && colors["green"] <= 13 && colors["blue"] <= 14
    end)
    |> Enum.map(& &1.id)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_game/1)
    |> Enum.map(fn %{colors: colors} -> colors["red"] * colors["green"] * colors["blue"] end)
    |> Enum.sum()
  end
end

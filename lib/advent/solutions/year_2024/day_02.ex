defmodule Elixir.Advent.Solutions.Year2024.Day02 do
  @moduledoc false

  use Advent.Solution,
    year: 2024,
    day: 2,
    example_input: """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """,
    example_output: [2, 4]

  def sign(0), do: 0
  def sign(n) when n > 0, do: 1
  def sign(n) when n < 0, do: -1

  defp is_safe?(report, sign, skipped \\ false)

  defp is_safe?([], _sign, _skipped), do: true

  defp is_safe?(report, sign, skipped) do
    safe =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
      |> Enum.all?(&(abs(&1) <= 3 && sign(&1) == sign))

    cond do
      safe ->
        true

      !skipped ->
        Enum.any?(0..(length(report) - 1), fn i ->
          is_safe?(List.delete_at(report, i), sign, true)
        end)

      skipped ->
        false
    end
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
  end

  def part_one(input) do
    input
    |> parse()
    |> Enum.count(fn report ->
      is_safe?(report, -1, true) || is_safe?(report, 1, true)
    end)
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.count(fn report ->
      is_safe?(report, -1) || is_safe?(report, 1)
    end)
  end
end

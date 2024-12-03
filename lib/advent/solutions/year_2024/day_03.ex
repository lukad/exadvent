defmodule Elixir.Advent.Solutions.Year2024.Day03 do
  @moduledoc false

  use Advent.Solution,
    year: 2024,
    day: 3,
    example_input: [
      "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))",
      "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    ],
    example_output: [161, 48]

  def part_one(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def part_two(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/, input)
    |> Enum.reduce({0, true}, fn
      [_, a, b], {acc, true} -> {acc + String.to_integer(a) * String.to_integer(b), true}
      [_, _, _], {acc, false} -> {acc, false}
      ["do()"], {acc, _} -> {acc, true}
      ["don't()"], {acc, _} -> {acc, false}
    end)
    |> elem(0)
  end
end

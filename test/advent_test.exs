defmodule AdventTest do
  use ExUnit.Case, async: true
  doctest Advent

  defp example_for_part(inputs, index) when is_list(inputs), do: Enum.at(inputs, index)

  defp example_for_part(input, _index) when is_binary(input), do: input

  defp run_part(module, part, input), do: apply(module, part, [input])

  Advent.Solution.solutions()
  |> Enum.each(fn module ->
    @module module

    @tag id: "#{module.__solution__(:year)}-#{module.__solution__(:day)}-1"
    test "year #{module.__solution__(:year)} day #{module.__solution__(:day)} part one" do
      example_input = example_for_part(@module.__solution__(:example_input), 0)
      [part_one_expected, _] = @module.__solution__(:example_output)
      assert run_part(@module, :part_one, example_input) == part_one_expected
    end

    @tag id: "#{module.__solution__(:year)}-#{module.__solution__(:day)}-2"
    test "year #{module.__solution__(:year)} day #{module.__solution__(:day)} part two" do
      example_input = example_for_part(@module.__solution__(:example_input), 1)
      [_, part_two_expected] = @module.__solution__(:example_output)
      assert run_part(@module, :part_two, example_input) == part_two_expected
    end
  end)
end

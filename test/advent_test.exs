defmodule AdventTest do
  use ExUnit.Case, async: true
  doctest Advent

  Advent.Solution.solutions()
  |> Enum.each(fn module ->
    @module module

    @tag id: "#{module.__solution__(:year)}-#{module.__solution__(:day)}-1"
    test "year #{module.__solution__(:year)} day #{module.__solution__(:day)} part one" do
      example_input = @module.__solution__(:example_input)

      example_input =
        if is_list(example_input) do
          Enum.at(example_input, 0)
        else
          example_input
        end

      [part_one_expected, _] = @module.__solution__(:example_output)
      assert @module.part_one(example_input) == part_one_expected
    end

    @tag id: "#{module.__solution__(:year)}-#{module.__solution__(:day)}-2"
    test "year #{module.__solution__(:year)} day #{module.__solution__(:day)} part two" do
      example_input = @module.__solution__(:example_input)

      example_input =
        if is_list(example_input) do
          Enum.at(example_input, 1)
        else
          example_input
        end

      [_, part_two_expected] = @module.__solution__(:example_output)
      assert @module.part_two(example_input) == part_two_expected
    end
  end)
end

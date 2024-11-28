defmodule Elixir.Advent.Solutions.Year2023.Day01 do
  @moduledoc false

  use Advent.Solution,
    year: 2023,
    day: 1,
    example_input: [
      """
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
      """,
      """
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
      """
    ],
    example_output: [142, 281]

  defguardp is_digit?(c) when c in ?0..?9

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      digits =
        line
        |> String.to_charlist()
        |> Enum.filter(&is_digit?/1)
        |> Enum.map(&(&1 - 0x30))

      List.first(digits) * 10 + List.last(digits)
    end)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      nums = find_digits(line, [])
      List.first(nums) * 10 + List.last(nums)
    end)
    |> Enum.sum()
  end

  defp find_digits("", acc), do: Enum.reverse(acc)

  defp find_digits(<<x::8, rest::binary>>, acc) when is_digit?(x) do
    find_digits(rest, [x - ?0 | acc])
  end

  defp find_digits(<<_::8, rest::binary>> = s, acc) do
    case s do
      <<"one", _::binary>> -> find_digits(rest, [1 | acc])
      <<"two", _::binary>> -> find_digits(rest, [2 | acc])
      <<"three", _::binary>> -> find_digits(rest, [3 | acc])
      <<"four", _::binary>> -> find_digits(rest, [4 | acc])
      <<"five", _::binary>> -> find_digits(rest, [5 | acc])
      <<"six", _::binary>> -> find_digits(rest, [6 | acc])
      <<"seven", _::binary>> -> find_digits(rest, [7 | acc])
      <<"eight", _::binary>> -> find_digits(rest, [8 | acc])
      <<"nine", _::binary>> -> find_digits(rest, [9 | acc])
      _ -> find_digits(rest, acc)
    end
  end
end

defmodule Advent.Solution do
  @callback year() :: non_neg_integer()
  @callback day() :: non_neg_integer()
  @callback part_one(String.t()) :: any()
  @callback part_two(String.t()) :: any()

  @spec solutions() :: [module()]
  def solutions do
    :application.get_key(:advent, :modules)
    |> then(fn {:ok, modules} -> modules end)
    |> Enum.filter(fn module ->
      Advent.Solution in Keyword.get(module.__info__(:attributes), :behaviour, [])
    end)
  end

  @spec solution(non_neg_integer(), non_neg_integer()) :: module()
  def solution(year, day) do
    solutions()
    |> Enum.find(fn module ->
      module.year() == year and module.day() == day
    end)
  end

  defmacro __using__(opts) do
    year = Keyword.fetch!(opts, :year)
    day = Keyword.fetch!(opts, :day)
    example_input = Keyword.fetch!(opts, :example_input)
    example_output = Keyword.fetch!(opts, :example_output)

    quote do
      @behaviour Advent.Solution

      @doc """
      The year this solution is for.
      """
      def year, do: unquote(year)

      @doc """
      The day this solution is for.
      """
      def day, do: unquote(day)

      def part_one(_input), do: raise("Not implemented")
      def part_two(_input), do: raise("Not implemented")

      @doc false
      def __solution__(_)
      def __solution__(:year), do: year()
      def __solution__(:day), do: day()
      def __solution__(:example_input), do: unquote(example_input)
      def __solution__(:example_output), do: unquote(example_output)

      defoverridable part_one: 1, part_two: 1
    end
  end
end

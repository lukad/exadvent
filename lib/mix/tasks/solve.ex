defmodule Mix.Tasks.Solve do
  @moduledoc """
  This task is used to solve the Advent of Code problems.
  It takes care of fetching the input, running the solution and submitting the answer.

  ## Examples

      # Solve the current day's problem
      mix solve

      # Solve a specific problem
      mix solve --year 2023 --day 13 --part 2

  ## Options

  * `--year` - the year of the problem (defaults to the current year)
  * `--day` - the day of the problem (defaults to the current day)
  * `--part` - the part of the problem to solve (defaults to 1)
  * `--input` - the input to use (defaults to fetching the input)
  * `--submit` - submit the answer to the Advent of Code website (defaults to false)
  * `--benchmark` - benchmark the solution (defaults to false)
  """
  @shortdoc "Solve the Advent of Code problems"

  use Mix.Task

  require Logger

  @options [
    year: :integer,
    day: :integer,
    part: :integer,
    input: :string,
    submit: :boolean,
    benchmark: :boolean
  ]

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case OptionParser.parse!(args, strict: @options) do
      {opts, []} ->
        if Keyword.get(opts, :benchmark), do: benchmark(opts), else: solve(opts)

      {_opts, _args} ->
        Mix.Tasks.Help.run(["solve"])
    end
  end

  defp fetch_input(year, day) do
    path = Path.join([:code.priv_dir(:advent), "inputs", "#{year}", "#{day}.txt"])

    if File.exists?(path) do
      File.read!(path)
    else
      Logger.info("Fetching input")
      input = Advent.Input.fetch(year, day)
      File.write!(path, input)
      input
    end
  end

  defp solution_info(opts) do
    today = Date.utc_today()
    year = Keyword.get(opts, :year, today.year)
    day = Keyword.get(opts, :day, today.day)
    part = Keyword.get(opts, :part, 1)

    %{
      year: year,
      day: day,
      part: part
    }
  end

  defp solution(%{year: year, day: day, part: part}) do
    case Advent.Solution.solution(year, day) do
      nil ->
        Logger.error("No solution found for year #{year} day #{day}")
        {:error, :no_solution}

      solution ->
        case part do
          1 ->
            {:ok, {solution, :part_one}}

          2 ->
            {:ok, {solution, :part_two}}

          _ ->
            Logger.error("Invalid part: #{part}")
            {:error, :invalid_part}
        end
    end
  end

  defp solve(opts) do
    %{year: year, day: day, part: part} = info = solution_info(opts)
    Logger.metadata(year: year, day: day, part: part)

    input =
      case Keyword.get(opts, :input) do
        nil -> fetch_input(year, day)
        path -> File.read!(path)
      end

    case solution(info) do
      {:ok, {mod, fun}} ->
        answer = apply(mod, fun, [input])
        Logger.info("Answer: #{answer}")
        submit_answer(year, day, part, answer, opts)

      {:error, reason} ->
        Logger.error("Error solving: #{reason}")
    end
  end

  defp benchmark(opts) do
    %{year: year, day: day, part: part} = info = solution_info(opts)
    Logger.metadata(year: year, day: day, part: part)

    input =
      case Keyword.get(opts, :input) do
        nil -> fetch_input(year, day)
        path -> File.read!(path)
      end

    case solution(info) do
      {:ok, {mod, fun}} ->
        Benchee.run(%{
          "solution" => fn -> apply(mod, fun, [input]) end
        })

      # Logger.info("Answer: #{answer}")

      {:error, reason} ->
        Logger.error("Error solving: #{reason}")
    end
  end

  defp submit_answer(year, day, part, answer, opts) do
    if Keyword.get(opts, :submit, false) do
      case Advent.Answer.submit(year, day, part, answer) do
        :ok ->
          Logger.info("Answer submitted successfully")

        {:error, reason} ->
          Logger.error("Error submitting answer: #{reason}")
      end
    end
  end
end

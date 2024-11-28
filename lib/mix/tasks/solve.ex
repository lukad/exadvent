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
  """
  @shortdoc "Solve the Advent of Code problems"

  use Mix.Task

  require Logger

  @options [
    year: :integer,
    day: :integer,
    part: :integer,
    input: :string,
    submit: :boolean
  ]

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case OptionParser.parse!(args, strict: @options) do
      {opts, []} -> solve(opts)
      {_opts, _args} -> Mix.Tasks.Help.run(["solve"])
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

  defp solve(opts) do
    today = Date.utc_today()
    year = Keyword.get(opts, :year, today.year)
    day = Keyword.get(opts, :day, today.day)
    part = Keyword.get(opts, :part, 1)

    Logger.metadata(year: year, day: day, part: part)

    input =
      case Keyword.get(opts, :input) do
        nil -> fetch_input(year, day)
        path -> File.read!(path)
      end

    solution =
      case Advent.Solution.solution(year, day) do
        nil ->
          Logger.error("No solution found for year #{year} day #{day}")
          {:error, :no_solution}

        solution ->
          case part do
            1 ->
              {:ok, solution.part_one(input)}

            2 ->
              {:ok, solution.part_two(input)}

            _ ->
              Logger.error("Invalid part: #{part}")
              {:error, :invalid_part}
          end
      end

    case solution do
      {:ok, answer} ->
        Logger.info("Answer: #{answer}")
        submit_answer(year, day, part, answer, opts)

      {:error, reason} ->
        Logger.error("Error solving: #{reason}")
    end
  end

  defp submit_answer(year, day, part, answer, opts) do
    if Keyword.get(opts, :submit, false) do
      Advent.Answer.submit(year, day, part, answer)
    end
  end
end

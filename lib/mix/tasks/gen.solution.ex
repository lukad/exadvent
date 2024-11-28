defmodule Mix.Tasks.Gen.Solution do
  @moduledoc """
  Generates a solution file for a given year and day.

  ## Examples

      # Generates a solution file for the current year and day
      mix gen.solution

      # Generates a solution file for the year 2022 and day 2
      mix gen.solution --year 2022 --day 2

  ## Options

  * `--year` - the year of the solution (defaults to the current year)
  * `--day` - the day of the solution (defaults to the current day)
  * `--force` - overwrite the solution file if it already exists
  """
  @shortdoc "Generates a solution file for a given year and day."

  @options [
    year: :integer,
    day: :integer,
    force: :boolean
  ]

  use Mix.Task

  import Mix.Generator

  @impl Mix.Task
  def run(args) do
    case OptionParser.parse!(args, strict: @options) do
      {opts, []} -> generate(opts)
      {_opts, _args} -> Mix.Tasks.Help.run(["gen.solution"])
    end
  end

  defp generate(args) do
    today = Date.utc_today()
    year = Keyword.get(args, :year, today.year)
    day = Keyword.get(args, :day, today.day)

    padded_day = day |> to_string() |> String.pad_leading(2, "0")

    mod =
      Module.concat([
        Advent.Solutions,
        "Year#{year}",
        "Day#{padded_day}"
      ])

    assigns = [
      mod: mod,
      year: year,
      day: day
    ]

    path =
      Path.join([
        File.cwd!(),
        "lib",
        "advent",
        "solutions",
        "year_#{year}",
        "day_#{padded_day}.ex"
      ])

    force = Keyword.get(args, :force, false)
    create_file(path, solution_template(assigns), force: force)
  end

  embed_template(:solution, """
  defmodule <%= @mod %> do
    @moduledoc false

    use Advent.Solution,
      year: <%= @year %>,
      day: <%= @day %>,
      example_input: \"\"\"
      \"\"\",
      example_output: [0, 0]

    def part_one(_input) do
      raise "Not implemented"
    end

    def part_two(_input) do
      raise "Not implemented"
    end
  end
  """)
end

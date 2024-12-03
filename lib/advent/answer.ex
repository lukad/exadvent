defmodule Advent.Answer do
  require Logger

  @spec submit(integer(), integer(), integer(), String.t()) :: :ok | {:error, atom() | String.t()}
  def submit(year, day, part, answer) do
    Logger.info("Submitting answer")

    url = "https://adventofcode.com/#{year}/day/#{day}/answer"

    response =
      Req.post!(
        url: url,
        headers: [{"Cookie", "session=#{aoc_session()}"}],
        form: [
          level: part,
          answer: answer
        ]
      )

    case response do
      %Req.Response{status: 200} ->
        :ok

      %Req.Response{status: 400} ->
        {:error, :invalid_answer}

      %Req.Response{status: 429} ->
        {:error, :rate_limited}

      _ ->
        {:error, inspect(response)}
    end
  end

  defp aoc_session do
    Application.fetch_env!(:advent, :aoc_session)
  end
end

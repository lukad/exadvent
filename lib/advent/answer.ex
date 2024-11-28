defmodule Advent.Answer do
  require Logger

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
        {:ok, "Answer submitted successfully"}

      %Req.Response{status: 400} ->
        {:error, :invalid_answer}

      %Req.Response{status: 429} ->
        {:error, :rate_limited}

      _ ->
        Logger.error("Error submitting answer: #{inspect(response)}")
        {:error, :unexpected_response}
    end
  end

  defp aoc_session do
    Application.fetch_env!(:advent, :aoc_session)
  end
end

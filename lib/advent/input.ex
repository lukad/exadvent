defmodule Advent.Input do
  def path(year, day) do
    Path.join([:code.priv_dir(:advent), "inputs", "#{year}", "#{day}.txt"])
  end

  def fetch(year, day) do
    input_path = path(year, day)

    if File.exists?(input_path) do
      File.read!(input_path)
    else
      url = "https://adventofcode.com/#{year}/day/#{day}/input"
      headers = [{"Cookie", "session=#{aoc_session()}"}]

      case Req.get!(url: url, headers: headers) do
        %Req.Response{status: 200, body: body} ->
          save(body, input_path)
          body

        response ->
          raise "Error fetching input: #{inspect(response)}"
      end
    end
  end

  defp save(input, input_path) do
    input_path |> Path.dirname() |> File.mkdir_p!()
    File.write!(input_path, input)
  end

  defp aoc_session do
    Application.fetch_env!(:advent, :aoc_session)
  end
end

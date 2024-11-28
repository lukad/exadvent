defmodule Advent.Util do
  @doc """
  Splits a string into lines and trims newlines.
  """
  def lines(input) do
    String.split(input, "\n", trim: true)
  end
end

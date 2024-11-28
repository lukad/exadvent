import Config

if Mix.env() != :test do
  aoc_session = System.get_env("AOC_SESSION")

  if aoc_session != nil do
    config :advent, aoc_session: aoc_session
  end
end

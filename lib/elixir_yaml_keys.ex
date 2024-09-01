defmodule ElixirYamlKeys do
  alias ElixirYamlKeys.Keys
  alias ElixirYamlKeys.ListFiles
  alias ElixirYamlKeys.Worker

  def main(_argv) do
    Keys.start_link()
    ListFiles.start()

    extract()
    IO.inspect(Keys.get_all())
    0
  end

  defp extract() do
    results = 1..4
    |> Enum.map(fn _ -> Worker.run() end)
    |> Task.await_many()

    if !Enum.any?(results, fn x -> x == :done end), do: extract()
  end
end

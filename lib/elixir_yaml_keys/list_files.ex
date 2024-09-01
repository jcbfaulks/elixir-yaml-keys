defmodule ElixirYamlKeys.ListFiles do

  def start(path \\ File.cwd!()) do
    {:ok, files} = File.ls(path)
    Agent.start_link(fn -> files end, name: __MODULE__)
  end

  def reset(path \\ File.cwd!()) do
    {:ok, files} = File.ls(path)
    Agent.update(__MODULE__, fn _ -> files end)
  end

  def next() do
    Agent.get_and_update(__MODULE__, fn state ->
      case _next(state) do
        {val, next_state} -> {val, next_state}
        nil -> {:done, []}
      end
    end)
  end

  defp _next([]) do
    nil
  end

  defp _next([head|tail]) do
    cond do
      File.dir?(head) ->
        new_files = File.ls!(head) |> Enum.map(fn x -> head <> "/" <> x end)
        _next(new_files ++ tail)
      String.ends_with?(head, ".yaml") || String.ends_with?(head, ".yml") -> {head, tail}
      true -> _next(tail)
    end
  end

end

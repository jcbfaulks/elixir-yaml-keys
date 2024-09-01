defmodule ListFiles do

  def start(path \\ File.cwd!()) do
    {:ok, files} = File.ls(path)
    Agent.start_link(fn -> files end, name: __MODULE__)
  end

  def reset(path \\ File.cwd!()) do
    {:ok, files} = File.ls(path)
    Agent.update(__MODULE__, fn _ -> files end)
  end

  def next() do
    state = Agent.get(__MODULE__, &(&1))
    case _next(state) do
     {val, next_state} ->
      Agent.update(__MODULE__, fn _ -> next_state end)
      val
     nil -> :done
    end
  end

  defp _next([]) do
    nil
  end

  defp _next([head|tail]) do
    cond do
      File.dir?(head) ->
        new_files = File.ls!(head) |> Enum.map(fn x -> head <> "/" <> x end)
        _next(new_files ++ tail)
      true -> {head, tail}
    end
  end

end

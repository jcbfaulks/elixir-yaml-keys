defmodule Keys do

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_key(key) do
    Agent.update(__MODULE__, fn map ->
      Map.update(map, key, 1, &(&1 + 1))
    end)
  end

  def get_count(key) do
    Agent.get(__MODULE__, fn map -> Map.get(map, key) end)
  end

  def get_all() do
    Agent.get(__MODULE__, &(&1))
  end

end

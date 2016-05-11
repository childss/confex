defmodule ExConf.Sources.Multi do
  @moduledoc """
  Defines a source that combines multiple sources.

  ## ConfigSourceable Protocol

  The `ExConf.ConfigSourceable` protocol implementation for multi sources
  performs a sequential lookup through each defined source (in order) until a
  non-nil value is found. If no source provides a non-nil value, nil is
  returned.

      iex> source1 = ExConf.Sources.Map.new(key1: "key1 value", key2: "not used")
      iex> source2 = ExConf.Sources.Environment.new
      iex> System.put_env("key2", "key2 value")
      iex> multi = ExConf.Sources.Multi.new([source2, source1])
      iex> ExConf.ConfigSourceable.get(multi, "key1")
      "key1 value"
      iex> ExConf.ConfigSourceable.get(multi, "key2")
      "key2 value"
      iex> ExConf.ConfigSourceable.get(multi, "key3")
      nil

  Multi sources may also be nested:

      iex> source1 = ExConf.Sources.Map.new(key1: "key1 value")
      iex> inner_multi = ExConf.Sources.Multi.new([source1])
      iex> wrapper_multi = ExConf.Sources.Multi.new([inner_multi])
      iex> ExConf.ConfigSourceable.get(wrapper_multi, "key1")
      "key1 value"
  """

  defstruct sources: []

  @type t :: %__MODULE__{}

  @doc """
  Creates a new `ExConf.Sources.Multi` struct from the given list of sources.
  """
  def new(sources \\ []) do
    %__MODULE__{sources: sources}
  end

  defimpl ExConf.ConfigSourceable do
    def get(%{sources: sources}, key) do
      Enum.find_value sources, &ExConf.ConfigSourceable.get(&1, key)
    end
  end
end

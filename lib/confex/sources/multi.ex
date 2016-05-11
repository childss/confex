defmodule Confex.Sources.Multi do
  @moduledoc """
  Defines a source that combines multiple sources.

  ## ConfigSourceable Protocol

  The `Confex.ConfigSourceable` protocol implementation for multi sources
  performs a sequential lookup through each defined source (in order) until a
  non-nil value is found. If no source provides a non-nil value, nil is
  returned.

      iex> source1 = Confex.Sources.Map.new(key1: "key1 value", key2: "not used")
      iex> source2 = Confex.Sources.Environment.new
      iex> System.put_env("key2", "key2 value")
      iex> multi = Confex.Sources.Multi.new([source2, source1])
      iex> Confex.ConfigSourceable.get(multi, "key1")
      "key1 value"
      iex> Confex.ConfigSourceable.get(multi, "key2")
      "key2 value"
      iex> Confex.ConfigSourceable.get(multi, "key3")
      nil

  Multi sources may also be nested:

      iex> source1 = Confex.Sources.Map.new(key1: "key1 value")
      iex> inner_multi = Confex.Sources.Multi.new([source1])
      iex> wrapper_multi = Confex.Sources.Multi.new([inner_multi])
      iex> Confex.ConfigSourceable.get(wrapper_multi, "key1")
      "key1 value"
  """

  defstruct sources: []

  @type t :: %__MODULE__{}
  @type sourceable :: Confex.ConfigSourceable.t

  @doc """
  Creates a new `Confex.Sources.Multi` struct from the given list of sources.
  """
  @spec new([sourceable]) :: t
  def new(sources \\ []) do
    %__MODULE__{sources: sources}
  end

  defimpl Confex.ConfigSourceable do
    def get(%{sources: sources}, key) do
      Enum.find_value sources, &Confex.ConfigSourceable.get(&1, key)
    end
  end
end

defmodule Confex.Sources.Map do
  @moduledoc """
  Defines a source backed by a static map.

  The Map source is useful for tests or other situations where a static,
  in-memory config source is desirable.

  The data source can be initialized with a map:

      iex> Confex.Sources.Map.new(%{"key" => "value"})
      %Confex.Sources.Map{data: %{"key" => "value"}}

  Keyword list syntax may also be used. Atom keys will be converted to strings.

      iex> Confex.Sources.Map.new(key: "value")
      %Confex.Sources.Map{data: %{"key" => "value"}}

  ## ConfigSourceable Protocol

  The `Confex.ConfigSourceable` protocol implementation for map sources does a
  direct key lookup via `Map.get`. Undefined keys return nil.

      iex> source = Confex.Sources.Map.new(key: "value")
      iex> Confex.ConfigSourceable.get(source, "key")
      "value"
      iex> Confex.ConfigSourceable.get(source, "other")
      nil
  """

  defstruct data: %{}

  @type t :: %__MODULE__{}

  @doc """
  Creates a new `Confex.Sources.Map` struct with the given data.

  The given enumerable will be inserted into a new map, coercing keys to
  strings.
  """
  @spec new(Enumerable.t) :: t
  def new(enumerable \\ %{}) do
    data = Enum.into(enumerable, %{}, fn {k, v} -> {to_string(k), v} end)
    %__MODULE__{data: data}
  end

  defimpl Confex.ConfigSourceable do
    def get(%{data: data}, key) do
      Map.get(data, key)
    end
  end
end

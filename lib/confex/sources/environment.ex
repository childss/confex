defmodule Confex.Sources.Environment do
  @moduledoc """
  Defines a source that acts as a proxy for `System.get_env/1`.

  ## ConfigSourceable Protocol

  The `Confex.ConfigSourceable` protocol implementation for environment sources
  looks up values using `System.get_env/1`, meaning values come from system
  environment variables and the value may be changed at runtime via
  `System.put_env/2`.

      iex> source = Confex.Sources.Environment.new
      iex> Confex.ConfigSourceable.get(source, "test")
      nil
      iex> System.put_env("test", "value")
      iex> Confex.ConfigSourceable.get(source, "test")
      "value"
      iex> System.put_env("test", "new value")
      iex> Confex.ConfigSourceable.get(source, "test")
      "new value"
  """

  defstruct data: nil

  @type t :: %__MODULE__{}

  @doc """
  Creates a new `Confex.Sources.Environment` struct.
  """
  @spec new :: t
  def new do
    %__MODULE__{}
  end

  defimpl Confex.ConfigSourceable do
    def get(_source, key) do
      System.get_env(key)
    end
  end
end

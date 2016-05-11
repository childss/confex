defmodule ExConf.Transforms.Key do
  @moduledoc """
  Defines a transform for modifying keys for lookups.

  A `ExConf.Transforms.Key` can be created from either an anonymous/partial
  function or a `{module, function}` tuple.

  ## ExConf.ConfigSourceable Protocol

  The `ExConf.ConfigSourceable` implementation for this type calls the
  provided function to transform the key, using the return value to call the
  protocol implementation for the underlying source.

      iex> source = ExConf.Sources.Map.new(%{"KEY" => "value"})
      iex> transform = ExConf.Transforms.Key.new(&String.upcase/1, source)
      iex> ExConf.ConfigSourceable.get(transform, "key")
      "value"
  """

  defstruct function: nil, source: nil

  @type t :: %__MODULE__{}
  @type sourceable :: ExConfig.ConfigSourceable.t

  @doc """
  Creates a new `ExConf.Transforms.Key` struct.
  """
  @spec new((String.t -> String.t) | {module, atom}, sourceable) :: t
  def new(fun, source) do
    %__MODULE__{function: fun, source: source}
  end

  defimpl ExConf.ConfigSourceable do
    def get(%{function: fun, source: source}, key) when is_function(fun, 1) do
      ExConf.ConfigSourceable.get(source, fun.(key))
    end
    def get(%{function: {mod, fun}, source: source}, key)
      when is_atom(mod) and is_atom(fun) do
        ExConf.ConfigSourceable.get(source, :erlang.apply(mod, fun, [key]))
    end
  end
end

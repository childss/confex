defmodule Confex.Transforms.Key do
  @moduledoc """
  Defines a transform for modifying keys for lookups.

  A `Confex.Transforms.Key` can be created from either an anonymous/partial
  function or a `{module, function}` tuple.

  ## Confex.ConfigSourceable Protocol

  The `Confex.ConfigSourceable` implementation for this type calls the
  provided function to transform the key, using the return value to call the
  protocol implementation for the underlying source.

      iex> source = Confex.Sources.Map.new(%{"KEY" => "value"})
      iex> transform = Confex.Transforms.Key.new(&String.upcase/1, source)
      iex> Confex.ConfigSourceable.get(transform, "key")
      "value"
  """

  defstruct function: nil, source: nil

  @type t :: %__MODULE__{}
  @type sourceable :: Confexig.ConfigSourceable.t

  @doc """
  Creates a new `Confex.Transforms.Key` struct.
  """
  @spec new((String.t -> String.t) | {module, atom}, sourceable) :: t
  def new(fun, source) do
    %__MODULE__{function: fun, source: source}
  end

  defimpl Confex.ConfigSourceable do
    def get(%{function: fun, source: source}, key) when is_function(fun, 1) do
      Confex.ConfigSourceable.get(source, fun.(key))
    end
    def get(%{function: {mod, fun}, source: source}, key)
      when is_atom(mod) and is_atom(fun) do
        Confex.ConfigSourceable.get(source, :erlang.apply(mod, fun, [key]))
    end
  end
end

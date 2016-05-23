defmodule Confex.Transforms.Key do
  @moduledoc """
  A behaviour module for defining a key transformer for a pipeline.

  Key transformers are used by a pipeline to alter the requested key before
  passing it on to its underlying source.

  Using this module automatically adopts the behaviour, defines a struct, and
  derives an implementation of the `Confex.KeyTransformable` protocol. Any
  options supplied to the `use` macro will be passed to the `defstruct` macro,
  so they should be a list of keywords.

  ## Examples

  One use case for key transformers is to able to specify configuration keys in
  a consistent format but retrieve them from sources that may have a different
  scheme for naming keys. For example, say we want to lookup configuration
  values from the environment using keys like `"example.key"` but the
  deployment environment provides the values in variables named like
  `EXAMPLE__KEY`. We can use a key transformer in a pipeline to achieve this:

      defmodule EnvironmentKeyTransformer do
        use Confex.Transforms.Key

        def new(), do: %__MODULE__{}

        def transform_key(_, key) do
          key
          |> String.split(".")
          |> Enum.map(&String.upcase/1)
          |> Enum.join("__")
        end
      end

      env = Confex.Sources.Environment.new
      pipeline = Confex.Pipeline.new(env, key_transforms: [EnvironmentKeyTransformer.new])

      System.put_env("EXAMPLE__KEY", "value")
      puts Confex.ConfigSourceable.get(pipeline, "example.key")
      # will print "value"

  As the `__using__` macro definition for key transformers defines a struct
  with the given fields, we can also provide data to be used when transforming
  keys. For example, a transformer that prefixes all requested keys with a
  value:

      defmodule PrefixKeyTransformer do
        use Confex.Transforms.Key, prefix: ""

        def new(prefix), do: %__MODULE__{prefix: prefix}

        def transform_key(%{prefix: prefix}, key) do
          "\#{prefix}_key"
        end
      end

      source = Confex.Sources.Environment.map(%{transformed_key: "value"})
      key = PrefixKeyTransformer.new("transformed")
      pipeline = Confex.Pipeline.new(env, key_transforms: [key])

      puts Confex.ConfigSourceable.get(pipeline, "key")
      # will print "value"
  """

  defmacro __using__(opts) do
    quote do
      @behaviour Confex.Transforms.Key
      @derive Confex.KeyTransformable

      defstruct unquote(opts)
    end
  end

  @type transformer :: module

  @callback transform_key(transformer, String.t) :: String.t
end

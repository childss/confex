defmodule Confex.Transforms.Value do
  defmacro __using__(opts) do
    quote do
      @behaviour Confex.Transforms.Value
      @derive Confex.ValueTransformable

      defstruct unquote(opts)
    end
  end

  @type transformer :: module

  @callback transform_value(transformer, String.t, any) :: any
end

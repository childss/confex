defmodule Confex.Transforms.ValueTest do
  use ExUnit.Case, async: true

  doctest Confex.Transforms.Value

  test "can define a value transformer" do
    defmodule ExampleValueTransformer do
      use Confex.Transforms.Value, multiplier: 0

      def new(multiplier), do: %__MODULE__{multiplier: multiplier}

      def transform_value(%{multiplier: multiplier}, _key, value) do
        value * multiplier
      end
    end

    transformer = ExampleValueTransformer.new(7)
    assert Confex.ValueTransformable.transform_value(transformer, nil, 6) == 42
  end
end

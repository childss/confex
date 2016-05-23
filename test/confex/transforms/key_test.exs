defmodule Confex.Transforms.KeyTest do
  use ExUnit.Case, async: true

  doctest Confex.Transforms.Key

  test "can define a key transformer" do
    defmodule ExampleKeyTransformer do
      use Confex.Transforms.Key, prefix: nil

      def new(prefix), do: %__MODULE__{prefix: prefix}

      def transform_key(%{prefix: prefix}, key) do
        "#{prefix}_#{key}"
      end
    end

    transformer = ExampleKeyTransformer.new("transformed")
    result = Confex.KeyTransformable.transform_key(transformer, "key")
    assert result == "transformed_key"
  end

  test "can define a key transformer without struct fields" do
    defmodule EmptyKeyTransformer do
      use Confex.Transforms.Key

      def new(), do: %__MODULE__{}

      def transform_key(%{}, key) do
        "empty_#{key}"
      end
    end

    transformer = EmptyKeyTransformer.new()
    result = Confex.KeyTransformable.transform_key(transformer, "key")
    assert result == "empty_key"
  end
end

defmodule Confex.Transforms.KeyTest do
  use ExUnit.Case, async: true

  doctest Confex.Transforms.Key

  test "can reference a module and function" do
    defmodule ExampleKeyTransform do
      def transform_key(key) do
        "#{key}_changed"
      end
    end

    source = Confex.Sources.Map.new(%{"key_changed" => "value"})
    transform = Confex.Transforms.Key.new({ExampleKeyTransform, :transform_key}, source)
    assert Confex.ConfigSourceable.get(transform, "key") == "value"
  end
end

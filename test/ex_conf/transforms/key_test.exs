defmodule ExConf.Transforms.KeyTest do
  use ExUnit.Case, async: true

  doctest ExConf.Transforms.Key

  test "can reference a module and function" do
    defmodule ExampleKeyTransform do
      def transform_key(key) do
        "#{key}_changed"
      end
    end

    source = ExConf.Sources.Map.new(%{"key_changed" => "value"})
    transform = ExConf.Transforms.Key.new({ExampleKeyTransform, :transform_key}, source)
    assert ExConf.ConfigSourceable.get(transform, "key") == "value"
  end
end

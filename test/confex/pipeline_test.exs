defmodule Confex.PipelineTest do
  use ExUnit.Case, async: true
  alias Confex.Pipeline
  alias Confex.Sources.Map, as: MapSource
  alias Confex.Transforms.DefaultValueTransform

  defmodule ExampleKeyTransformer do
    use Confex.Transforms.Key, prefix: nil

    def new(prefix), do: %__MODULE__{prefix: prefix}

    def transform_key(%{prefix: prefix}, key) do
      "#{prefix}_#{key}"
    end
  end

  test "pipeline is sourceable and applies key transforms" do
    source = MapSource.new(transformed_key: "value")
    transformer = ExampleKeyTransformer.new("transformed")
    pipeline = Pipeline.new(source, key_transforms: [transformer])
    assert Confex.ConfigSourceable.get(pipeline, "key") == "value"
  end

  test "pipeline applies value transforms" do
    source = MapSource.new(other_key: "value")
    transformer = DefaultValueTransform.new(%{"key" => "default"})
    pipeline = Pipeline.new(source, value_transforms: [transformer])
    assert Confex.ConfigSourceable.get(pipeline, "key") == "default"
  end

  test "pipeline applies value transforms with original key" do
    source = MapSource.new(other_key: "value")
    key_transformer = ExampleKeyTransformer.new("transformed")
    value_transformer = DefaultValueTransform.new(%{"key" => "default"})
    pipeline = Pipeline.new(source, key_transforms: [key_transformer],
      value_transforms: [value_transformer])
    assert Confex.ConfigSourceable.get(pipeline, "key") == "default"
  end
end

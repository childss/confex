defmodule Confex.Pipeline do

  defstruct source: nil, key_transforms: [], value_transforms: []

  def new(source, opts \\ []) do
    %__MODULE__{source: source,
      key_transforms: Keyword.get(opts, :key_transforms, []),
      value_transforms: Keyword.get(opts, :value_transforms, [])
    }
  end

  defimpl Confex.ConfigSourceable do
    def get(%{source: source, key_transforms: key_transforms, value_transforms: value_transforms}, key) do
      transformed_key = Enum.reduce key_transforms, key, &Confex.KeyTransformable.transform_key/2
      value = Confex.ConfigSourceable.get(source, transformed_key)
      Enum.reduce value_transforms, value, &Confex.ValueTransformable.transform_value(&1, key, &2)
    end
  end
end

defmodule Confex.Transforms.DefaultValueTransform do
  use Confex.Transforms.Value, defaults: %{}

  def new(enumerable) do
    defaults = Enum.into(enumerable, %{}, fn {k, v} -> {to_string(k), v} end)
    %__MODULE__{defaults: defaults}
  end

  @doc """
  De

  ## Examples

      iex> transform = Confex.Transforms.DefaultValueTransform.new(%{"key" => "default"})
      iex> Confex.Transforms.DefaultValueTransform.transform_value(transform, "key", "value")
      "value"
      iex> Confex.Transforms.DefaultValueTransform.transform_value(transform, "key", nil)
      "default"
      iex> Confex.Transforms.DefaultValueTransform.transform_value(transform, "other", nil)
      nil
  """
  def transform_value(%{defaults: defaults}, key, nil) do
    Map.get(defaults, key)
  end
  def transform_value(_, _, value), do: value
end

defprotocol Confex.ValueTransformable do
  def transform_value(value_transformer, key, value)
end

defimpl Confex.ValueTransformable, for: Any do
  require Logger

  def transform_value(value_transformer, key, value) do
    module = value_transformer.__struct__
    transformed = module.transform_value(value_transformer, key, value)
    Logger.debug("applied value transform #{module} on key #{key}: #{value} => #{transformed}")
    transformed
  end
end

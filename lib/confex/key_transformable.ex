defprotocol Confex.KeyTransformable do
  def transform_key(key_transformer, key)
end

defimpl Confex.KeyTransformable, for: Any do
  require Logger

  def transform_key(key_transformer, key) do
    module = key_transformer.__struct__
    transformed = module.transform_key(key_transformer, key)
    Logger.debug("applied key transform #{module}: #{key} => #{transformed}")
    transformed
  end
end

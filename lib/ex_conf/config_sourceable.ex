defprotocol ExConf.ConfigSourceable do
  @moduledoc """
  A protocol to lookup values from sources by key.

  This protocol provides a layer of indirection for accessing values from any
  source.

      iex> map = ExConf.Sources.Map.new(map_key: "map value")
      iex> env = ExConf.Sources.Environment.new
      iex> System.put_env("env_key", "env value")
      iex> ExConf.ConfigSourceable.get(map, "map_key")
      "map value"
      iex> ExConf.ConfigSourceable.get(env, "env_key")
      "env value"
  """

  @doc """
  Gets the value for the given key from the data source.
  """
  @spec get(ExConf.ConfigSourceable.t, String.t) :: String.t
  def get(source, key)
end

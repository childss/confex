defprotocol Confex.ConfigSourceable do
  @moduledoc """
  A protocol to lookup values from sources by key.

  This protocol provides a layer of indirection for accessing values from any
  source.

      iex> map = Confex.Sources.Map.new(map_key: "map value")
      iex> env = Confex.Sources.Environment.new
      iex> System.put_env("env_key", "env value")
      iex> Confex.ConfigSourceable.get(map, "map_key")
      "map value"
      iex> Confex.ConfigSourceable.get(env, "env_key")
      "env value"
  """

  @doc """
  Gets the value for the given key from the data source.
  """
  @spec get(Confex.ConfigSourceable.t, String.t) :: String.t
  def get(source, key)
end

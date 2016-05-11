defmodule ExConf do
  @moduledoc File.read!("README.md")

  alias ExConf.ConfigSourceable, as: Source

  @doc """
  Gets an optional string from the source.

  If the `key` does not exist in the source, returns `nil`.

  ## Examples

      iex> source = ExConf.Sources.Map.new(str: "value", int: 123)
      iex> ExConf.get_string(source, "str")
      "value"
      iex> ExConf.get_string(source, "int")
      "123"
      iex> ExConf.get_string(source, "not here")
      nil
  """
  def get_string(source, key) do
    case Source.get(source, key) do
      nil   -> nil
      value -> to_string(value)
    end
  end

  @doc """
  Fetches the value for a specific `key` as a string and returns it in a tuple.

  If the `key` does not exist in the source, returns `:error`.

  ## Examples

      iex> source = ExConf.Sources.Map.new(str: "value", int: 123)
      iex> ExConf.fetch_string(source, "str")
      {:ok, "value"}
      iex> ExConf.fetch_string(source, "int")
      {:ok, "123"}
      iex> ExConf.fetch_string(source, "not here")
      :error
  """
  def fetch_string(source, key) do
    case get_string(source, key) do
      nil -> :error
      str -> {:ok, str}
    end
  end

  @doc """
  Fetches the value for a specific `key` as a string.

  If the `key` does not exist in the source, a `RuntimeError` is raised.

  ## Examples

      iex> source = ExConf.Sources.Map.new(str: "value", int: 123)
      iex> ExConf.fetch_string!(source, "str")
      "value"
      iex> ExConf.fetch_string!(source, "int")
      "123"
      iex> ExConf.fetch_string!(source, "not here")
      ** (RuntimeError) key "not here" not found in configuration
  """
  def fetch_string!(source, key) do
    case get_string(source, key) do
      nil -> raise_not_found(key)
      str -> str
    end
  end

  @doc """
  Gets an optional integer from the source.

  If the `key` does not exist in the source or the value cannot be parsed as
  an integer, returns `nil`.

  ## Examples

      iex> source = ExConf.Sources.Map.new(str: "123", int: 456, not_int: "garbage")
      iex> ExConf.get_int(source, "str")
      123
      iex> ExConf.get_int(source, "int")
      456
      iex> ExConf.get_int(source, "not here")
      nil
      iex> ExConf.get_int(source, "not_int")
      nil
  """
  def get_int(source, key) do
    case fetch_int(source, key) do
      {:ok, int} -> int
      _ -> nil
    end
  end

  @doc """
  Fetches the value for a specific `key` as an integer and returns it in a tuple.

  If the `key` does not exist in the source, returns `:error`.

  If the `key` exists but could not be parsed as an integer, returns
  `{:error, :unparseable, value}`.

  ## Examples

      iex> source = ExConf.Sources.Map.new(str: "123", int: 456, not_int: "garbage")
      iex> ExConf.fetch_int(source, "str")
      {:ok, 123}
      iex> ExConf.fetch_int(source, "int")
      {:ok, 456}
      iex> ExConf.fetch_int(source, "not here")
      :error
      iex> ExConf.fetch_int(source, "not_int")
      {:error, :unparseable, "garbage"}
  """
  def fetch_int(source, key) do
    value = Source.get(source, key)
    cond do
      is_nil(value) -> :error
      is_integer(value) -> {:ok, value}
      is_binary(value) ->
        try do
          {int, ""} = Integer.parse(value)
          {:ok, int}
        rescue
          _ -> {:error, :unparseable, value}
        end
    end
  end

  @doc """
  Fetches the value for a specific `key` as an integer.

  If the `key` does not exist in the source or the value could not be parsed
  as an integer, a `RuntimeError` is raised.

  ## Examples

      iex> source = ExConf.Sources.Map.new(str: "123", int: 456, not_int: "garbage")
      iex> ExConf.fetch_int!(source, "str")
      123
      iex> ExConf.fetch_int!(source, "int")
      456
      iex> ExConf.fetch_int!(source, "not here")
      ** (RuntimeError) key "not here" not found in configuration

      iex> source = ExConf.Sources.Map.new(str: "123", int: 456, not_int: "garbage")
      iex> ExConf.fetch_int!(source, "not_int")
      ** (RuntimeError) key "not_int" with value \"garbage\" is not an integer
  """
  def fetch_int!(source, key) do
    case fetch_int(source, key) do
      {:ok, int} ->
        int
      :error ->
        raise_not_found(key)
      {:error, :unparseable, value} ->
        raise "key \"#{key}\" with value \"#{value}\" is not an integer"
    end
  end

  defp raise_not_found(key) do
    raise "key \"#{key}\" not found in configuration"
  end
end

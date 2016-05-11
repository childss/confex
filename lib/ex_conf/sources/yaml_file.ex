defmodule ExConf.Sources.YamlFile do
  @moduledoc """
  Defines a source that reads values from a YAML file.

  ## ConfigSourceable Protocol

  Creating a new `ExConf.Sources.YamlFile` parses the given file as a map and
  caches the data. Thus, the `ExConf.ConfigSourceable` implementation for YAML
  files behaves much like one for maps, and looks up values in the cached data
  via `Map.get/3`.

      ## test/fixtures/example.yaml
      # key1: value1
      # key2: value2

      iex> source = ExConf.Sources.YamlFile.new("test/fixtures/example.yaml")
      iex> ExConf.ConfigSourceable.get(source, "key1")
      "value1"
  """

  defstruct path: nil, data: %{}

  @type t :: %__MODULE__{}

  @doc """
  Creates a new `ExConf.Sources.YamlFile` struct from the given file.

  The file will be read immediately and parsed as YAML. If the file does not
  exist, a `{:yamerl_exception, reason}` will be thrown.
  """
  @spec new(String.t) :: t
  def new(path) do
    data = YamlElixir.read_from_file path
    %__MODULE__{path: path, data: data}
  end

  defimpl ExConf.ConfigSourceable do
    def get(%{data: data}, key) do
      Map.get(data, key)
    end
  end
end

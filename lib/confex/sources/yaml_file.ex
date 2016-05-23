defmodule Confex.Sources.YamlFile do
  @moduledoc """
  Defines a source that reads values from a YAML file.

  ## ConfigSourceable Protocol

  Creating a new `Confex.Sources.YamlFile` parses the given file as a map and
  caches the data. Thus, the `Confex.ConfigSourceable` implementation for YAML
  files behaves much like one for maps, and looks up values in the cached data
  via `Map.get/3`.

      ## test/fixtures/example.yaml
      # key1: value1
      # key2: value2

      iex> source = Confex.Sources.YamlFile.new("test/fixtures/example.yaml")
      iex> Confex.ConfigSourceable.get(source, "key1")
      "value1"
  """

  defstruct path: nil, data: %{}

  @type t :: %__MODULE__{}

  @doc """
  Creates a new `Confex.Sources.YamlFile` struct from the given file.

  The file will be read immediately and parsed as YAML. If the file does not
  exist and is required (`opts` contains a keyword `:required` with value
  `true`, the default), a `{:yamerl_exception, reason}` will be thrown. If the
  file does not exist and is optional (`opts` contains a keyword `:required`
  with value `false`), then the resulting struct will have an empty map in the
  `data` field.
  """
  @spec new(String.t, [required: boolean]) :: t
  def new(path, opts \\ [required: true]) do
    if Keyword.get(opts, :required, true) do
      data = YamlElixir.read_from_file path
      %__MODULE__{path: path, data: data}
    else
      if File.exists?(path) do
        data = YamlElixir.read_from_file path
        %__MODULE__{path: path, data: data}
      else
        %__MODULE__{path: path, data: %{}}
      end
    end
  end

  defimpl Confex.ConfigSourceable do
    def get(%{data: data}, key) do
      Map.get(data, key)
    end
  end
end

defmodule ExConf.Sources.Application do
  @moduledoc """
  Defines a source that acts as a proxy for `Application.get_env/3`.

  ## ConfigSourceable Protocol

  The `ExConf.ConfigSourceable` protocol implementation for application sources
  looks up values using `Application.get_env/3`, meaning they are set via
  Mix config.

      iex> source = ExConf.Sources.Application.new(:ex_conf)
      iex> ExConf.ConfigSourceable.get(source, "test_key")
      "test value" # from Mix config
  """

  defstruct app: nil

  @type t :: %__MODULE__{}

  @doc """
  Creates a new `ExConf.Sources.Application` struct from the given app name.
  """
  @spec new(atom) :: t
  def new(app) do
    %__MODULE__{app: app}
  end

  defimpl ExConf.ConfigSourceable do
    def get(%{app: app}, key) do
      Application.get_env(app, String.to_atom(key))
    end
  end
end

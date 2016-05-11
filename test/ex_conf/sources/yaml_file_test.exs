defmodule ExConf.Sources.YamlFileTest do
  use ExUnit.Case, async: true

  doctest ExConf.Sources.YamlFile

  test "when file doesn't exist" do
    result = catch_throw(ExConf.Sources.YamlFile.new("not a file path"))
    assert {:yamerl_exception, _} = result
  end

  test "when not a yaml file" do
    result = ExConf.Sources.YamlFile.new("test/fixtures/invalid.yaml")
    assert result.data == %{}
  end
end

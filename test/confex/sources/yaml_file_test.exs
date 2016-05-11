defmodule Confex.Sources.YamlFileTest do
  use ExUnit.Case, async: true

  doctest Confex.Sources.YamlFile

  test "when file doesn't exist" do
    result = catch_throw(Confex.Sources.YamlFile.new("not a file path"))
    assert {:yamerl_exception, _} = result
  end

  test "when not a yaml file" do
    result = Confex.Sources.YamlFile.new("test/fixtures/invalid.yaml")
    assert result.data == %{}
  end
end

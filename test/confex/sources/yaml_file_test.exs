defmodule Confex.Sources.YamlFileTest do
  use ExUnit.Case, async: true

  doctest Confex.Sources.YamlFile

  test "when file doesn't exist and required" do
    result = catch_throw(Confex.Sources.YamlFile.new("not a file path"))
    assert {:yamerl_exception, _} = result
    result = catch_throw(Confex.Sources.YamlFile.new("not a file path", required: true))
    assert {:yamerl_exception, _} = result
  end

  test "when file doesn't exist but not required" do
    result = Confex.Sources.YamlFile.new("not a file path", required: false)
    assert result.data == %{}
  end

  test "when not a yaml file" do
    result = Confex.Sources.YamlFile.new("test/fixtures/invalid.yaml")
    assert result.data == %{}
  end
end

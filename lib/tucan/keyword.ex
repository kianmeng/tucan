defmodule Tucan.Keyword do
  @moduledoc false

  # Helper keyword utility functions

  @doc false
  def put_new_conditionally(keywords, key, value, fun) do
    cond do
      Keyword.has_key?(keywords, key) ->
        keywords

      fun.() ->
        Keyword.put(keywords, key, value)

      true ->
        keywords
    end
  end

  @doc false
  def deep_merge(config1, config2) when is_list(config1) and is_list(config2) do
    Keyword.merge(config1, config2, fn _, value1, value2 ->
      Keyword.merge(value1, value2, &deep_merge/3)
    end)
  end

  defp deep_merge(_key, value1, value2) do
    if Keyword.keyword?(value1) and Keyword.keyword?(value2) do
      Keyword.merge(value1, value2, &deep_merge/3)
    else
      value2
    end
  end
end

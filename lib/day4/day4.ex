defmodule Day4 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    String.split(text, ["\n", "\r", "\r\n"])
  end

  def filter_not_contained({a, b}) do
    do_filter_not_contained(a, b, MapSet.size(a), MapSet.size(b))
  end

  def do_filter_not_contained(a, b, size_a, size_b) when size_b > size_a, do: MapSet.subset?(a, b)
  def do_filter_not_contained(a, b, _, _), do: MapSet.subset?(b, a)

  def part_one() do
    input = load_input("./lib/day4/input.txt")
    sum = input
    |> Enum.map(&String.split(&1, ["-", ","]))
    |> Enum.map(fn(x) -> x |> Enum.map(& String.to_integer(&1)) end)
    |> Enum.map(fn([a,b,c,d]) -> {MapSet.new(a..b), MapSet.new(c..d)} end)
    |> Enum.filter(&filter_not_contained/1)
    dbg length(sum)
  end

  def part_two() do
    input = load_input("./lib/day4/input.txt")
    sum = input
    |> Enum.map(&String.split(&1, ["-", ","]))
    |> Enum.map(fn(x) -> x |> Enum.map(& String.to_integer(&1)) end)
    |> Enum.map(fn([a,b,c,d]) -> {MapSet.new(a..b), MapSet.new(c..d)} end)
    |> Enum.filter(fn({a,b}) -> not MapSet.disjoint?(a,b) end)
    dbg length(sum)
  end
end

defmodule Day3 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    String.split(text, ["\n", "\r", "\r\n"])
  end

  # Lowercase item types a through z have priorities 1 through 26.
  # Uppercase item types A through Z have priorities 27 through 52.
  # a-z = 97 through 122
  # A-Z = 65 through 90
  def get_prio(x) do
    cond do
      (x >= 97) && (x <= 122) -> x - 96 # 1-26
      (x >= 65) && (x <= 90) -> x - 38 # 27-52
    end
  end

  def part_one() do
    input = load_input("./lib/day3/input.txt")
    sum = input
    |> Enum.map(& String.split_at(&1, div(String.length(&1), 2)))
    |> Enum.map(fn({a,b}) -> {MapSet.new(String.graphemes(a)), MapSet.new(String.graphemes(b))} end)
    |> Enum.map(fn({a,b}) -> hd MapSet.to_list(MapSet.intersection(a, b)) end)
    |> Enum.map(fn(x) -> hd(String.to_charlist(x)) end)
    |> Enum.map(& get_prio(&1))
    |> Enum.sum()
    IO.inspect sum
  end

  def part_two() do
    input = load_input("./lib/day3/input.txt")
    chunks = Enum.chunk_every(input, 3)
    sum = chunks
    |> Enum.map(fn(x) -> x |> Enum.map(& MapSet.new(String.graphemes(&1))) end)
    |> Enum.map(fn([a,b,c]) -> List.foldl([b,c], a, fn(e, acc) -> MapSet.intersection(acc, e) end) end)
    |> Enum.map(& MapSet.to_list(&1))
    |> Enum.map(& hd(&1))
    |> Enum.map(fn(x) -> hd(String.to_charlist(x)) end)
    |> Enum.map(& get_prio(&1))
    |> Enum.sum()
    IO.inspect sum
  end
end

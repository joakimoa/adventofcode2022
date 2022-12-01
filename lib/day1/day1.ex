defmodule Day1 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    String.split(text, ["\n", "\r", "\r\n"])
  end

  def part_one() do
    input = load_input("./lib/day1/input.txt")
    # IO.inspect input
    chunks = Enum.map(input, fn(x) -> if x == "", do: 0, else: String.to_integer(x) end)
    |> Enum.chunk_by(fn(x) -> x != 0 end)
    |> Enum.reject(fn(x) -> x == [0] end)

    # vals = Enum.map(chunks, fn(x) -> Enum.sum(x) end)
    vals_sorted = chunks
    |> Enum.map(& Enum.sum(&1))
    |> Enum.sort()
    |> Enum.reverse()
    # IO.inspect vals_sorted

    IO.inspect hd vals_sorted
  end

  def part_two() do
    input = load_input("./lib/day1/input.txt")
    # IO.inspect input
    chunks = Enum.map(input, fn(x) -> if x == "", do: 0, else: String.to_integer(x) end)
    |> Enum.chunk_by(fn(x) -> x != 0 end)
    |> Enum.reject(fn(x) -> x == [0] end)

    # vals = Enum.map(chunks, fn(x) -> Enum.sum(x) end)
    vals_sorted = chunks
    |> Enum.map(& Enum.sum(&1))
    |> Enum.sort()
    |> Enum.reverse()
    # IO.inspect vals_sorted

    top = Enum.take(vals_sorted, 3)
    top_sum = Enum.sum(top)

    IO.inspect top_sum
  end
end

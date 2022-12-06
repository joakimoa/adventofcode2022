defmodule Day6 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    text
  end

  def is_marker2(x, acc) do
    cond do
      length(Enum.uniq(x)) == 14 -> {:halt, acc}
      true -> {:cont, acc++[x]}
    end
  end

  def is_marker(x, acc) do
    cond do
      length(Enum.uniq(x)) == 4 -> {:halt, acc}
      true -> {:cont, acc++[x]}
    end
  end

  def part_two() do
    input = load_input("./lib/day6/input.txt")
    # dbg input
    buf = input
    |> String.graphemes()
    |> Enum.chunk_every(14, 1)

    packet = Enum.reduce_while(buf, [], &is_marker2/2)
    # dbg packet

    packet_length = length(packet) + 14
    dbg packet_length
  end

  def part_one() do
    input = load_input("./lib/day6/input.txt")
    # dbg input
    buf = input
    |> String.graphemes()
    |> Enum.chunk_every(4, 1)

    packet = Enum.reduce_while(buf, [], &is_marker/2)
    # dbg packet

    packet_length = length(packet) + 4
    dbg packet_length
  end
end

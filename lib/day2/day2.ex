defmodule Day2 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    String.split(text, ["\n", "\r", "\r\n"])
  end

  def set_moves([e, p]) do
    cond do
      (e == "A") && (p == "X") -> [e, "Z"]
      (e == "A") && (p == "Y") -> [e, "X"]
      (e == "A") && (p == "Z") -> [e, "Y"]
      (e == "B") && (p == "X") -> [e, "X"]
      (e == "B") && (p == "Y") -> [e, "Y"]
      (e == "B") && (p == "Z") -> [e, "Z"]
      (e == "C") && (p == "X") -> [e, "Y"]
      (e == "C") && (p == "Y") -> [e, "Z"]
      (e == "C") && (p == "Z") -> [e, "X"]
    end
  end

  def part_two() do
    input = load_input("./lib/day2/input.txt")
    input = input
    |> Enum.map(& String.split(&1, " "))
    # |> Enum.map(fn [a,b] -> [{a,b}] end)
    # IO.inspect input

    points = input
    |> Enum.map(&set_moves(&1))
    |> Enum.map(&get_points(&1))
    # IO.inspect points
    sum = Enum.sum(points)
    IO.inspect sum
  end

  def get_points([e, p]) do
    shape = cond do
      p == "X" -> 1
      p == "Y" -> 2
      p == "Z" -> 3
    end
    # shape
    move = cond do
      (e == "A") && (p == "X") -> 3
      (e == "A") && (p == "Y") -> 6
      (e == "A") && (p == "Z") -> 0
      (e == "B") && (p == "X") -> 0
      (e == "B") && (p == "Y") -> 3
      (e == "B") && (p == "Z") -> 6
      (e == "C") && (p == "X") -> 6
      (e == "C") && (p == "Y") -> 0
      (e == "C") && (p == "Z") -> 3
      # true ->
      #     IO.inspect "oh no"
      #     [-1000000]
    end
    shape + move
  end

  # A / X = rock
  # B / Y = paper
  # C / Z = scissors
  #
  # A -> Y
  # B -> Z
  # C -> X
  #
  # win  = 6
  # tie  = 3
  # loss = 0
  #
  # X = 1
  # Y = 2
  # Z = 3
  def part_one() do
    input = load_input("./lib/day2/input.txt")
    input = input
    |> Enum.map(& String.split(&1, " "))
    # |> Enum.map(fn [a,b] -> [{a,b}] end)
    # IO.inspect input

    points = input
    |> Enum.map(&get_points(&1))
    # IO.inspect points
    sum = Enum.sum(points)
    IO.inspect sum
  end
end

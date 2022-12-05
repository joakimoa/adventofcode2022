defmodule Day5 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    text
  end

  def get_letters(index, stacks) do
    List.foldl(stacks, [], fn(elem, acc) -> get_letter((index*4)-3, elem, acc) end)
  end

  def get_letter(index, string, acc) do
    s = String.at(string, index)
    case s do
      " " -> acc
      nil -> acc
      _ -> acc ++ [s]
    end
  end

  def make_moves2(stacks, [m, f, t]) do
    {{:ok, stack_from}, {:ok, stack_to}} = {Enum.fetch(stacks, f-1), Enum.fetch(stacks, t-1)}
    popped = Enum.slice(stack_from, -m..-1)
    new_from = Enum.drop(stack_from, -1*m)
    new_to = stack_to ++ popped
    stacks = List.replace_at(stacks, f-1, new_from)
    stacks = List.replace_at(stacks, t-1, new_to)
    # IO.puts("move #{m} from #{f} to #{t}")
    # dbg stacks
    stacks
  end

  def make_moves(stacks, [m, f, t]) do
    stacks = List.foldr(Enum.to_list(1..m), stacks, fn(_, acc) -> make_move(acc, f, t) end)
    # IO.puts("move #{m} from #{f} to #{t}")
    # dbg stacks
    stacks
  end

  def make_move(stacks, f, t) do
    {{:ok, stack_from}, {:ok, stack_to}} = {Enum.fetch(stacks, f-1), Enum.fetch(stacks, t-1)}
    {e, new_from} = List.pop_at(stack_from, -1)
    new_to = stack_to ++ [e]
    stacks = List.replace_at(stacks, f-1, new_from)
    stacks = List.replace_at(stacks, t-1, new_to)
    stacks
  end

  def get_tops(stacks) do
    Enum.map(stacks, fn x -> {e, _} = List.pop_at(x, -1); e end)
  end

  def part_two() do
    input = load_input("./lib/day5/input.txt")
    [crates, moves] = String.split(input, "\n\n")
    crates = String.split(crates, ["\n", "\r", "\r\n"])
    moves = String.split(moves, ["\n", "\r", "\r\n"])
    moves = Enum.map(moves, &String.split(&1, ["move", "from", "to", " "], trim: true))
    moves = Enum.map(moves, fn x -> Enum.map(x, fn y -> {i, ""} = Integer.parse(y); i end) end)
    dbg moves

    {raw_rows, crates} = List.pop_at(crates, length(crates)-1)
    {rows, ""} = Integer.parse(String.at(raw_rows,String.length(raw_rows)-1))
    crates = Enum.reverse(crates)
    crate_state = Enum.map(1..rows, & get_letters(&1, crates))
    dbg crate_state

    finished_state = List.foldl(moves, crate_state, fn([m,t,f], acc) -> make_moves2(acc, [m,t,f]) end)
    dbg finished_state

    tops = get_tops(finished_state)
    dbg Enum.join(tops)
  end

  def part_one() do
    input = load_input("./lib/day5/input.txt")
    [crates, moves] = String.split(input, "\n\n")
    crates = String.split(crates, ["\n", "\r", "\r\n"])
    moves = String.split(moves, ["\n", "\r", "\r\n"])
    moves = Enum.map(moves, &String.split(&1, ["move", "from", "to", " "], trim: true))
    moves = Enum.map(moves, fn x -> Enum.map(x, fn y -> {i, ""} = Integer.parse(y); i end) end)
    dbg moves

    {raw_rows, crates} = List.pop_at(crates, length(crates)-1)
    {rows, ""} = Integer.parse(String.at(raw_rows,String.length(raw_rows)-1))
    crates = Enum.reverse(crates)
    crate_state = Enum.map(1..rows, & get_letters(&1, crates))
    dbg crate_state

    finished_state = List.foldl(moves, crate_state, fn([m,t,f], acc) -> make_moves(acc, [m,t,f]) end)
    dbg finished_state

    tops = get_tops(finished_state)
    dbg Enum.join(tops)
  end
end

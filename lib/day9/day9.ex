defmodule Day9 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    String.split(text, ["\n", "\r", "\r\n"])
  end

  # plan
  # expand all moves, e.g. 'R 2' to [R, R]
  # and concatenate them [R, R, U, D, D, D]
  # then do List.foldl on the moves, move head, move tail
  # save the tails new position in a MapSet in the accumulator

  def do_move_head(move, {hx, hy}) do
      case move do
        "U" -> {hx, hy+1}
        "D" -> {hx, hy-1}
        "L" -> {hx-1, hy}
        "R" -> {hx+1, hy}
      end
  end

  def do_move_tail({hx, hy}, {tx, ty}, tvisited) do
    # dbg tvisited
    {dx, dy} = {hx-tx, hy-ty}
    res = cond do
      # if same row or col
      (dy == 0) && ((dx > 1) or (dx < -1)) -> {{hx, hy}, {tx+div(dx,2), ty}, MapSet.put(tvisited, {tx+div(dx,2), ty})} # if same row
      (dx == 0) && ((dy > 1) or (dy < -1)) -> {{hx, hy}, {tx, ty+div(dy,2)}, MapSet.put(tvisited, {tx, ty+div(dy,2)})} # if same col
      # if diag, multiple rules
      ((dx != 0) && (dy != 0)) && ((dy > 1) or (dy < -1)) -> {{hx, hy}, {tx+dx, ty+div(dy,2)}, MapSet.put(tvisited, {tx+dx, ty+div(dy,2)})}
      ((dx != 0) && (dy != 0)) && ((dx > 1) or (dx < -1)) -> {{hx, hy}, {tx+div(dx,2), ty+dy}, MapSet.put(tvisited, {tx+div(dx,2), ty+dy})}
      # h and t in same pos, or touching in any direction
      true -> {{hx, hy}, {tx, ty}, tvisited}
    end
    # dbg res
  end

  def part_one() do
    input = load_input("./lib/day9/input.txt")
    dbg input
    moves = input
    |> Enum.map(fn x -> [move, times] = String.split(x); [move] |> List.duplicate(String.to_integer(times)) |> List.flatten end)
    |> List.flatten
    dbg moves

    # {hx, hy}, {tx, ty}, tvisited
    {_, _, tvisited} = moves
    |> List.foldl({{0, 0}, {0, 0}, MapSet.new()}, fn move, {{hx, hy}, {tx, ty}, tvis} -> do_move_tail(do_move_head(move, {hx, hy}), {tx, ty}, tvis) end)
    # dbg moves
    # dbg tvisited
    dbg MapSet.size(tvisited) + 1
  end

  def do_move_tail2({hx, hy}, {tx, ty}) do
    # dbg tvisited
    {dx, dy} = {hx-tx, hy-ty}
    res = cond do
      # if same row or col
      (dy == 0) && ((dx > 1) or (dx < -1)) -> {tx+div(dx,2), ty} # if same row
      (dx == 0) && ((dy > 1) or (dy < -1)) -> {tx, ty+div(dy,2)} # if same col
      # if diag, two steps away in both dx, dy
      ((dy > 1) or (dy < -1)) && ((dx > 1) or (dx < -1)) -> {tx+div(dx,2), ty+div(dy,2)}
      # if diag, multiple rules
      ((dx != 0) && (dy != 0)) && ((dy > 1) or (dy < -1)) -> {tx+dx, ty+div(dy,2)}
      ((dx != 0) && (dy != 0)) && ((dx > 1) or (dx < -1)) -> {tx+div(dx,2), ty+dy}
      # h and t in same pos, or touching in any direction
      true -> {tx, ty}
    end
    # dbg res
  end

  # hd(rope) should always contain the manually added head_move before invoking this func
  def update_rope(rope, tvisited) do
    [head|rest_of_rope] = rope
    updated_rope = List.foldl(rest_of_rope, [head], fn curr_knot, updated_knots ->
      # dbg rest_of_rope
      # dbg head
      # dbg curr_knot
      # dbg updated_knots
      [do_move_tail2(hd(updated_knots), curr_knot)]++updated_knots
    end)
    # dbg updated_rope
    # dbg tvisited
    {Enum.reverse(updated_rope), MapSet.put(tvisited, hd(updated_rope))}
  end

  def part_two() do
    input = load_input("./lib/day9/input.txt")
    dbg input
    moves = input
    |> Enum.map(fn x -> [move, times] = String.split(x); [move] |> List.duplicate(String.to_integer(times)) |> List.flatten end)
    |> List.flatten
    dbg moves

    # {hx, hy}, {tx, ty}, tvisited
    headpositions = moves
    |> List.foldl([{0,0}], fn x, acc -> [do_move_head(x, hd(acc))]++acc end)
    |> Enum.reverse

    dbg headpositions

    tvisited = MapSet.new()
    rope = [{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}]
    {final_rope, final_tvisited} = List.foldl(headpositions, {rope, tvisited}, fn headpos, {rp, tvis} ->
      update_rope([headpos]++tl(rp), tvis)
    end)
    dbg {final_rope, final_tvisited}
    dbg MapSet.size(final_tvisited)
    # {rope, tvisited} = update_rope([Enum.at(headpositions, 1)]++rope, tvisited)
    # dbg {rope, tvisited}

    # {rope, tvisited} = update_rope([Enum.at(headpositions, 2)]++rope, tvisited)
    # dbg {rope, tvisited}

    # {rope, tvisited} = update_rope([Enum.at(headpositions, 3)]++rope, tvisited)
    # dbg {rope, tvisited}

  end
end

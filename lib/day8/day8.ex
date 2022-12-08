defmodule Day8 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    String.split(text, ["\n", "\r", "\r\n"])
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
  end

  # inspiration from https://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir/
  def create_matrix(list) do
    do_create_matrix(list)
  end

  # when no body, defined as a header
  defp do_create_matrix(list, map \\ %{}, index \\ 0)

  # final state for each inner list
  defp do_create_matrix([], map, _index) do
    IO.puts "do_create_matrix([], map, _index)"
    IO.inspect map
    map
  end

  # still consuming the list
  defp do_create_matrix([h|t], map, index) do
    IO.puts "do_create_matrix([h|t], map, index)"
    IO.inspect h
    IO.inspect t
    IO.inspect map
    IO.inspect index
    # if 'h == [1,2,3]' then do_create_matrix(h) will invoke the current function with
    # the do_create_matrix(list, map \\ %{}, index \\ 0) header and default values
    # therefore creating a new Map. In the recursive invocation of this function
    # h will be a single element (here called other).
    #
    # if 'h == other' then do_create_matrix(h) will invoke the function
    # do_create_matrix(other, _map, _index) and simply return h.
    map = Map.put(map, index, do_create_matrix(h))
    do_create_matrix(t, map, index + 1)
  end

  # a single element left
  defp do_create_matrix(other, _map, _index) do
    IO.puts "do_create_matrix(other, _map, _index)"
    IO.inspect other
    # dbg other
    # dbg _map
    # dbg _index
    {other, 0} #height, visibility
  end

  def set_cell_visibility(matrix, x, y, visible) do
    case visible do
      true -> put_in(matrix[x][y], {elem(matrix[x][y], 0), 1})
      _ -> matrix
    end
    # matrix = put_in(matrix[x][y], {elem(matrix[x][y], 0), 1})
    # matrix
  end

  # input #=> [
  #   [3, 0, 3, 7, 3],
  #   [2, 5, 5, 1, 2],
  #   [6, 5, 3, 3, 2],
  #   [3, 3, 5, 4, 9],
  #   [3, 5, 3, 9, 0]
  # ]

  def get_cells(matrix, x, y, h, w) do
    left  = List.foldl(Enum.to_list(0..(x-1)), [], fn e, acc -> {height, _} = matrix[e][y]; [height]++acc end) #the acc list should contain only heights
    right = List.foldl(Enum.to_list((x+1)..w), [], fn e, acc -> {height, _} = matrix[e][y]; [height]++acc end)
    up    = List.foldl(Enum.to_list(0..(y-1)), [], fn e, acc -> {height, _} = matrix[x][e]; [height]++acc end)
    down  = List.foldl(Enum.to_list((y+1)..h), [], fn e, acc -> {height, _} = matrix[x][e]; [height]++acc end)
    dbg {x, y}
    dbg matrix[x][y]
    dbg {h, w}
    dbg {left, right, up, down}
    [left, right, up, down]
    # left = for i <- 0..(row-1) do
    # end
  end

  def cell_visible?(matrix, x, y, h, w) do
    cond do
      (x == 0) or (x == w) -> true
      (y == 0) or (y == h) -> true
      true ->
        [left, right, up, down] = get_cells(matrix, x, y, h, w)
        {e, _} = matrix[x][y]
        tallest_to_left = is_tallest?(e, left)
        tallest_to_right = is_tallest?(e, right)
        tallest_to_up = is_tallest?(e, up)
        tallest_to_down = is_tallest?(e, down)
        tallest_to_left or tallest_to_right or tallest_to_up or tallest_to_down
    end
  end

  def is_tallest?(e, list) do
    tallest = list |> Enum.sort() |> Enum.reverse |> hd
    e > tallest
  end

  def set_visible(matrix, h, w) do
    vis_matrix = List.foldl(Enum.to_list(0..(h)), matrix, fn y, acc -> List.foldl(Enum.to_list(0..(w)), acc, fn x, accc -> set_cell_visibility(accc, x, y, cell_visible?(accc, x, y, h, w)) end) end)
    vis_matrix
  end

  def count_visible(matrix, h, w) do
    List.foldl(Enum.to_list(0..(h)), 0, fn y, acc -> List.foldl(Enum.to_list(0..(w)), acc, fn x, acc -> {_, visible} = matrix[x][y]; acc+visible end) end)
  end

  def part_one() do
    input = load_input("./lib/day8/input.txt")
    dbg input
    # input = [["1", "2"],["3", "4"]]
    h = length(input)
    w = length(hd(input))
    # dbg h
    # dbg w
    matrix = create_matrix(input)
    dbg matrix
    matrix_visible = set_visible(matrix, h-1, w-1)
    dbg matrix_visible
    dbg count_visible(matrix_visible, h-1, w-1)
    dbg "hello"
  end
end

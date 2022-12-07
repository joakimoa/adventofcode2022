defmodule Day7 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    String.split(text, ["\n", "\r", "\r\n"])
  end

  def parse_line(line, state) do
    parts = String.split(line)
    case parts do
      ["$" | tail] ->
        case tail do
          ["cd", ".."] -> do_cd_up(state)
          ["cd", dirname] -> do_cd(dirname, state)
          ["ls"] -> do_ls(state)
          _ -> "error"
        end
      ["dir", dirname] -> do_dir_info(dirname, state)
      [filesize, _] -> do_file_info(filesize, state)
      _ -> "error2"
     end
  end

  def do_cd_up({path, tree}) do
    {_, new_path} = List.pop_at(path, -1)
    dbg "do_cd_up path:" <> Enum.join(path, "/") <> " target:" <> Enum.join(new_path, "/")
    {new_path, tree}
  end

  def do_cd(dirname, {path, tree}) do
    dbg "do_cd path:" <> Enum.join(path, "/") <> " target:" <> dirname
    new_path = path++[dirname]
    new_tree = Map.put(tree, new_path, [])
    {new_path, new_tree}
  end

  def do_ls({path, tree}) do
    dbg "$ lsls"
    new_tree = Map.put(tree, path, [])
    {path, new_tree}
  end

  def do_dir_info(dirname, {path, tree}) do
    dbg "dirdir " <> Enum.join(path, "/")
    {content, new_tree} = Map.pop(tree, path)
    new_content = content ++ [{:dir, path++[dirname]}]
    new_tree = Map.put(new_tree, path, new_content)
    {path, new_tree}
  end

  def do_file_info(filesize, {path, tree}) do
    dbg "filesize:" <> filesize
    {content, new_tree} = Map.pop(tree, path)
    new_content = content ++ [{:file, filesize}]
    new_tree = Map.put(new_tree, path, new_content)
    {path, new_tree}
  end

  def calc_sizes(tree) do
    do_calc_sizes([".", "/"], tree)
  end

  def do_calc_sizes(path, tree) do
    content = Map.get(tree, path)
    size = Enum.map(content, &do_calc_size_entry(&1, tree))
    Enum.sum(size)
  end

  def do_calc_size_entry({:file, size}, _) do
    String.to_integer(size)
  end
  def do_calc_size_entry({:dir, path}, tree) do
    do_calc_sizes(path, tree)
  end

  def part_two() do
    input = load_input("./lib/Day7/input.txt")
    dbg input
    state = List.foldl(input, {["."], %{}}, fn(line, acc) -> parse_line(line, acc) end)
    dbg state

    {_, tree} = state
    tot_size = calc_sizes(tree)
    dbg tot_size
    free_space = 70000000 - tot_size
    dbg free_space
    min_space_to_del = 30000000 - free_space
    dbg min_space_to_del

    all_sizes = Enum.map(tree, fn({k, _}) -> do_calc_sizes(k, tree) end)
    dbg all_sizes
    del_candidates = Enum.filter(all_sizes, fn(x) -> x >= min_space_to_del end)
    |> Enum.sort()
    dbg del_candidates
    dbg hd(del_candidates)
  end

  def part_one() do
    input = load_input("./lib/Day7/input.txt")
    dbg input
    state = List.foldl(input, {["."], %{}}, fn(line, acc) -> parse_line(line, acc) end)
    dbg state
    # inst = Enum.map(input, fn (line) -> parse_line(line) end)

    # path = ["/", "a", "b"]
    # tree = %{
    #   ["/"] => [{:file, 654}, {:file, 374853}, {:dir, ["/", "a"]}]
    #   ["/", "a"]=> [{:file, 1233}, {:dir, ["/", "a", "b"]}]
    #   ["/", "a", "b"] => [{:file, 477}, {:file, 3453477}, {:file, 43453}]
    # }
    # {path, tree}

    {_, tree} = state
    # sizes = calc_sizes(tree)
    # dbg sizes
    all_sizes = Enum.map(tree, fn({k, _}) -> do_calc_sizes(k, tree) end)
    dbg all_sizes
    filtered_sum = all_sizes
    |> Enum.filter(fn(x) -> x <= 100000 end)
    |> Enum.sum()
    dbg filtered_sum
  end
end

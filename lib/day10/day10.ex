defmodule Day10 do
  def load_input(path) do
    {:ok, text} = File.read(path)
    String.split(text, ["\n", "\r", "\r\n"])
  end

  def part_one() do
    instructions = load_input("./lib/day10/input.txt")
    |> Enum.map(fn x ->
      case x do
       "noop" -> {:noop, 0, 1}
        _ -> {:addx, String.to_integer(Enum.at(String.split(x),1)), 2}
      end
    end)
    dbg instructions

    # acc = {cycle, register, %([cycle => register, ...])}, if it's a noop we add one elem to mapset, if a addx we add two elem to it
    {cyc, reg, regmap} = List.foldl(instructions, {0, 1, %{}}, fn ins, {cycle, register, registermap} ->
      case ins do
        {:noop, _, _} -> {cycle+1, register, Map.put(registermap, cycle, register)}
        {:addx, val, _} ->
          u_registermap = Map.put(registermap, cycle, register);
          u_register = register + val;
          uu_registermap = Map.put(u_registermap, cycle+1, u_register);
          {cycle+2, u_register, uu_registermap}
      end
    end)
    dbg {cyc, reg, regmap}

    nums = [20, 60, 100, 140, 180, 220]
    nummap = Enum.map(nums, fn x -> {Map.get(regmap, x-2), x * Map.get(regmap, x-2)} end)
    # nummap = Enum.map(nums, fn x -> Map.get(regmap, x-2) end)
    # dbg [21, 19, 18, 21, 16, 18]
    dbg nummap
    sum = List.foldl(nummap, 0, fn {_, signal}, acc -> acc+signal end)
    dbg sum
    dbg "hello"
  end
end

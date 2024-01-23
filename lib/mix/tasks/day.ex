defmodule Mix.Tasks.Day do
  use Mix.Task

  defp parse_day_part(day_part) do
    [day, part] = String.split(day_part, ".")
    module_name = Module.concat([AdventOfCode, "Day#{day}", "Part#{part}"])
    module_path = Path.expand("lib/advent_of_code/day_#{day}/")
    {module_name, module_path}
  end

  def run([day_part]) do
    {module_name, module_path} = parse_day_part(day_part)
    file_path = Path.join([module_path, "input.txt"])
    apply(module_name, :run, [file_path])
  end

  def run([day_part, file_name]) do
    {module_name, module_path} = parse_day_part(day_part)
    file_path = Path.join([module_path, "#{file_name}.txt"])
    apply(module_name, :run, [file_path])
  end
end

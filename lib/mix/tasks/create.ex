defmodule Mix.Tasks.Create do
  use Mix.Task

  defp parse_result(result) do
    case result do
      :ok ->
        :ok

      {:error, reason} ->
        case reason do
          :eacces -> IO.puts("Can't create: Permission error while creating item")
          :eexist -> IO.puts("Can't create: Item already exists")
          :enoent -> IO.puts("Can't create: There's a missing folder in the path")
          :enospc -> IO.puts("Can't create: No space for item")
          :enotdir -> IO.puts("Can't create: There's something \"unfoldery\" in the path")
        end

        exit(:normal)
    end
  end

  defp create_file(filename, path) do
    build_path = fn file_name, path ->
      Path.join([path, file_name])
    end

    filename
    |> build_path.(path)
    |> File.touch()
    |> parse_result()
  end

  defp create_file(filename, path, contents) do
    build_path = fn file_name, path ->
      Path.join([path, file_name])
    end

    filename
    |> build_path.(path)
    |> File.write(contents)
    |> parse_result()
  end

  def run([day]) do
    module_path = Path.expand("lib/advent_of_code/day_#{day}/")

    IO.puts("Creating directory...")

    module_path
    |> File.mkdir()
    |> parse_result()

    IO.puts("Creating input files...")

    create_file("test.txt", module_path)
    create_file("input.txt", module_path)

    IO.puts("Creating solution files...")

    template_path = Path.expand("lib/mix/tasks/template")
    {_, contents} = File.read(template_path)

    day_1_contents =
      contents
      |> String.replace("$day_number$", day)
      |> String.replace("$part_number$", "1")

    day_2_contents =
      contents
      |> String.replace("$day_number$", day)
      |> String.replace("$part_number$", "2")

    create_file("part_1.ex", module_path, day_1_contents)
    create_file("part_2.ex", module_path, day_2_contents)

    IO.puts("All done!")
  end
end

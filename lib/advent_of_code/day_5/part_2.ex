alias AdventOfCode.Utils

defmodule AdventOfCode.Day5.Part2 do
  def seed_pair_to_range(input) do
    pair_to_seed_list = fn [range_start, range_length] ->
      range_start..(range_start + (range_length - 1))
    end

    input
    |> Enum.chunk_every(2)
    |> Enum.map(pair_to_seed_list)
  end

  def translate(input_range, map) do
    slicer_range = map.input

    {left_slice_result, left_remainder} =
      if input_range.first >= slicer_range.first do
        {nil, input_range}
      else
        Range.split(input_range, slicer_range.first - input_range.first)
      end

    {right_slice_result, right_remainder} =
      if left_remainder.last <= slicer_range.last do
        {nil, left_remainder}
      else
        Range.split(
          left_remainder,
          Range.size(left_remainder) - (left_remainder.last - slicer_range.last)
        )
      end

    output = fn map, input_first..input_last ->
      offset = map.output.first - map.input.first
      (input_first + offset)..(input_last + offset)
    end

    cond do
      left_slice_result === nil and right_slice_result !== nil ->
        {nil, output.(map, right_slice_result), right_remainder}

      left_slice_result !== nil and right_slice_result === nil ->
        {left_slice_result, output.(map, left_remainder), nil}

      left_slice_result === nil and right_slice_result === nil ->
        {nil, output.(map, left_remainder), nil}

      left_slice_result !== nil and right_slice_result !== nil ->
        {left_slice_result, output.(map, right_slice_result), right_remainder}
    end
  end

  def process_stage({[], _}, result) do
    result
  end

  def process_stage({[current_input | remaining_inputs], stage}, result) do
    Utils.pretty_print(
      "\n",
      %{
        "current_input" => current_input,
        "remaining_inputs" => remaining_inputs,
        "stage" => stage,
        "result" => result
      }
    )

    {as_is, translated, next_up} =
      stage
      |> Enum.find(fn slicer ->
        not Range.disjoint?(slicer.input, current_input)
      end)
      |> then(fn
        nil -> {current_input, nil, nil}
        map -> translate(current_input, map)
      end)

    next_iter_inputs =
      if next_up !== nil do
        [next_up | remaining_inputs]
      else
        remaining_inputs
      end

    next_iter_result =
      cond do
        as_is === nil and translated !== nil ->
          [translated | result]

        as_is !== nil and translated === nil ->
          [as_is | result]

        true ->
          [as_is, translated | result]
      end

    process_stage({next_iter_inputs, stage}, next_iter_result)
  end

  def parse_raw_map([_ | map_values]) do
    split_spaces_parse_int = fn str ->
      str
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end

    map_values
    |> Enum.map(split_spaces_parse_int)
    |> Enum.reduce([], fn [dest_start, src_start, range_length], arr ->
      [
        %{
          :input => src_start..(src_start + range_length - 1),
          :output => dest_start..(dest_start + range_length - 1),
          :length => range_length
        }
        | arr
      ]
    end)
    |> Enum.sort_by(& &1[:input].first, :asc)
  end

  def parse_file(file_name) do
    {_, content} = File.read(file_name)

    [[raw_seeds] | raw_maps] =
      content
      |> String.split(["\n", "\r\n"])
      |> Enum.chunk_by(&(&1 === ""))
      |> Enum.filter(&(&1 !== [""]))

    maps =
      raw_maps
      |> Enum.map(&parse_raw_map/1)

    [_ | [seeds_input]] = String.split(raw_seeds, ": ")

    seeds =
      seeds_input
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> seed_pair_to_range()
      |> Enum.sort_by(& &1.first, :asc)

    {seeds, maps}
  end

  def run(file_name) do
    {seeds, maps} = parse_file(file_name)

    closest_location =
      maps
      |> Enum.reduce(seeds, &process_stage({&2, &1}, []))
      |> Enum.map(& &1.first)
      |> Enum.min()

    Utils.pretty_print("\n\nRecommended location", closest_location)
  end
end

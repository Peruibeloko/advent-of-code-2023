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
    Logging.pretty_print(
      %{
        "current_input" => current_input,
        "remaining_inputs" => remaining_inputs,
        "stage" => stage,
        "result" => result
      },
      "\n"
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

  def line_parser(line) do
    [raw_seeds | raw_maps] =
      line
      |> Enum.chunk_by(&(&1 === ""))
      |> Enum.filter(&(&1 !== [""]))

    seeds =
      raw_seeds
      |> hd()
      |> String.split(": ")
      |> tl()
      |> hd()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> seed_pair_to_range()
      |> Enum.sort_by(& &1.first, :asc)

    raw_maps
    |> Enum.map(&parse_raw_map/1)
    |> Enum.reduce(seeds, &process_stage({&2, &1}, []))
    |> Enum.map(& &1.first)
  end

  def run(file_name) do
    file_name
    |> Utils.parse_file(&line_parser/1)
    |> Enum.min()
    |> Logging.pretty_print("\n\nRecommended location")
  end
end

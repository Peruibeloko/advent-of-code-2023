slicer start <= input start
  {nil, input inteiro}

slicer start > input start
  { slice, resto } = Range.split(slicer start - input start)

resto ->

slicer end >= input end
  {nil, input inteiro}

slicer end < input end
  Range.split(input size - (input end - slicer end))

---

- pra cada input range, identificar os fatiadores relevantes
- ordenar os fatiadores por ordem de entrada
- fatiar cada range
- da fatia e do resto, fatiar o resto com o próximo fatiador

---

        [5 6 7 8 9]
[1 2 3 4 5 6]

{  nil, [5 6 7 8 9]}
{[5 6], [7 8 9]    }

---

        [5 6 7 8 9]
              [8 9 10 11]

{[5 6 7], [8 9]}
{    nil, [8 9]}

---

        [5 6 7 8 9]
          [6 7 8]
        
{    [5], [6 7 8 9]}
{[6 7 8], [9]      }

{[5], [6 7 8], [9]}

---

        [5 6 7 8 9]
    [3 4 5 6 7 8 9 10 11]

{nil, [5 6 7 8 9]}
{nil, [5 6 7 8 9]}

---

left_slice_result === nil !== right_slice_result
  {translate(right_slice_result), next_slicer(right_remainder)}
right_slice_result === nil !== left_slice_result
  {as_is(left_slice_result), translate(left_remainder)}
right_slice_result === nil === left_slice_result
  {translate(left_remainder)}
right_slice_result !== nil !== left_slice_result
  {as_is(left_slice_result), translate(right_slice_result), next_slicer(right_remainder)}

---

pra traduzir é só calcular o offset entre o first do input e do output do map e somar isso no first e last do range a ser traduzido
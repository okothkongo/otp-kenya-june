defmodule Kumbuka.Eraser do
  defstruct [:text, :steps]

  def new(text, no_of_steps) do
    __struct__(text: text, steps: build_steps(text, no_of_steps))
  end

  def eraser(%__MODULE__{text: text, steps: [head | tail]} = passage) do
    %__MODULE__{passage | text: delete_chars(text, head), steps: tail}
  end

  def delete_chars(text, step) do
    text
    |> String.graphemes()
    |> Enum.with_index(1)
    |> Enum.map(fn tuple -> replace(tuple, step) end)
    |> Enum.join()
  end

  defp replace({char, index}, indexes) do
    if index in indexes do
      if Regex.match?(~r/[.!? ",\r\n]/, char) do
        char
      else
        "_"
      end
    else
      char
    end
  end

  defp build_steps(text, no_of_steps) do
    size = String.length(text)

    1..size
    |> Enum.shuffle()
    |> Enum.chunk_every(step_size(no_of_steps, size))
  end

  defp step_size(no_of_steps, size) do
    size
    |> Kernel./(no_of_steps)
    |> ceil
  end
end

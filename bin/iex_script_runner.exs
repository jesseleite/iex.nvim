# Set default inspect opts
inspect_opts = [
  syntax_colors: IO.ANSI.syntax_colors()
]

# Get default inspect function
default_inspect_fun = Inspect.Opts.default_inspect_fun()

# Add our inspect opts to default inspect function
Inspect.Opts.default_inspect_fun(fn term, opts ->
  default_inspect_fun.(term, struct(Inspect.Opts, Keyword.merge(Map.to_list(opts), inspect_opts)))
end)

# Get scratch file from args, falling back to default
scratch_file = List.first(System.argv(), ".iex.exs")

# Get last meaningful line in user's script
last_line =
  scratch_file
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.trim/1)
  |> Enum.reject(&(&1 == "" or String.starts_with?(&1, "#")))
  |> List.last("")

# Evaluate user's script
{result, _} = Code.eval_file(scratch_file)

# Inspect result, unless user's last line includes `dbg` or `IO.inspect`
if not String.contains?(last_line, ["dbg", "IO.inspect"]) do
  IO.inspect(result, inspect_opts)
end

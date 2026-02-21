"hello-world"
|> String.replace("-", " ")
|> String.upcase()
|> dbg()

now =
  :calendar.local_time()
  |> NaiveDateTime.from_erl!()
  |> NaiveDateTime.to_string()

%{
  "current_time" => now,
  "instructions" => "Write this buffer to run it!"
}

# IEx.nvim

Run Elixir via IEx inside Neovim! 🧪

![](screenshot2.png)

- [Rationale](#rationale)
- [Installation](#installation)
- [Usage](#usage)
    - [Opening Your Scratch File](#opening-your-scratch-file)
    - [Running Your Scratch File](#running-your-scratch-file)
    - [How It Works](#how-it-works)
- [Advanced Configuration](#advanced-configuration)
- [Thank You](#thank-you)

## Rationale

Q: Why use IEx.nvim at all when you can just run `iex` or `mix run` from the command line?

A: Because inside Neovim you get all of your LSP, snippets, autocompletions, hotkeys, etc. It's a more pleasant coding experience, and IEx [already natively supports](https://hexdocs.pm/iex/IEx.html#module-the-iex-exs-file) reading from `.iex.exs` as a persistent scratch file convention.

## Installation

1. Install using your favourite package manager:

    **Using [lazy.nvim](https://github.com/folke/lazy.nvim):**

    ```lua
    {
      "jesseleite/iex.nvim",
      lazy = false,
      opts = {
        -- All of your `setup(opts)` will go here when using lazy.nvim
      },
    }
    ```

2. Optionally map some keybindings:

    ```lua
    vim.keymap.set("n", "<Leader>io", vim.cmd.IEx, { desc = "Open IEx scratch file" })
    vim.keymap.set("n", "<Leader>ir", vim.cmd.IExRun, { desc = "Run IEx in vsplit" })
    ```

3. Optionally add `.iex.exs` to your [global git excludes](https://gist.github.com/subfuzion/db7f57fff2fb6998a16c), so that you don't have to ignore it in each project.

4. Order a tasty elixir! 🥃 🤘 😎

## Usage

### Opening Your Scratch File

Run `:IEx` to open (or create) an `.iex.exs` scratch file in your current working directory.


### Running Your Scratch File

Run `:IExRun` to evaluate your scratch file and display the output in a vertical split.

### How It Works

The `.iex.exs` scratch file is [automatically read](https://hexdocs.pm/iex/IEx.html#module-the-iex-exs-file) by Elixir when running `iex` on the CLI, so IEx.nvim uses the same first-party scratch file convention by default.

When running, it uses `mix run .iex.exs` under the hood, which is essentially the same as `iex -S mix`, but doesn't keep the session open. This process will read your scratch file, display output, and exit the process for you.

As for output, the last expression in your scratch file is automatically inspected and displayed, unless it already contains a `dbg` or `IO.inspect` call. Feel free to use your own `dbg` or `IO.inspect` calls throughout your scratch file as well.

## Advanced Configuration

The default configuration:

```lua
require("iex").setup {
  scratch_file = ".iex.exs",
  output_buf_name = "iex:///output",
  run_on_save = true,
}
```

| Option | Default | Description |
| --- | --- | --- |
| `scratch_file` | `".iex.exs"` | File name of the scratch file created in your project root |
| `output_buf_name` | `"iex:///output"` | Buffer name displayed when running and viewing output |
| `run_on_save` | `true` | Whether or not to automatically run `:IExRun` on save |

## Thank You!

Thank you for checking out IEx.nvim!

Here's where can find me on the internet...

[jesseleite.com](https://jesseleite.com)<br>
[Software Developer @ SavvyCal](https://savvycal.com/home)<br>
[X](https://x.com/jesseleite85)<br>
[My Neovim config](https://github.com/jesseleite/dotfiles/tree/master/nvim)<br>
[My NeovimConf talk on macros](https://youtu.be/5x3dXo8aDCI?si=9_hKDsRXiC76AWDK) 📺<br>

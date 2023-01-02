# sad.nvim

Space Age seD in neovim. A project wide find and replace plugin with sad & fzf

This plug is a wrapper for [sad](https://github.com/ms-jpq/sad) by `ms-jqd`

You need

- [install sad](https://github.com/ms-jpq/sad#get-sad-now)
- [fzf](https://github.com/junegunn/fzf) so you can confirm/select the matches to apply your changes
- by default the plugin using [fd](https://github.com/sharkdp/fd) to list all files in the current folder, you can use
  `git ls_file`
- a pager tool, e.g. `delta`

https://user-images.githubusercontent.com/1681295/144705615-658ab025-f2a3-4857-b9d3-e5e2142bf316.mp4

# install

## Plug

```
Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
Plug 'ray-x/sad.nvim'
```

## packer
```lua
  require("packer").startup({
    function(use)
      use({ "wbthomason/packer.nvim" })
      use({
        "ray-x/sad.nvim",
        requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
        config = function()
          require("sad").setup{}
        end,
      })
    end,
  })
```

# Configure

```lua
require'sad'.setup({
  diff = 'delta', -- you can use `less`, `diff-so-fancy`
  ls_file = 'fd', -- also git ls_file
  exact = false, -- exact match
  vsplit = true, -- split sad window the screen vertically, when set to number
  -- it is a threadhold when window is larger than the threshold sad will split vertically,
  height_ratio = 0.6, -- height ratio of sad window when split horizontally
  width_ratio = 0.6, -- height ratio of sad window when split vertically

})
```

# usage

- If you put your cursor on the word want to replace or visual select the word you want to replace, simply run

```
:Sad
```

You will be prompt to input new word to be replace

- replace all `oldtext` to `newtext` for all project files

```vim
:Sad oldtext newtext
```

- add file filter, e.g lua files

```vim
:Sad oldtext newtext lua
```

- The lua way, you can add key map

```lua

-- replace old with new
lua require'sad'.replace('old', 'new')

-- or replace old with input for 'md' files
lua require'sad'.replace('old', nil, 'md')

-- or replace expand('<word>') or visual select with 'new' for md files
lua require'sad'.replace(nil, 'new', 'md')

-- or replace expand('<word>') or visual select with your input for md files
lua require'sad'.replace(nil, nil, 'md')

```

## confirm or cancel

- \<Tab> To toggle the individual item in the replacement list
- \<CR> to confirm and apply all the replacement
- \<Esc> to cancel all changes
- \<Ctrl-a> toggle select all

# Alternatives

- vim&neovim: [far.vim](https://github.com/brooth/far.vim) a vim plugin with python & vimscript

- neovim: [nvim-spectre](https://github.com/windwp/nvim-spectre) Lua plugin, find with `rg` and replace with `sed`

  and most importantly, with realtime preview

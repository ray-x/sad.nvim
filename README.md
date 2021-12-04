# sad.nvim

Space Age seD in neovim. A project wide find and replace plugin with sad & fzf

This plug is a wrapper for [sad](https://github.com/ms-jpq/sad) by `ms-jqd`
Also fzf will need to be installed [fzf](https://github.com/junegunn/fzf) for preview and filter

You need [install sad](https://github.com/ms-jpq/sad#get-sad-now) and `fzf`, and a pager tool, e.g. `delta`

https://user-images.githubusercontent.com/1681295/144705615-658ab025-f2a3-4857-b9d3-e5e2142bf316.mp4

# install

```
Plug 'ray-x/guihua.lua'  "lua GUI lib
Plug 'ray-x/sad.nvim'
```

# Configure

```lua
require'sad'.setup({
  diff = 'delta', -- you can use `diff`, `diff-so-fancy`
  ls_file = 'fd', -- also git ls_file
  exact = false, -- exact match

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

# Alternatives

- vim&neovim: [far.vim](https://github.com/brooth/far.vim) a vim plugin with python & vimscript

- neovim: [nvim-spectre](https://github.com/windwp/nvim-spectre) Lua plugin, find with `rg` and replace with `sed`

  and most importantly, with realtime preview

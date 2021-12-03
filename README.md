# sad.nvim

Space Age seD in neovim. A project wide find and replace plugin with sad & fzf

This plug is a wrapper for [Sad](https://github.com/ms-jpq/sad)
Also fzf will need to be installed [fzf](https://github.com/junegunn/fzf) for preview

You need install `sad` [Install](https://github.com/ms-jpq/sad#get-sad-now)

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

```vim
:Sad oldtext newtext
```

replace all `oldtext` to `newtext` for `lua` files

```vim
:Sad oldtext newtext lua
```

```lua
lua require'sad'.replace('old', 'new')
```

If you put your cursor on the word want to replace or visual select the word you want to replace, you can input the new word

```
:Sad
```

# Alternatives

- vim&neovim: [far.vim](https://github.com/brooth/far.vim) implemented with python & vimscript

- neovim: [nvim-spectre](https://github.com/windwp/nvim-spectre) Lua plugin, find with `rg` and replace with `sed`

  and realtime preview

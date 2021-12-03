# sad.nvim

Space Age seD in neovim. A project wide find and replace plugin with sad & fzf

This plug is a wrapper for [Sad](https://github.com/ms-jpq/sad)
Also fzf will need to be installed [fzf](https://github.com/junegunn/fzf)

You need install `sad` [Install](https://github.com/ms-jpq/sad#get-sad-now)

# install

```
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

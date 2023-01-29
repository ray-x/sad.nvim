local M = {}

local api = vim.api
local log = function(...) end
_SAD_CFG = {
  debug = false,
  autoclose = true,
  ls_file = 'fd', -- git ls-file
  diff = 'delta', -- diff-so-fancy
  exact = false, -- Exact match
  vsplit = false, -- split sad window the screen vertically
  height_ratio = 0.6, -- height ratio of sad window when split horizontally
  width_ratio = 0.6, -- height ratio of sad window when split vertically
}

M.setup = function(cfg)
  cfg = cfg or {}
  _SAD_CFG = vim.tbl_extend('force', _SAD_CFG, cfg)

  local utils = require('sad.utils')
  local guihua_helper = utils.load_plugin('guihua.lua', 'guihua.helper')
  if not guihua_helper then
    utils.warn('guihua not installed, please install ray-x/guihua.lua for GUI functions')
  end
  local installer = utils.installer()

  log = utils.log
  if _SAD_CFG.debug then
    if lprint then
      log = lprint
    else
      log = print
    end
  end

  if not guihua_helper.is_installed(_SAD_CFG.ls_file) then
    utils.info(
      'please install ' .. _SAD_CFG.ls_file .. ' e.g. `' .. installer .. ' install ' .. _SAD_CFG.ls_file .. '`'
    )
  end

  if _SAD_CFG.diff then
    local d = vim.split(_SAD_CFG.diff, ' ')[1] or 'delta'
    if not guihua_helper.is_installed(d) then
      utils.info('please install ' .. _SAD_CFG.diff .. ' e.g.  `' .. installer .. ' install ' .. _SAD_CFG.diff .. '`')
    end
  end
  if not guihua_helper.is_installed('sad') then
    utils.info('please install sad, e.g. `' .. installer .. ' install ms-jpq/sad/sad`')
  end
end

M.Replace = function(old, rep, ls_args)
  local columns = api.nvim_get_option('columns')
  local delta_width = math.floor(columns * _SAD_CFG.width_ratio)
  if old == nil then
    old = vim.fn.expand('<cword>')
    local _, line_start, column_start, _ = unpack(vim.fn.getpos("'<"))
    if line_start ~= 0 and column_start ~= 0 then
      local _, line_end, column_end, _ = unpack(vim.fn.getpos("'>"))
      local lines = vim.fn.getline(line_start, line_end)
      if lines and #lines > 0 then
        lines[#lines] = string.sub(lines[#lines], 1, column_end) -- [:column_end - 2]
        lines[1] = string.sub(lines[1], column_start, -1) -- [column_start - 1:]
        old = vim.fn.join(lines, '\n')
      end
    end
  end

  -- user specify the args with escape
  -- local oldr = string.gsub(old, '%(', [[\(]])
  -- oldr = string.gsub(oldr, '%)', [[\)]])
  -- local oldr = string.gsub(old, '%*', [[\*]])
  local oldr = old

  local repel = "'" .. oldr .. "'"
  if rep == nil then
    rep = vim.fn.input("Replace '" .. oldr .. "' with: ", repel)
  end
  log(oldr)
  if oldr:sub(1, 1) == "'" then
    old = oldr:sub(2, #oldr)
  end

  if oldr:sub(#oldr, #oldr) == "'" then
    old = old:sub(1, #oldr - 1)
  end

  -- log(rep, "sss", rep[1], rep[2], rep[#rep])
  if rep:sub(1, 1) == "'" then
    rep = rep:sub(2, #rep)
    -- log(rep)

    if rep:sub(#rep, #rep) == "'" then
      rep = rep:sub(1, #rep - 1)
      -- log(rep)
    end
  end

  -- log(rep)
  local exact = ''
  if _SAD_CFG.exact then
    exact = ' --exact '
  end

  if ls_args == nil then
    ls_args = ''
  end
  local w = math.floor(api.nvim_get_option('columns') * _SAD_CFG.width_ratio)
  local cmd = string.format(
    [[export FZF_DEFAULT_OPTS='--height 90%% --layout=reverse --border --multi --bind=ctrl-a:toggle-all';export FZF_PREVIEW_COLUMNS=%d;export FZF_PREVIEW_LINES=33;]],
    w
  )

  if _SAD_CFG.diff:find('delta') then
    _SAD_CFG.diff = string.format("'delta -w %d'", w)
  end
  cmd = cmd
    .. _SAD_CFG.ls_file
    .. ' '
    .. ls_args
    .. [[ |  sad ]]
    .. exact
    .. [[ --pager ]]
    .. _SAD_CFG.diff
    .. " '"
    .. oldr
    .. "' '"
    .. rep
    .. "'"

  api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
    group = api.nvim_create_augroup('SadAuGroup', {}),
    callback = function()
      vim.cmd('checktime')
    end,
  })

  log(cmd)
  log(vim.fn.getcwd())
  local term = require('sad.term').run
  local ret = term({ cmd = cmd, autoclose = _SAD_CFG.autoclose })

  log(ret)
end

vim.cmd([[command! -nargs=* Sad lua require("sad").Replace(<f-args>)]])

return M

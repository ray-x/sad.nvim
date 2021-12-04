local M = {}
-- local ListView = require "guihua.listview"
-- local TextView = require "guihua.textview"
-- local util = require "navigator.util"
-- local log = require"navigator.util".log
-- local trace = require"navigator.util".trace
-- local api = vim.api

local utils = require('sad.utils')
local log = utils.log
local lprint = lprint or log
_SAD_CFG = {
  ls_file = 'fd', -- git ls-file
  diff = 'delta', -- diff-so-fancy
  exact = false -- Exact match
}

M.setup = function(cfg)
  cfg = cfg or {}
  _SAD_CFG = vim.tbl_extend("force", _SAD_CFG, cfg)
end

M.Replace = function(old, rep, ls_args)
  if old == nil then
    old = vim.fn.expand("<cword>")
    local _, line_start, column_start, _ = unpack(vim.fn.getpos("'<"))
    if line_start ~= 0 and column_start ~= 0 then
      local _, line_end, column_end, _ = unpack(vim.fn.getpos("'>"))
      local lines = vim.fn.getline(line_start, line_end)
      if lines and #lines > 0 then
        lines[#lines] = string.sub(lines[#lines], 1, column_end) -- [:column_end - 2]
        lines[1] = string.sub(lines[1], column_start, -1) -- [column_start - 1:]
        old = vim.fn.join(lines, "\n")
      end
    end
  end

  local oldr = string.gsub(old, '%(', [[\(]])
  oldr = string.gsub(oldr, '%)', [[\)]])
  oldr = string.gsub(oldr, '%*', [[\*]])

  local repel = "'" .. oldr .. "'"
  if rep == nil then
    rep = vim.fn.input("Replace '" .. oldr .. "' with: ", repel)
  end
  lprint(oldr)
  if oldr:sub(1, 1) == "'" then
    old = oldr:sub(2, #oldr)
  end

  if oldr:sub(#oldr, #oldr) == "'" then
    old = old:sub(1, #oldr - 1)
  end

  -- lprint(rep, "sss", rep[1], rep[2], rep[#rep])
  if rep:sub(1, 1) == "'" then
    rep = rep:sub(2, #rep)
    -- lprint(rep)

    if rep:sub(#rep, #rep) == "'" then
      rep = rep:sub(1, #rep - 1)
      -- lprint(rep)
    end
  end

  -- lprint(rep)
  local exact = ''
  if _SAD_CFG.exact then
    exact = ' --exact '
  end

  if ls_args == nil then
    ls_args = ''
  end
  local cmd = [[export FZF_DEFAULT_OPTS='--height 90% --layout=reverse --border'; ]] .. _SAD_CFG.ls_file .. ' '
                  .. ls_args .. [[ |  sad ]] .. exact .. [[ --pager ]] .. _SAD_CFG.diff .. " '" .. oldr .. "' '" .. rep
                  .. "'"

  lprint(cmd)
  local term = require('sad.term').run
  local ret = term({cmd = cmd, autoclose = true})

  lprint(ret)
end

vim.cmd([[command! -nargs=* Sad lua require("sad").Replace(<f-args>)]])

return M

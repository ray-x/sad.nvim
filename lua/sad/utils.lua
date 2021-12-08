local utils = {}

local os_name = vim.loop.os_uname().sysname
local is_windows = os_name == 'Windows' or os_name == 'Windows_NT'
function utils.sep()
  if is_windows then
    return '\\'
  end
  return '/'
end

function utils.load_plugin(name, modulename)
  assert(name ~= nil, "plugin should not empty")
  modulename = modulename or name
  local has, plugin = pcall(require, modulename)
  if has then
    return plugin
  end
  if packer_plugins ~= nil then
    -- packer installed
    local loader = require"packer".loader
    if not packer_plugins[name] or not packer_plugins[name].loaded then
      loader(name)
    end
  else
    vim.cmd("packadd " .. name) -- load with default
  end

  has, plugin = pcall(require, modulename)
  if not has then
    utils.warn("plugin failed to load " .. name)
  end
  return plugin
end

function utils.warn(msg)
  vim.api.nvim_echo({{"WRN: " .. msg, "WarningMsg"}}, true, {})
end

function utils.error(msg)
  vim.api.nvim_echo({{"ERR: " .. msg, "ErrorMsg"}}, true, {})
end

function utils.info(msg)
  vim.api.nvim_echo({{"Info: " .. msg}}, true, {})
end

utils.log = function(...)
  if _SAD_CFG.debug then
    if lprint then
      lprint(...)
      return
    end
    print(vim.inspect(...))
  end
end

return utils

local config = require("telescope-colorscheme-persist.config")

local M = {}

function M.debug_print(msg)
  if config.debug then
    vim.notify("DEBUG: " .. msg, vim.log.levels.INFO)
  end
end

return M

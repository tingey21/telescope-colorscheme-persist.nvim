local M = {
  file_path = vim.fn.stdpath("cache") .. "/telescope-colorscheme-persist/.nvim.colorscheme-persist.lua",
  fallback = "default",
  picker_opts = require("telescope.themes").get_dropdown(),
  debug = false,
  keybind = "<leader>uC",
}

function M.setup(opts)
  opts = opts or {}
  for k, v in pairs(opts) do
    if type(M[k]) == type(v) then
      M[k] = v
    else
      vim.notify("Invalid option type for " .. k, vim.log.levels.WARN)
    end
  end

  if M.debug then
    vim.notify("Config setup completed with options: " .. vim.inspect(opts), vim.log.levels.INFO)
  end
end

return M

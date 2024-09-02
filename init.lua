local config = require("telescope-colorscheme-persist.nvim.config")
local utils = require("telescope-colorscheme-persist.nvim.utils")
local telescope = require("telescope.builtin")
local M = {}

function M.get_colorscheme()
  utils.debug_print("Attempting to get saved colorscheme")
  if vim.fn.filereadable(config.file_path) == 0 then
    utils.debug_print("No saved colorscheme found, using current colorscheme")
    return vim.g.colors_name or config.fallback
  end
  local success, data = pcall(vim.fn.readfile, config.file_path)
  if success and #data > 0 then
    local colorscheme = data[1]
    if colorscheme == "return nil" or colorscheme == "" then
      utils.debug_print("Invalid saved colorscheme, using current colorscheme")
      return vim.g.colors_name or config.fallback
    end
    utils.debug_print("Loaded colorscheme: " .. colorscheme)
    return colorscheme
  else
    vim.notify("Error loading colorscheme, using current colorscheme", vim.log.levels.WARN)
    return vim.g.colors_name or config.fallback
  end
end

function M.apply_colorscheme(colorscheme)
  utils.debug_print("Applying colorscheme: " .. colorscheme)
  local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not ok then
    vim.notify("Error applying colorscheme: " .. err, vim.log.levels.ERROR)
    utils.debug_print("Attempting to apply fallback colorscheme: " .. config.fallback)
    pcall(vim.cmd, "colorscheme " .. config.fallback)
  else
    utils.debug_print("Colorscheme applied successfully: " .. colorscheme)
  end
end

function M.picker()
  utils.debug_print("Opening colorscheme picker")
  telescope.colorscheme({
    enable_preview = true,
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          vim.notify("colorscheme-persist: Selection not valid", vim.log.levels.ERROR)
          return
        end
        local colorscheme = selection.value
        M.apply_colorscheme(colorscheme)
        M.save_colorscheme(colorscheme)
      end)

      return true
    end,
  })
end

function M.save_colorscheme(colorscheme)
  utils.debug_print("Attempting to save colorscheme: " .. colorscheme)
  local dir = vim.fn.fnamemodify(config.file_path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  local success, err = pcall(vim.fn.writefile, { colorscheme }, config.file_path)
  if not success then
    vim.notify("Error saving colorscheme: " .. err, vim.log.levels.ERROR)
  else
    utils.debug_print("Colorscheme saved successfully: " .. colorscheme)
    vim.api.nvim_exec_autocmds("User", {
      pattern = "ColorschemeUpdate",
    })
  end
end

function M.setup(opts)
  config.setup(opts)
  M.current = M.get_colorscheme()
  -- Only apply the saved colorscheme if it's different from the current one
  if M.current ~= vim.g.colors_name then
    M.apply_colorscheme(M.current)
  end
  vim.keymap.set("n", config.keybind, M.picker, { desc = "Open colorscheme picker" })
end

return M

# telescope-colorscheme-persist

A Neovim plugin that allows you to persist your colorscheme selection across Neovim sessions using Telescope. It automatically saves your selected colorscheme and restores it on Neovim startup.

## Features

- Automatically saves your selected colorscheme
- Restores your last used colorscheme on Neovim startup
- Integrates with Telescope for easy colorscheme selection
- Fallback to default colorscheme if saved one is not available
- Debug mode for troubleshooting
- Customizable keybinding for opening the colorscheme picker

## Requirements

- Neovim (version X.X or higher) <!-- Replace X.X with the minimum required version -->
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)




## Lazy Configuration

Add the following to your Neovim configuration:
```
return {
  "tingey21/telescope-colorscheme-persist.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  lazy = false,
  config = function()
    require("telescope-colorscheme-persist").setup({})
  end,
}


```
### Default Configuration
```
{
  file_path = vim.fn.stdpath("cache") .. "/telescope-colorscheme-persist.nvim/.nvim.colorscheme-persist.lua",
  fallback = "default",
  picker_opts = require("telescope.themes").get_dropdown(),
  debug = false,
  keybind = "<leader>uC",
}

```
### Configuration Options

- `file_path`: The path where the selected colorscheme will be saved.
- `fallback`: The colorscheme to use if the saved one is not available.
- `picker_opts`: Options for the Telescope picker. Defaults to dropdown theme.
- `debug`: Enable debug mode for additional logging.
- `keybind`: The keybinding to open the colorscheme picker.

## Usage

1. Press `<leader>uC` (or your custom keybind) to open the Telescope colorscheme picker.
2. Select a colorscheme from the list.
3. The selected colorscheme will be applied immediately and saved for future Neovim sessions.

The plugin will automatically apply the saved colorscheme when you start Neovim. If the saved colorscheme is not available, it will fall back to the default colorscheme specified in the configuration.

## API

The plugin exposes the following functions:

- `get_colorscheme()`: Retrieves the saved colorscheme or falls back to the current/default colorscheme.
- `apply_colorscheme(colorscheme)`: Applies the specified colorscheme.
- `picker()`: Opens the Telescope colorscheme picker.
- `save_colorscheme(colorscheme)`: Saves the specified colorscheme.

## Events

The plugin triggers a custom event when the colorscheme is updated:

```
vim.api.nvim_exec_autocmds("User", {
  pattern = "ColorschemeUpdate",
})
```

You can use this event to perform additional actions when the colorscheme changes.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

[MIT License](LICENSE)

## Troubleshooting

If you encounter any issues, you can enable debug mode in the configuration to get more detailed logging:

```
require('telescope-colorscheme-persist.nvim').setup({
  debug = true
})
```

This will print debug information to help identify the problem.

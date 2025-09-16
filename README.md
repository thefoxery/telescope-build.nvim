
# telescope-cmake

Part of my ecosystem of CMake plugins for neovim
- [cmake.nvim](https://github.com/thefoxery/cmake.nvim) (main plugin, required)
- [telescope-cmake.nvim](https://github.com/thefoxery/telescope-cmake.nvim)
- [lualine-cmake.nvim](https://github.com/thefoxery/lualine-cmake.nvim)

Use Telescope to quickly change configuration/target for main cmake plugin

Provides telescope pickers for selecting:
- build type (debug, release etc)
- build target

# installation

```
# lazy

{
    "thefoxery/telescope-cmake.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "thefoxery/cmake.nvim",
    },
}

# in telescope setup

require("telescope").load_extension("cmake")

require("telescope").extensions.cmake.setup({}) # optional

```

# usage

```
# provides the following Telescope commands

:Telescope cmake select_build_target
:Telescope cmake select_build_type

```

Build types are provided by the CMake plugin.


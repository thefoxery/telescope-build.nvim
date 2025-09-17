
# telescope-build

Use Telescope to quickly change configuration/target for your build system

# installation

```
# lazy

{
    "thefoxery/telescope-build.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
}
```

# configuration

```
# after telescope setup
require("telescope").load_extension("build")

# example setup using 'thefoxery/cmake.nvim' plugin
require("telescope").extensions.build.setup({
    build_system = require("cmake"),
})

# example with custom build system
require("telescope").extensions.build.setup({
    build_system = {
        get_build_targets = function()
            return { "application", "editor" }
        end,
        get_build_target = function()
            return "current_build_target"
        end,
        get_build_types = function()
            return { "debug", "release" }
        end,
        get_build_type = function()
            return "current_build_target"
        end,
        set_build_type = function(build_type)
            -- set state in build system
        end,
        set_build_target = function(build_target)
            -- set state in build system
        end,
    }
})
```

# usage

```
# provides the following Telescope commands

:Telescope build select_build_target
:Telescope build select_build_type
```


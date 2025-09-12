
local PLUGIN_NAME = "telescope-cmake"

local is_telescope_installed, telescope = pcall(require, "telescope")
if not is_telescope_installed then
    error(string.format("%s plugin requires Telescope plugin", PLUGIN_NAME))
end

local is_cmake_installed, cmake = pcall(require, "cmake")
if not is_cmake_installed then
    error(string.format("%s plugin requires cmake.nvim plugin", PLUGIN_NAME))
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local state = require("cmake").state

local select_build_type = function()
    local configurations = { "MinSizeRel", "Debug", "Release", "RelWithDebInfo" }

    pickers.new({}, {
        prompt_title = "Select Build Type",
        finder = finders.new_table {
            results = configurations
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                selection = vim.trim(selection[1])
                state.set_build_type(selection)
                print(string.format("build type set to '%s'", selection))
            end)
            return true
        end,
    }):find()
end

local select_build_target = function()
    pickers.new({}, {
        prompt_title = "Select Build Target",
        finder = finders.new_table {
            results = cmake.get_build_target_names(),
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                selection = vim.trim(selection[1])
                state.set_build_target(selection)
                print(string.format("build target set to '%s'", selection))
            end)
            return true
        end,
    }):find()
end

return telescope.register_extension {
    exports = {
        select_build_type = select_build_type,
        select_build_target = select_build_target,
    },
}


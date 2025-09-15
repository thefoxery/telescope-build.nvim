
local PLUGIN_NAME = "telescope-cmake"

local is_telescope_installed, telescope = pcall(require, "telescope")
if not is_telescope_installed then
    error(string.format("%s plugin requires Telescope plugin", PLUGIN_NAME))
end

local is_cmake_installed, cmake = pcall(require, "cmake")
if not is_cmake_installed then
    error(string.format("%s plugin requires thefoxery/cmake.nvim plugin", PLUGIN_NAME))
end

if not cmake.is_setup() then
    error(string.format("cmake plugin is not set up"))
end

local function resolve(opt)
    if type(opt) == "function" then
        return opt()
    else
        return opt
    end
end

local default_opts = {
}

local opts = {
}

local function setup(user_opts)
    opts.notifications = resolve(user_opts.notifications) or default_opts.notifications or {}

    for notification, enabled in pairs(opts.notifications) do
        cmake.set_notification_enabled(notification, enabled)
    end
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local select_build_type = function()
    local configurations = cmake.get_build_types()

    local default_index = 0
    for index, value in ipairs(configurations) do
        if value == cmake.get_build_type() then
            default_index = index
            break
        end
    end

    pickers.new({}, {
        prompt_title = "Select Build Type",
        finder = finders.new_table {
            results = configurations
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                selection = vim.trim(selection[1])
                cmake.set_build_type(selection)
                actions.close(prompt_bufnr)
            end)
            return true
        end,
        default_selection_index = default_index,
    }):find()
end

local select_build_target = function()
    local build_target_names = cmake.get_build_target_names()

    local default_index = 0
    for index, value in ipairs(build_target_names) do
        if value == cmake.get_build_target() then
            default_index = index
            break
        end
    end

    pickers.new({}, {
        prompt_title = "Select Build Target",
        finder = finders.new_table {
            results = cmake.get_build_target_names(),
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                selection = vim.trim(selection[1])
                cmake.set_build_target(selection)
                actions.close(prompt_bufnr)
            end)
            return true
        end,
        default_selection_index = default_index,
    }):find()
end

return telescope.register_extension {
    exports = {
        setup = setup,
        select_build_type = select_build_type,
        select_build_target = select_build_target,
    },
}



local PLUGIN_NAME = "telescope-build"

local is_telescope_installed, telescope = pcall(require, "telescope")
if not is_telescope_installed then
    error(string.format("%s plugin requires Telescope plugin", PLUGIN_NAME))
end

local function resolve(opt)
    if type(opt) == "function" then
        return opt()
    else
        return opt
    end
end

local dummy_tbl_provider = function() return {} end
local dummy_str_provider = function() return "" end
local dummy_callback = function(_) end

local default_opts = {
    build_system = {
        get_build_types = dummy_tbl_provider,
        get_build_type = dummy_str_provider,
        get_build_targets = dummy_tbl_provider,
        get_build_target = dummy_str_provider,
        set_build_type = dummy_callback,
        set_build_target = dummy_callback,
    }
}

local opts = {
}

local function setup(user_opts)
    user_opts = user_opts or {}

    opts = vim.tbl_deep_extend("force", {}, default_opts)
    opts.build_system = vim.tbl_deep_extend("force", {}, default_opts.build_system, resolve(user_opts.build_system) or {})

    for name, _ in pairs(default_opts.build_system) do
        if opts.build_system[name] == nil or opts.build_system[name] == dummy_tbl_provider or opts.build_system[name] == dummy_callback then
            vim.notify(string.format("[%s] Configured build system missing function '%s'", PLUGIN_NAME, name), vim.log.levels.WARN)
        end
    end
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local select_build_type = function()
    local configurations = opts.build_system.get_build_types()

    local default_index = 0
    local build_type = opts.build_system.get_build_type()
    for index, value in ipairs(configurations) do
        if value == build_type then
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
                actions.close(prompt_bufnr)
                opts.build_system.set_build_type(selection)
            end)
            return true
        end,
        default_selection_index = default_index,
    }):find()
end

local select_build_target = function()
    local build_targets = opts.build_system.get_build_targets()

    local default_index = 0
    for index, build_target in ipairs(build_targets) do
        if build_target == opts.build_system.get_build_target() then
            default_index = index
            break
        end
    end

    pickers.new({}, {
        prompt_title = "Select Build Target",
        finder = finders.new_table {
            results = build_targets,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                selection = vim.trim(selection[1])
                actions.close(prompt_bufnr)
                opts.build_system.set_build_target(selection)
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


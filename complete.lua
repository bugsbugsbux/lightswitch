local M = {}

---@param candidates string[]
---@param prefix string
---@return string[]
local function prepare_candidates(candidates, prefix)
    local filtered = {} ---@type string[]
    for _, candidate in ipairs(candidates) do
        if vim.startswith(candidate, prefix) and #candidate > #prefix then
            table.insert(filtered, string.sub(candidate, #prefix + 1))
        end
    end
    return filtered
end

function M.cur_toggle(arglead, _, _)
    local get_switch_themes = require('user.lightswitch.core').get_switch_themes
    local candidates = get_switch_themes({all_groups=false, brightness=nil})
    return prepare_candidates(candidates, arglead)
end

function M.cur_light(arglead, _, _)
    local get_switch_themes = require('user.lightswitch.core').get_switch_themes
    local candidates = get_switch_themes({all_groups=false, brightness='light'})
    return prepare_candidates(candidates, arglead)
end

function M.cur_dark(arglead, _, _)
    local get_switch_themes = require('user.lightswitch.core').get_switch_themes
    local candidates = get_switch_themes({all_groups=false, brightness='dark'})
    return prepare_candidates(candidates, arglead)
end

function M.any_toggle(arglead, _, _)
    local get_switch_themes = require('user.lightswitch.core').get_switch_themes
    local candidates = get_switch_themes({all_groups=true, brightness=nil})
    return prepare_candidates(candidates, arglead)
end

function M.any_light(arglead, _, _)
    local get_switch_themes = require('user.lightswitch.core').get_switch_themes
    local candidates = get_switch_themes({all_groups=true, brightness='light'})
    return prepare_candidates(candidates, arglead)
end

function M.any_dark(arglead, _, _)
    local get_switch_themes = require('user.lightswitch.core').get_switch_themes
    local candidates = get_switch_themes({all_groups=true, brightness='dark'})
    return prepare_candidates(candidates, arglead)
end

return M

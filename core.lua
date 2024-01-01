local M = {}

---@param brightness 'dark'|'light'
---@return string
local function other(brightness)
    if brightness == 'dark' then return 'light'
    elseif brightness == 'light' then return 'dark'
    else error('ArgumentError: Expected "dark"|"light", got: ' .. tostring(brightness))
    end
end

---@return string[]
function M.get_switch_themes(opts)
    opts = opts or {all_groups = false, brightness = nil}
    local shared = require('lightswitch.shared')
    local theme = shared.state.theme
    if opts.brightness then
        assert(opts.brightness == 'dark' or opts.brightness == 'light')
    else
        ---@diagnostic disable-next-line:param-type-mismatch
        opts.brightness = other(shared.get_brightness(theme, shared.state.brightness))
    end
    if opts.all_groups then
        return shared.get_theme_names(opts.brightness)
    end
    if shared.themes[theme] then
        return shared.themes[theme].variants[opts.brightness]
    end
    return {}

end

---@param theme string
---@param brightness 'light'|'dark'
---@return nil
local function set_theme(theme, brightness)
    assert(type(theme) == 'string' and brightness == 'dark' or brightness == 'light')
    local shared = require('lightswitch.shared')
    local group = shared.themes[theme]
    if not group then
        vim.notify('Colorscheme not handled; update your config!')
        return
    end
    assert(vim.tbl_contains(group.variants[brightness], theme))
    local custom_switch = group.custom_switches[theme]
    if custom_switch then
        custom_switch(brightness)
        return
    end
    if not shared.get_brightness(theme) then -- dual, not unknown (bc if group)
        vim.cmd('colorscheme ' .. theme)
        vim.cmd('set background=' .. brightness)
        return
    end
    vim.cmd('colorscheme ' .. theme)
end

---@param brightness 'light'|'dark'
local function switch_brightness_to(brightness)
    assert(brightness == 'dark' or brightness == 'light')
    local shared = require('lightswitch.shared')
    theme = shared.state.theme
    if not shared.themes[theme] then
        vim.notify('Colorscheme not handled; update your config!')
        return
    end
    theme = shared.themes[theme].selected[brightness]
    set_theme(theme, brightness)
end

---@param theme? string
---without theme set selected light variant
---with theme allow light variants of current group
function M.cur_light(theme)
    local shared = require('lightswitch.shared')
    if not theme then return switch_brightness_to('light') end
    local valid = M.get_switch_themes({all_groups=false, brightness='light'})
    if not vim.tbl_contains(valid, theme) then
        error('ArgumentError: not a light version of '..shared.state.theme)
    end
    set_theme(theme, 'light')
end

---@param theme? string
---without theme set selected dark variant
---with theme allow dark variants of current group
function M.cur_dark(theme)
    local shared = require('lightswitch.shared')
    if not theme then return switch_brightness_to('dark') end
    local valid = M.get_switch_themes({all_groups=false, brightness='dark'})
    if not vim.tbl_contains(valid, theme) then
        error('ArgumentError: not a dark version of '..shared.state.theme)
    end
    set_theme(theme, 'dark')
end

---@param theme? string
---without theme set selected light variant
---with theme allow light variants of any group
function M.any_light(theme)
    local shared = require('lightswitch.shared')
    if not theme then return switch_brightness_to('light') end
    local valid = M.get_switch_themes({all_groups=true, brightness='light'})
    if not vim.tbl_contains(valid, theme) then
        error('ArgumentError: not a light version of '..shared.state.theme)
    end
    set_theme(theme, 'light')
end

---@param theme? string
---without theme set selected dark variant
---with theme allow dark variants of any group
function M.any_dark(theme)
    local shared = require('lightswitch.shared')
    if not theme then return switch_brightness_to('dark') end
    local valid = M.get_switch_themes({all_groups=true, brightness='dark'})
    if not vim.tbl_contains(valid, theme) then
        error('ArgumentError: not a dark version of '..shared.state.theme)
    end
    set_theme(theme, 'dark')
end

---@param theme? string
---without theme set other selected
---with theme allow other variants of current group
function M.cur_toggle(theme)
    local shared = require('lightswitch.shared')
    local new = theme or shared.state.theme
    ---@diagnostic disable-next-line:param-type-mismatch
    next_brightness = other(shared.get_brightness(new, shared.state.brightness))
    if not theme then
        return switch_brightness_to(next_brightness)
    end
    local valid = M.get_switch_themes({all_groups=false, brightness=nil})
    if not vim.tbl_contains(valid, theme) then
        error('ArgumentError: not a ' .. next_brightness .. ' theme')
    end
    set_theme(theme, next_brightness)
end

---@param theme? string
---without theme set other selected
---with theme allow other variants of any group
function M.any_toggle(theme)
    local shared = require('lightswitch.shared')
    local new = theme or shared.state.theme
    ---@diagnostic disable-next-line:param-type-mismatch
    next_brightness = other(shared.get_brightness(new, shared.state.brightness))
    if not theme then
        return switch_brightness_to(next_brightness)
    end
    local valid = M.get_switch_themes({all_groups=true, brightness=nil})
    if not vim.tbl_contains(valid, theme) then
        error('ArgumentError: not a ' .. next_brightness .. ' theme')
    end
    set_theme(theme, next_brightness)
end

return M

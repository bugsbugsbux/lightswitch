local M = {
    ---@type table<string, Themegroup>
    themes = require('lightswitch.builtin'),
    ---@type {theme:string,brightness:'dark'|'light'}
    state = nil,
}

M.PLUG = 'LightSwitch'  -- plugin name, shall be used for augroup etc
M.DISABLE = 'LightSwitchDisable' -- disable plugin
M.CUR_TOGGLE = 'LightsToggle' -- others in current group; default: switch selected
M.ANY_TOGGLE = 'LightSwitchToggle' -- others in any group; default: switch selected
M.CUR_LIGHT = 'LightsOn' -- light in current group; default: on selected
M.ANY_LIGHT = 'LightSwitchOn' -- light in any group; default: on selected
M.CUR_DARK = 'LightsOff' -- dark in current group; default: off selected
M.ANY_DARK = 'LightSwitchOff' -- dark in any group; default: off selected

---@param themes table<string, Themegroup>
---@return nil
local function validate_themes(themes)
    assert(type(themes) == 'table')
    for name, group in pairs(themes) do
        assert(type(name) == 'string')
        assert(type(group) == 'table')
        assert(type(group.variants) == 'table')
        assert(vim.tbl_islist(group.variants.dark))
        for _, e in ipairs(group.variants.dark) do assert(type(e) == 'string') end
        assert(vim.tbl_islist(group.variants.light))
        for _, e in ipairs(group.variants.light) do assert(type(e) == 'string') end
        assert((#group.variants.light + #group.variants.dark) > 1)
        assert(
            vim.tbl_contains(group.variants.light, name)
            or vim.tbl_contains(group.variants.dark, name)
        )
        assert(type(group.selected) == 'table')
        assert(type(group.selected.dark) == 'string')
        assert(type(group.selected.light) == 'string')
        assert(type(group.custom_switches) == 'table')
        for k, v in pairs(group.custom_switches) do
            assert(type(k) == 'string' and type(v) == 'function')
        end
    end
end

---@param themes table<string, Themegroup>
---@return table<string, Themegroup>
local function normalize_themes(themes)
    for name, group in pairs(themes) do
        if not group.custom_switches then group.custom_switches = {} end
        themes[name] = group
    end
    return themes
end

---@param themes table<string, Themegroup>?
---@return nil
function M.add_themes(themes)
    local new = vim.tbl_extend('error', M.themes, themes or {})
    new = normalize_themes(new)
    validate_themes(new)
    M.themes = new
end

---@param brightness? 'dark'|'light'
---@return string[] # Dark or light versions of all themegroups.
---* for group specific themes use group.variants[brightness] instead
---* for all names use vim.tbl_keys(themes) instead
function M.get_theme_names(brightness)
    assert(brightness == 'dark' or brightness == 'light')
    local rv = {}
    local already_seen = {}
    for _, group in pairs(M.themes) do
        if not already_seen[group] then
            already_seen[group] = true
            vim.list_extend(rv, group.variants[brightness])
        end
    end
    return rv
end

---@param theme string
---@param dual_fallback? 'dark'|'light' Compute the value for dual theme yourself!
---@return 'dark'|'light'|nil # for unknown/dual themes nil if not dual_fallback
---Return given theme's brightness. Is nil for dual and unknown themes, except when a
---fallback value for dual brightness themes is provided (in this case user computed it
---himself however its appropriate), in which case it is returned for dual themes but
---unknown themes will return vim.go.background
function M.get_brightness(theme, dual_fallback)
    if not theme then error('ArgumentError') end
    if dual_fallback then
        assert(dual_fallback == 'dark' or dual_fallback == 'light')
    end
    local shared = require('lightswitch.shared')
    if not shared.themes[theme] then -- is unknown to this plugin theme:
        if dual_fallback then
            -- fallback if requested is always vim.go.bg for unknown themes
            return vim.go.background
        end
        return nil
    end
    local is_dark = false
    if vim.tbl_contains(shared.themes[theme].variants.dark, theme) then
        is_dark = true
    end
    if vim.tbl_contains(shared.themes[theme].variants.light, theme) then
        if is_dark then -- is dual brightness theme:
            if dual_fallback then
                return dual_fallback
            end
            return nil
        else
            return 'light'
        end
    elseif is_dark then
        return 'dark'
    end
    error("ConfigError: theme not member of it's own theme-group")
end

return M

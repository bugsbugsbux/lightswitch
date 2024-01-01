---@alias Themegroup {selected:{dark:string,light:string},variants:{dark:string[],light:string[]},custom_switches:table<string,fun(brightness?:'dark'|'light'):nil>}

local shared = require('lightswitch.shared')
local auto = require('lightswitch.auto')
local cmds = require('lightswitch.cmds')

local M = {
    setstate = function(light_or_dark)
        assert(light_or_dark == 'light' or light_or_dark == 'dark')
        require('lightswitch.shared').state.brightness = light_or_dark
    end,
}

---@param themes? table<string, Themegroup>
function M.setup(themes)
    shared.add_themes(themes)
    auto.activate()
    cmds.setup_user_cmds()
end

function M.disable()
    auto.deactivate()
    cmds.remove_user_cmds()
end

return M

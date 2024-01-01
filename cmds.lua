---@alias Cmd {fargs:string[],bang:boolean,any}

local share = require('lightswitch.shared')
local core = require('lightswitch.core')
local complete = require('lightswitch.complete')

local M = {}

local cmd_names = {
    disable = share.DISABLE,
    cur_toggle = share.CUR_TOGGLE,
    any_toggle = share.ANY_TOGGLE,
    cur_light = share.CUR_LIGHT,
    any_light = share.ANY_LIGHT,
    cur_dark = share.CUR_DARK,
    any_dark = share.ANY_DARK,
}

function M.remove_user_cmds()
    for _, command in pairs(cmd_names) do
        vim.api.nvim_del_user_command(command)
    end
end

function M.setup_user_cmds()
    vim.api.nvim_create_user_command(
        cmd_names.disable,
        function(_)
            require('lightswitch.auto').deactivate()
            require('lightswitch.cmds').remove_user_cmds()
        end,
        { bang = false, bar = true }
    )
    vim.api.nvim_create_user_command(
        cmd_names.cur_toggle,
        ---@param cmd Cmd
        function(cmd)
            core.cur_toggle(cmd.fargs[1])
        end, {
            complete = complete.cur_toggle,
            bang = false, bar = true, nargs = '?',
        }
    )
    vim.api.nvim_create_user_command(
        cmd_names.any_toggle,
        ---@param cmd Cmd
        function(cmd)
            core.any_toggle(cmd.fargs[1])
        end, {
            complete = complete.any_toggle,
            bang = false, bar = true, nargs = '?',
        }
    )
    vim.api.nvim_create_user_command(
        cmd_names.cur_light,
        ---@param cmd Cmd
        function(cmd)
            core.cur_light(cmd.fargs[1])
        end, {
            complete = complete.cur_light,
            bang = false, bar = true, nargs = '?',
        }
    )
    vim.api.nvim_create_user_command(
        cmd_names.any_light,
        ---@param cmd Cmd
        function(cmd)
            core.any_light(cmd.fargs[1])
        end, {
            complete = complete.any_light,
            bang = false, bar = true, nargs = '?',
        }
    )
    vim.api.nvim_create_user_command(
        cmd_names.cur_dark,
        ---@param cmd Cmd
        function(cmd)
            core.cur_dark(cmd.fargs[1])
        end, {
            complete = complete.cur_dark,
            bang = false, bar = true, nargs = '?',
        }
    )
    vim.api.nvim_create_user_command(
        cmd_names.any_dark,
        ---@param cmd Cmd
        function(cmd)
            core.any_dark(cmd.fargs[1])
        end, {
            complete = complete.any_dark,
            bang = false, bar = true, nargs = '?',
        }
    )
end

return M

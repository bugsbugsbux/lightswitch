local M = {
    augroup = vim.api.nvim_create_augroup(
        require('lightswitch.shared').PLUG,
        { clear = true }
    ),
}

function M.activate()
    require('lightswitch.shared').state = {
        theme = vim.g.colors_name or 'default',
        brightness = vim.go.background,
    }

    vim.api.nvim_create_autocmd('ColorSchemePre', {
        group = M.augroup,
        pattern = { '*' },
        desc = "Update brightness state of previous theme if it's an unknown theme",
        callback = function(_)
            local shared = require('lightswitch.shared')
            if not shared.themes[shared.state.theme] then
                shared.state.brightness = vim.go.background
            end
        end,
    })

    vim.api.nvim_create_autocmd('ColorScheme', {
        group = M.augroup,
        pattern = { '*' },
        desc = "Remember prev theme as its brightness' selection and update state",
        callback = function(event)
            local new = event.match
            local shared = require('lightswitch.shared')
            local prev = shared.state.theme
            if shared.themes[prev] then
                shared.themes[prev].selected[shared.state.brightness] = prev
            end
            shared.state = {
                theme = new,
                ---@diagnostic disable-next-line:assign-type-mismatch
                brightness = shared.get_brightness(new, vim.go.background),
            }
        end,
    })
end

function M.deactivate()
    vim.api.nvim_clear_autocmds({group = M.augroup})
end

return M

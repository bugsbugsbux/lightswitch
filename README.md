# LightSwitch

A neovim plugin to easily switch between the light and dark variants of
colorschemes in a unified way.

There is no need to stop using `:colorscheme name` if you know the name
of the colorscheme you want to switch to. LightSwitch is there for you
if you don't remember the name of an appropriate colorscheme of the
other brightness or when you specifically look for a theme with certain
brightness!

Colorschemes need to be registered before they work with this plugin:

```lua
-- First create a themegroup for your colorscheme:
local nightfox_group = {
  variants = {
    light = { 'dayfox', 'dawnfox' },
    dark = { 'nightfox', 'duskfox', 'nordfox', 'terafox', 'carbonfox' },
  },
-- Select the initial variants you want to use:
  selected = { light = 'dayfox', dark = 'nightfox' },
}
-- Then register them with the setup function:
require('lightswitch').setup({
  dayfox = nightfox_group, dawnfox = nightfox_group,
  nightfox = nightfox_group, duskfox = nightfox_group,
  nordfox = nightfox_group, terafox = nightfox_group,
  carbonfox = nightfox_group,
})
```

If the colorscheme is a bit special you can account for that with a
custom switch function:
```lua
-- A theme that uses the same name for light and dark variant or that
-- uses an unusual way of changing between dark and light:
local vscode_group = { -- https://github.com/Mofiqul/vscode.nvim
    variants = { dark = {'vscode'}, light = {'vscode'} },
    selected = { dark = 'vscode', light = 'vscode' },
    custom_switch = {
        -- This is the default behaviour for dual brightness themes and
        -- thus unnecessary to specify:
        --vscode = function(light_or_dark)
        --    vim.cmd('colorscheme vscode')
        --    vim.cmd('set background=' .. light_or_dark)
        --end,

        -- If the theme does not react to changes of 'bg' or for some
        -- reason does not set the correct 'bg' value you need to set
        -- 'bg' and the brightness value known to LightSwitch yourself.
        vscode = function(light_or_dark)
            -- Make sure theme is active
            vim.cmd('colorscheme vscode')
            -- Unusual way of switching:
            require('vscode').load(light_or_dark)
            -- Fix LightSwitch state if necessary
            require('lightswitch').setstate(light_or_dark)
        end,
    },
}
```

```
variant   | of current             | of any
----------|------------------------|--------------------------
light     | `LightsOn name`²       | `LightSwitchOn name`²
dark      | `LightsOff name`²      | `LightSwitchOff name`²
opposite¹ | `LightsToggle name`²   | `LightSwitchToggle name`²

¹ ...of currently active theme's brightness (= `&bg` for unknown themes)
² Missing name defaults to current theme's last used variant (=selected)
```

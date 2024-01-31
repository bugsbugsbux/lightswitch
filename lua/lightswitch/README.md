**USE AT YOUR OWN RISK**

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
local vscode_group = {
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

## Commands

```
variant   | of current             | of any
----------|------------------------|--------------------------
light     | `LightsOn name`²       | `LightSwitchOn name`²
dark      | `LightsOff name`²      | `LightSwitchOff name`²
opposite¹ | `LightsToggle name`²   | `LightSwitchToggle name`²

¹ ...of currently active theme's brightness (= `&bg` for unknown themes)
² Missing name defaults to current theme's last used variant (=selected)
```

## Tips

- To avoid having to add/remove colorscheme names and groups in your
  config every time you un/install a theme, you might want to register
  them conditionally like so:

  ```lua
  -- YOURCONFIG/THEMES.lua
  return {}
  ```

  ```lua
  -- YOURCONFIG/sometheme_config.lua
  -- ...
  local themes = require('YOURCONFIG.THEMES')
  local group = {
      selected = { light = 'name1', dark = 'name2' },
      variants = { light ={'name1'},dark ={'name2'}},
  }
  themes['name1'] = group
  themes['name2'] = group
  ```

  Now, only if the theme's config is loaded, it is added to the table in
  YOURCONFIG/THEMES.lua . Call setup() with this table *after* all
  available themes were added:

  ```lua
  require('lightswitch').setup(require('YOURCONFIG.THEMES'))
  ```

- Lazy loading plugins, or using the conditional registration trick from
  above requires some caution; here exemplified with lazy.nvim :
  ```lua
  require('lazy').setup{
    { 'foo/sometheme',
      config = function() require('YOURCONFIG.sometheme_config') end,
      -- if you conditionally populate the table of themenames/-groups
      -- to register with LightSwitch:
      lazy=false              -- MAKES SURE THE CONFIG RUNS IMMEDIATELY
    },
    { 'herrvonvoid/lightswitch',
      config = function()
        require('lightswitch').setup(require('YOURCONFIG.THEMES'))
      end,
      -- if you did not use hardcoded themenames/-groups above:
      event= 'User LazyDone', -- ENSURES CONFIG RUNS AFTER THEME-CONFIGS
    }
  }
  ```

## Troubleshooting

- **Theme not found error / Shows uninstalled themes**:
  + Did you spell the theme name correctly (check capitalization)?
  + Is the theme really called this way?
  + Did you accidentally register a theme with LightSwitch which is not
    installed? Consider registering themes, as described above, from
    their config (which wont be loaded if the theme is not installed)
    with some table which is imported by the LightSwitch config.

- **Installed themes don't show up**:
  + Did you register them?
  + As the correct brightness?
  + If you conditionally populate the table passed to `setup()`: Were
    all themes added to the table *before* `setup()` was called?
  + Are you using the correct command ("Lights\<On|Off|Toggle>" only
    show themes from the same group)?

- **Does not switch to the correct previous variant**:
  + Were groups and theme names registered correctly?
  + Colorscheme changes before LightSwitch was loaded are not known to
    it; thus it should be loaded as soon as possible (for example with
    lazy.nvim's `event="User LazyDone"`).

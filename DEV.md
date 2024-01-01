* themes need to be registered in setup(themes)
* the themes table maps a colorscheme (theme) name to its themegroup
  (group) which is a table that looks like this:
  ```
  {
    variants = {dark ={'theme1'},light ={'theme1'}},
    selected = {dark = 'theme1', light = 'theme1'},
    custom_switches = {
        theme1 = function(brightness)
            assert(brightness == 'dark' or brightness == 'light')
            vim.cmd('colorscheme theme1')
            vim.cmd('set bg='..brightness)
        end
    }
  }
  ```
* event ColorSchemePre saves the latest 'bg' for unknown themes
* event ColorScheme selects the previous theme in its group as its
  brightness and saves new theme name and 'bg' in shared.state
* themes' brightness is determined by whether they are stored in 'dark'
  or 'light' in their group, except dual brightness and unknown themes
  whose brightness is determined by the brightness in shared.state which
  may be set after setting the colorscheme in a custom_switch

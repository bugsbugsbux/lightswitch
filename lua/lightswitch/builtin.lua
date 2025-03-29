---@type Themegroup
local default = {
    selected = { dark = 'default', light = 'default' },
    variants = { dark = {'default'}, light = {'default'} },
}

---@type Themegroup
local lunaperche = {
    selected = { dark = 'lunaperche', light = 'lunaperche' },
    variants = { dark = {'lunaperche'}, light = {'lunaperche'} },
}

---@type Themegroup
local quiet = {
    selected = { dark = 'quiet', light = 'quiet' },
    variants = { dark = {'quiet'}, light = {'quiet'} },
}

---@type Themegroup
local builtin = {
    selected = { dark = 'industry', light = 'peachpuff' },
    variants = {
        dark = {
            'blue',
            'darkblue',
            'desert',
            'elflord',
            'evening',
            'habamax',
            'industry',
            'koehler',
            'murphy',
            'pablo',
            'ron',
            'slate',
            'torte',
        },
        light = {
            'delek',
            'morning',
            'peachpuff',
            'shine',
            'zellner',
        },
    },
}

return {
    default = default,
    lunaperche = lunaperche,
    quiet = quiet,
    ---
    blue = builtin,
    darkblue = builtin,
    delek = builtin,
    desert = builtin,
    elflord = builtin,
    evening = builtin,
    habamax = builtin,
    industry = builtin,
    koehler = builtin,
    morning = builtin,
    murphy = builtin,
    pablo = builtin,
    peachpuff = builtin,
    ron = builtin,
    shine = builtin,
    slate = builtin,
    torte = builtin,
    zellner = builtin,
}

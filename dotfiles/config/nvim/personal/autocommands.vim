augroup DiffBindings
    autocmd!
    autocmd OptionSet diff call DiffMappings(v:option_old, v:option_new)
augroup END

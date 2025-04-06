setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldlevel=1
setlocal shiftwidth=2

match none
if !&diff && (&t_Co > 2 || has("gui_running"))  "Match characters past column
    match LineTooLong /\%>159v.\+/              "159 to mark as red.
endif

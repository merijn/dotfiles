setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldlevel=1
setlocal textwidth=119
setlocal shiftwidth=2

match none
if !&diff && (&t_Co > 2 || has("gui_running"))  "Match characters past column
    match LineTooLong /\%>120v.\+/              "159 to mark as red.
endif

vnoremap <Leader>% :Tabularize /=<CR>:Tabularize /%%\?<CR>
nnoremap <Leader>% :Tabularize /=<CR>:Tabularize /%%\?<CR>

vnoremap <Leader>< :Tabularize /<-<CR>
nnoremap <Leader>< :Tabularize /<-<CR>

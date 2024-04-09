let b:ale_linters = []

setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal foldlevel=1

match none
if !&diff && (&t_Co > 2 || has("gui_running"))  "Match characters past column
    match LineTooLong /\%>159v.\+/              "159 to mark as red.
endif

vnoremap <Leader>% :Tabularize /=<CR>:Tabularize /%%\?<CR>
nnoremap <Leader>% :Tabularize /=<CR>:Tabularize /%%\?<CR>

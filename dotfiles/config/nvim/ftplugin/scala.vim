setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldlevel=1
setlocal textwidth=119
setlocal shiftwidth=2

let b:ale_linters = []

match none
if !&diff && (&t_Co > 2 || has("gui_running"))  "Match characters past column
    match LineTooLong /\%>120v.\+/              "159 to mark as red.
endif

vnoremap <buffer> <Leader>% :Tabularize /=<CR>:Tabularize /%%\?<CR>
nnoremap <buffer> <Leader>% :Tabularize /=<CR>:Tabularize /%%\?<CR>

vnoremap <buffer> <Leader>< :Tabularize /<-<CR>
nnoremap <buffer> <Leader>< :Tabularize /<-<CR>

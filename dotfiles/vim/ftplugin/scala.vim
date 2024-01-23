let b:ale_linters = []
let g:ale_scala_metals_executable = 'metals'

setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal foldlevel=1

match none
vnoremap <Leader>% :Tabularize /=<CR>:Tabularize /%%\?<CR>
nnoremap <Leader>% :Tabularize /=<CR>:Tabularize /%%\?<CR>

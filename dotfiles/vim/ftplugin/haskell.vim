let b:ale_linters = ['ghcide']

call ale#linter#Define('haskell', {
    \   'name': 'ghcide',
    \   'lsp': 'stdio',
    \   'executable': {b -> ale#Var(b, 'haskell_ghcide_executable')},
    \   'command': '%e --lsp',
    \   'project_root': function('ale_linters#haskell#ghcide#GetProjectRoot'),
    \})

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

"vmap a; :Tabularize /::<CR>
vnoremap <Leader>- :Tabularize /-><CR>
nnoremap <Leader>- :Tabularize /-><CR>

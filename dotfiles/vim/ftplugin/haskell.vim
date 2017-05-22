" HdevTools options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:hdevtools_options = "-g-fdefer-typed-holes -g-fno-code -g-O0 -g-fno-warn-typed-holes"
let g:hdevtools_options = s:hdevtools_options
let g:syntastic_haskell_hdevtools_args = s:hdevtools_options
let g:syntastic_haskell_checkers = ['hdevtools']

let b:syntastic_haskell_hdevtools_args =
    \ get(g:, 'syntastic_haskell_hdevtools_args', '') . " " .
    \ join(FindSyntasticConfig('.syntastic_hdevtools_config',
    \                          expand('<afile>:p:h', 1)))

nnoremap <silent> <Tab> :HdevtoolsType<return>

function! ToggleType()
    if exists(":HdevtoolsClear")
        :HdevtoolsClear
    endif
endfunction

nnoremap <silent> <buffer> <return> :noh<return>:call ToggleType()<return>
nnoremap <silent> <buffer> <C-]> :HdevtoolsInfo<return>

" Enable neco-ghc omnicompleteion
set omnifunc=necoghc#omnifunc

" Insert ghc-mod inferred type signature
noremap <silent> <Leader>i :GhcModTypeInsert<CR>
" Insert ghc-mod computed function case
noremap <silent> <Leader>s :GhcModSplitFunCase<CR>

"vmap a; :Tabularize /::<CR>
vnoremap <Leader>= :Tabularize /=<CR>
nnoremap <Leader>= :Tabularize /=<CR>
vnoremap <Leader>- :Tabularize /-><CR>
nnoremap <Leader>- :Tabularize /-><CR>

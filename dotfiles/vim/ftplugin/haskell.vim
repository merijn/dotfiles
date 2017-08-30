let g:neomake_haskell_enabled_makers = ['ghcmod']
let g:neomake_haskell_ghcmod_args = [ '-g-fdefer-typed-holes', '-g-fno-code',
    \'-g-O0', '-g-fno-warn-typed-holes']
    \+ neomake#makers#ft#haskell#ghcmod().args

nnoremap <silent> <Tab> :GhcModType<return>

function! ToggleType()
    if exists(":GhcModTypeClear")
        :GhcModTypeClear
    endif
endfunction

nnoremap <silent> <buffer> <return> :noh<return>:call ToggleType()<return>

" Enable neco-ghc omnicompletion
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

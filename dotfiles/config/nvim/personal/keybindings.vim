let mapleader = "\<C-g>"        "Map leader key
"Y behaves as D and C rather than yy
noremap Y y$

"Make Ctrl-A a noop so it doesn't conflict with tmux mapping and clobber
"numbers all over
noremap <silent> <C-A> <Nop>

if has('nvim')
    nnoremap <silent> <tab> :lua vim.lsp.buf.hover()<return>
    nnoremap <silent> <Leader>c :lua vim.lsp.buf.code_action()<return>
    nnoremap <silent> <Leader>g :lua vim.lsp.buf.definition()<return>
    nnoremap <silent> <Leader>f :lua vim.lsp.buf.references()<return>
    nnoremap <silent> <Leader>i :lua vim.lsp.buf.implementation()<return>
    nnoremap <silent> <Leader>x :lua vim.lsp.codelens.run()<return>
    nnoremap <silent> <Leader>s :MetalsSuperMethodHierarchy<return>
endif

nnoremap <silent> <C-j> :call GetNextError(1)<CR>
nnoremap <silent> <C-k> :call GetNextError(0)<CR>
nnoremap <silent> \ :call ToggleErrorList()<return>
nnoremap <silent> <C-\> :call ToggleQuickFix()<return>

nnoremap <silent> <Leader>t :CtrlPMixed<return>
nnoremap <silent> <F1> :GundoToggle<CR>
nnoremap <silent> <F2> :TagbarToggle<CR>

" Tabularize options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap <Leader>= :Tabularize /=<CR>
nnoremap <Leader>= :Tabularize /=<CR>

" qbuf options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:qb_hotkey = "<Leader>o"

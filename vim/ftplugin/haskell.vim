" HdevTools options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:hdevtools_options = "-g-Wall -g-fno-warn-unused-do-bind -g-fdefer-type-errors -g-fno-code -g-O0"
let g:hdevtools_options = s:hdevtools_options
let g:syntastic_haskell_hdevtools_args = s:hdevtools_options + "-fno-warn-typed-holes"

nnoremap <silent> <Tab> :HdevtoolsType<return>

function! ToggleType()
    if exists(":HdevtoolsClear")
        :HdevtoolsClear
    endif
endfunction

nnoremap <silent> <buffer> <return> :noh<return>:call ToggleType()<return>
nnoremap <silent> <buffer> <C-]> :HdevtoolsInfo<return>

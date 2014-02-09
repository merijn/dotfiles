" HdevTools options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:hdevtools_options = "-g-Wall -g-XConstraintKinds -g-XCPP -g-XFlexibleContexts -g-fno-warn-unused-do-bind -g-ishared -g-isrc -g-fdefer-type-errors -g-idist/build/autogen -g-optP-include -g-optPdist/build/autogen/cabal_macros.h"
nnoremap <silent> <Tab> :HdevtoolsType<return>

function! ToggleType()
    if exists(":HdevtoolsClear")
        :HdevtoolsClear
    endif
endfunction

nnoremap <silent> <return> :noh<return>:call ToggleType()<return>
nnoremap <silent> <C-]> :HdevtoolsInfo<return>

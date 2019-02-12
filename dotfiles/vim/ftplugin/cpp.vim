let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
    \ 'exe': 'clang++',
    \ 'args': [ "-stdlib=libc++"
            \ , "-std=c++17"
            \ , "-pedantic"
            \ , "-fsyntax-only"
            \ , "-Weverything"
            \ , "-Wno-padded"
            \ , "-Wno-c++98-compat"
            \ , "-Wno-c++98-compat-pedantic"
            \ , "-I$HOME/opt/include/"
            \ , "-isystem$HOME/opt/include/"
            \]
            \+ FindLocalConfig('.neomake_cpp_config', expand('<afile>:p:h', 1))
            \,}

setlocal cino=L0.5s,:0.5s,=0.5s,l1,g0.5s,h0.5s,N-s,t0,i-0.5s,+0
setlocal indentkeys+=0<:>,0=#pragma

function! GetCppIndent(lineno)
    let baseIndent = cindent(a:lineno)
    let line = getline(a:lineno)

    if l:line =~ '^\s*:'
        return l:baseIndent + &shiftwidth/2
    elseif l:line =~ '^\s*#pragma'
        return cindent(a:lineno + 1)
    elseif l:line =~ '^\s*,'
        return GetCppIndent(a:lineno - 1)
    endif

    return l:baseIndent
endfunction

setlocal indentexpr=GetCppIndent(v:lnum)

if expand('%:e') =~ 'h\(pp\)\?'
    let g:neomake_cpp_clang_maker.args =
        \ g:neomake_cpp_clang_maker['args'] + [ "-Wno-unused-macros" ]
endif

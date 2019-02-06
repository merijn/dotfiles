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

setlocal cino=L-0.5s,:0.5s,=0.5s,l1,g0.5s,h0.5s,+0,i-0.5s
setlocal indentkeys+=0<:>

function! GetCppIndent(lineno)
    let baseIndent = cindent(a:lineno)

    if getline(a:lineno) !~ '^\s*:'
        return l:baseIndent
    endif

    return l:baseIndent + &shiftwidth/2
endfunction

setlocal indentexpr=GetCppIndent(v:lnum)

if expand('%:e') =~ 'h\(pp\)\?'
    let g:neomake_cpp_clang_maker.args =
        \ g:neomake_cpp_clang_maker['args'] + [ "-Wno-unused-macros" ]
endif

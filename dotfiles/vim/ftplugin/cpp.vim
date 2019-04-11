let g:neomake_cpp_enabled_makers = ['gcc']

let s:base_cpp_flags =
    \ [ "-std=c++14"
    \ , "-pedantic"
    \ , "-fsyntax-only"
    \ , "-Wno-padded"
    \ , "-I$HOME/opt/include/"
    \ , "-isystem$HOME/opt/include/"
    \] + FindLocalConfig('.neomake_cpp_config', expand('<afile>:p:h', 1))

let g:neomake_cpp_clang_maker = {
    \ 'exe': 'clang++',
    \ 'args': 
        \ [ "-stdlib=libc++"
        \ , "-Weverything"
        \ , "-Wno-c++98-compat"
        \ , "-Wno-c++98-compat-pedantic"
        \ ] + s:base_cpp_flags
    \,}

let g:neomake_cpp_gcc_maker = {
    \ 'exe': 'g++',
    \ 'args': s:base_cpp_flags
    \,}

if expand('%:e') =~ 'h\(pp\)\?'
    let g:neomake_cpp_clang_maker.args =
        \ g:neomake_cpp_clang_maker['args'] + [ "-Wno-unused-macros" ]

    let g:neomake_cpp_gcc_maker.args =
        \ g:neomake_cpp_gcc_maker['args'] + [ "-Wno-unused-macros" ]
endif

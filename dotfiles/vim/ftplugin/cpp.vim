let b:neomake_cpp_enabled_makers = ['gcc']

let b:base_cpp_flags =
    \ [ "-std=c++14"
    \ , "-pedantic"
    \ , "-fsyntax-only"
    \ , "-Wno-padded"
    \ , "-I$HOME/opt/include/"
    \ , "-isystem$HOME/opt/include/"
    \] + FindLocalConfig('.neomake_cpp_config', expand('<afile>:p:h', 1))

let b:neomake_cpp_clang_maker = {
    \ 'exe': 'clang++',
    \ 'args': 
        \ [ "-stdlib=libc++"
        \ , "-Weverything"
        \ , "-Wno-c++98-compat"
        \ , "-Wno-c++98-compat-pedantic"
        \ ] + b:base_cpp_flags
    \,}

let b:neomake_cpp_gcc_maker = {
    \ 'exe': 'g++',
    \ 'args': b:base_cpp_flags
    \,}

if expand('%:e') =~ 'h\(pp\)\?'
    let b:neomake_cpp_clang_maker.args =
        \ b:neomake_cpp_clang_maker['args'] + [ "-Wno-unused-macros" ]

    let b:neomake_cpp_gcc_maker.args =
        \ g:neomake_cpp_gcc_maker['args'] + [ "-Wno-unused-macros" ]
endif

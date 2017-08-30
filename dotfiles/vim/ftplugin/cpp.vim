let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_args =
    \ [ "-std=c++14"
    \ , "-pedantic"
    \ , "-fsyntax-only"
    \ , "-Weverything"
    \ , "-Wno-padded"
    \ , "-Wno-c++98-compat"
    \ , "-Wno-c++98-compat-pedantic"
    \ , "-I$HOME/opt/include/"
    \ , "-isystem$HOME/opt/include/" ]
    \+ FindLocalConfig('.neomake_cpp_config', expand('<afile>:p:h', 1))

if expand('%:e') =~ 'h\(pp\)\?'
    let g:neomake_cpp_clang_args = [ "-Wno-unused-macros" ] + g:neomake_cpp_clang_args
endif

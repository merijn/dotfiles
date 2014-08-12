let g:syntastic_cpp_compiler = "clang++"
let g:syntastic_cpp_compiler_options = "
    \ -Werror -Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic
    \ -Wno-global-constructors -Wno-exit-time-destructors
    \ -Wno-documentation-deprecated-sync -Wno-documentation -Wno-padded
    \ -Wno-gnu-anonymous-struct -Wno-nested-anon-types -Wno-float-equal"

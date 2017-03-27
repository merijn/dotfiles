let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_compiler = "clang++"
let g:syntastic_cpp_compiler_options = "-std=c++14 -pedantic -Weverything
    \ -Wno-padded -Wno-c++98-compat -Wno-c++98-compat-pedantic
    \ -I$HOME/opt/include/ -isystem$HOME/opt/include/"

" Replace TeX math notation with unicode in every mode except insert.
set conceallevel=2
set concealcursor=nvc
let g:tex_conceal="adgms"

"let b:ip_boundary = '\\begin{enumerate}'

fun! TeX_fmt()
    if (getline(".") != "")
    let save_cursor = getpos(".")
        let op_wrapscan = &wrapscan
        set nowrapscan
        let par_begin = '^\(%D\)\=\s*\($\|\\label\|\\begin\|\\end\|\\[\|\\]\|\\\(sub\)*section\>\|\\noindent\>\)'
        let par_end   = '^\(%D\)\=\s*\($\|\\label\|\\begin\|\\end\|\\[\|\\]\|\\\(sub\)*section\>\|\\noindent\>\)'
    try
      exe '?'.par_begin.'?+'
    catch /E384/
      1
    endtry
        norm V
    try
      exe '/'.par_end.'/-'
    catch /E385/
      $
    endtry
    norm gq
        let &wrapscan = op_wrapscan
    call setpos('.', save_cursor) 
    endif
endfun

nnoremap gq :call TeX_fmt()<CR>

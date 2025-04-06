" Replace TeX math notation with unicode in every mode except insert.
let g:tex_conceal=""
let g:tex_flavor='latex'
let b:ale_linters = ['chktex']
let g:vimtex_mappings_enabled = 0
let g:vimtex_imaps_enabled = 0
let g:vimtex_compiler_latexmk = {}
let g:vimtex_compiler_latexmk['options'] = ['-xelatex']

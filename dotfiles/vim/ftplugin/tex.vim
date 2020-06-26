" Replace TeX math notation with unicode in every mode except insert.
set conceallevel=2
set concealcursor=nvc
let g:tex_conceal="adgms"
let b:ale_linters = ['chktex']
let g:vimtex_mappings_enabled = 0
let g:vimtex_imaps_enabled = 0
let g:vimtex_compiler_latexmk = {}
let g:vimtex_compiler_latexmk['options'] = ['-xelatex']

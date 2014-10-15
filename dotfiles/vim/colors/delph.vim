" Clear existing highlights, set background dark and set the color scheme name
hi clear
set background=dark
let g:colors_name = "delph"

" Reset syntax highlighting colors
if exists("syntax_on")
  syntax reset
endif

hi Comment     ctermfg=Blue
hi Constant    ctermfg=DarkRed
hi LineTooLong ctermfg=Black        ctermbg=DarkRed
hi MoreMsg     ctermfg=DarkGreen
hi Normal      ctermfg=LightGrey
hi PreProc     ctermfg=DarkMagenta
hi Question    ctermfg=DarkGreen
hi Search      ctermfg=None         ctermbg=Black   cterm=reverse
hi Special     ctermfg=DarkYellow
hi SpecialKey  ctermfg=DarkRed
hi StatusLine  ctermfg=Blue         ctermbg=White
hi Statement   ctermfg=DarkYellow
hi Type        ctermfg=DarkGreen

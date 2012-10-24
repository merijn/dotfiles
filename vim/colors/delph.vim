" Clear existing highlights, set background dark and set the color scheme name
hi clear
set background=dark
let g:colors_name = "delph"

" Reset syntax highlighting colors
if exists("syntax_on")
  syntax reset
endif

" GUI
hi Comment     guifg=#5555FF
hi Constant    guifg=#BB0000
hi Cursor      guifg=Black        guibg=Green
hi LineTooLong guifg=Black        guibg=#BB0000
hi Normal      guifg=Grey         guibg=Black
hi PreProc     guifg=#BB55BB
hi Question    guifg=DarkGreen
hi Search                         guibg=Black    gui=Inverse
hi Special     guifg=#BBBB00
hi SpecialKey  guifg=#BB0000
hi StatusLine  guifg=Blue         guibg=White
hi Statement   guifg=DarkYellow                   gui=None
hi Type        guifg=#00BB00                      gui=None
hi Visual                         guibg=Black     gui=Inverse

" Console
hi Comment     ctermfg=Blue
hi Constant    ctermfg=DarkRed
hi LineTooLong ctermfg=Black      ctermbg=DarkRed
hi MoreMsg     ctermfg=DarkGreen
hi Normal      ctermfg=LightGrey
hi PreProc     ctermfg=DarkMagenta
hi Question    ctermfg=DarkGreen
hi Search      ctermfg=None       ctermbg=Black   cterm=reverse
hi Special     ctermfg=DarkYellow
hi SpecialKey  ctermfg=DarkRed
hi StatusLine  ctermfg=Blue       ctermbg=White
hi Statement   ctermfg=DarkYellow
hi Type        ctermfg=DarkGreen

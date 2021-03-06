" Vim indent file
" Language:	C++ (like)
" Maintainer:	Merijn Verstraaten <merijn@inconsistent.nl
" Last Change:	2019 Feb 14

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

setlocal cino=L0.5s,:0.5s,=0.5s,l1,g0.5s,h0.5s,N-s,E-s,p0,t0,i-0.5s,+0
setlocal indentkeys+=0<:>,0=#pragma

setlocal indentexpr=dotfiles#GetCppIndent(v:lnum)

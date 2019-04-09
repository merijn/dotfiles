" Vim indent file
" Language:	C++ (like)
" Maintainer:	Merijn Verstraaten <merijn@inconsistent.nl
" Last Change:	2019 Feb 14

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

setlocal cino=L0.5s,:0.5s,=0.5s,l1,g0.5s,h0.5s,N-s,t0,i-0.5s,+0
setlocal indentkeys+=0<:>,0=#pragma

function! GetCppIndent(lineno)
    let baseIndent = cindent(a:lineno)
    let line = getline(a:lineno)

    if l:line =~ '^\s*:'
        return l:baseIndent + &shiftwidth/2
    elseif l:line =~ '^\s*#pragma'
        return cindent(a:lineno + 1)
    elseif l:line =~ '^\s*,'
        return GetCppIndent(a:lineno - 1)
    elseif l:line =~ '^\s*{' && (l:baseIndent % &shiftwidth == &shiftwidth/2)
        return l:baseIndent - &shiftwidth/2
    endif

    let prevLine = getline(a:lineno - 1)
    if prevLine =~ ' = \?' || prevLine =~ ' << '
        return l:baseIndent + &shiftwidth
    endif

    return l:baseIndent
endfunction

setlocal indentexpr=GetCppIndent(v:lnum)

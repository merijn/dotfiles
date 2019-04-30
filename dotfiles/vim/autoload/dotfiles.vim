function dotfiles#GetCppIndent(lineno)
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
    if prevLine !~ ';$' && (prevLine =~ ' = [^;]*$' || prevLine =~ ' << ')
        return l:baseIndent + &shiftwidth
    endif

    return l:baseIndent
endfunction

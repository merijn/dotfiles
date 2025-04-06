function! personal#vim_only#GetNextError(next)
    " If there's no error, do nothing
    if len(getloclist(0)) == 0
    " If there's one error, jump to it
    else
        if len(getloclist(0)) == 1
            ll
        " If we're going forward
        elseif a:next
            " Try to go to the next error
            try
                lnext
            " On error rewind to the start (wrap-around)
            catch
                lrewind
            endtry
        else
            " Try to go to the previous error
            try
                lprev
            " On error jump to the last error (wrap-around)
            catch
                llast
            endtry
        endif
        silent! foldopen!
    endif
endfunction

function! personal#diff#SetDiffMapping(key, binding) abort
    let l:existing = maparg(a:key, 'n', 0, 1)
    if !exists("b:diffmap")
        let b:diffmap = {}
    endif

    if !empty(l:existing)
        let b:diffmap[a:key] = l:existing
    else
        let b:diffmap[a:key] = v:null
    endif
    execute printf('nnoremap <buffer> %s %s', a:key, a:binding)
endfunction

function! personal#diff#RestoreDiffMappings() abort
    for key in keys(b:diffmap)
        let l:mi = remove(b:diffmap, key)

        if l:mi is v:null
            " No old mapping, just clear
            execute printf('silent! nunmap <buffer> %s', key)
        else
            " Reconstruct old mapping
            let opts = (l:mi.noremap ? 'nore' : '') . 'map'
            if l:mi.buffer
            let opts .= ' <buffer>'
            endif
            if l:mi.silent
            let opts .= ' <silent>'
            endif
            if l:mi.expr
            let opts .= ' <expr>'
            endif
            if l:mi.nowait
            let opts .= ' <nowait>'
            endif
            execute printf('%s %s %s', opts, l:mi.lhs, l:mi.rhs)
        endif
    endfor
endfunction

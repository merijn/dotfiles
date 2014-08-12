nnoremap <buffer> <silent> <Leader>j :CoqNext<CR>
nnoremap <buffer> <silent> <Leader>k :CoqUndo<CR>
nnoremap <buffer> <silent> <Leader>l :CoqToCursor<CR>
nnoremap <buffer> <silent> <Leader>h :CoqKill<CR>
nnoremap <buffer> <Leader>g :Coq 
inoremap <buffer> <silent> . .<ESC>:CoqToCursor<CR>a
inoremap <buffer> <silent> ; ;<ESC>:CoqToCursor<CR>a

" Follow link with enter
nmap <buffer> <CR> <C-]>

" Go to previous page with backspace
nmap <buffer> <BS> <C-T>


" o/O for go to next option link
" s/S for go to next subject link
nmap <buffer> o /''[a-z]\{2,\}''<CR>
nmap <buffer> O ?''[a-z]\{2,\}''<CR>
nmap <buffer> s /\|\S\+\|<CR>
nmap <buffer> S ?\|\S\+\|<CR>


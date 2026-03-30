function! Maki() abort
    let cur_line = line('.')
    let cur_col = col('.') - 1

    for i in range(cur_line, line('$'))
        let line_str = getline(i)
        let start = (i == cur_line) ? cur_col : 0
        for j in range(start, strlen(line_str) - 1)
            let char = line_str[j]
            if index(['[', ']', '(', ')', '{', '}'], char) >= 0
                call cursor(i, j + 1)
                execute "normal! ci" . char
                return
            endif
        endfor
    endfor
endfunction
nnoremap <silent> <leader><leader> :call Maki()<CR>i


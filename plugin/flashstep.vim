function! FlashStep() abort
  let best_pos  = [0, 0]
  let best_char = ''
  let cur_line  = line('.')
  let cur_col   = col('.')

  " Bracket pairs — searchpairpos works correctly for these
  for [o, c] in [['(', ')'], ['[', ']'], ['{', '}']]
    let pos = searchpairpos('\V' . o, '', '\V' . c, 'bnW')
    if s:IsTighter(pos, best_pos)
      let best_pos  = pos
      let best_char = o
    endif
  endfor

  " Quote pairs — odd count before cursor means we're inside one
  let before = strpart(getline(cur_line), 0, cur_col - 1)
  for q in ['"', "'", '`']
    let n = len(substitute(before, '[^' . q . ']', '', 'g'))
    if n % 2 == 1
      let pos = [cur_line, strridx(before, q) + 1]
      if s:IsTighter(pos, best_pos)
        let best_pos  = pos
        let best_char = q
      endif
    endif
  endfor

  if best_char ==# ''
    echo "No surrounding pair found."
    return
  endif

  " Jump to the opener, then delete inside
  call cursor(best_pos[0], best_pos[1])
  execute 'normal! di' . best_char
endfunction

function! s:IsTighter(new, current) abort
  if a:new[0] == 0 | return 0 | endif
  if a:current[0] == 0 | return 1 | endif
  return a:new[0] > a:current[0]
    \ || (a:new[0] == a:current[0] && a:new[1] > a:current[1])
endfunction

nnoremap <silent> <leader><leader> :call FlashStep()<CR>i

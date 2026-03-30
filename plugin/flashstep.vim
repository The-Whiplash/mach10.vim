nnoremap J :m .+1<CR>==
nnoremap K :m .-2<CR>==
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

nnoremap H <<
nnoremap L >>

xnoremap H :<C-u>call FlashStep('l')<CR>gv
xnoremap L :<C-u>call FlashStep('r')<CR>gv

function! FlashStep(dir) abort
	let l1 = line("'<")
	let l2 = line("'>")
	if l1 != l2
		call FlashStepMultiple(a:dir)
	else
		call FlashStepHelper(l1, a:dir)
	endif
	normal! gv
endfunction

function! FlashStepMultiple(dir) abort
	let l1 = line("'<")
	let l2 = line("'>")
	if a:dir == 'l'
		execute l1 . ',' . l2 . '<'
	elseif a:dir == 'r'
		execute l1 . ',' . l2 . '>'
	endif
endfunction

function! FlashStepHelper(lnum, dir) abort
	let line = getline(a:lnum)
	let c1 = col("'<") - 1
	let c2 = col("'>") - 1

	if a:dir == 'r'
		if c2 + 1 >= strlen(line)
			return
		endif
		let before = c1 > 0 ? line[:c1-1] : ''
		let selected = line[c1:c2]
		let next_char = line[c2+1]
		let after = line[c2+2:]
		call setline(a:lnum, before . next_char . selected . after)
		call setpos("'<", [0, a:lnum, c1 + 2, 0])
		call setpos("'>", [0, a:lnum, c2 + 2, 0])
	elseif a:dir == 'l'
		if c1 <= 0
			return
		endif
		let before = c1 > 1 ? line[:c1-2] : ''
		let prev_char = line[c1-1]
		let selected = line[c1:c2]
		let after = line[c2+1:]
		call setline(a:lnum, before . selected . prev_char . after)
		call setpos("'<", [0, a:lnum, c1, 0])
		call setpos("'>", [0, a:lnum, c2, 0])
	endif
endfunction

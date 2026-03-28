" Leader key
let mapleader = " "

" Start scrolling when you're x lines away from the top and bottom
set so=4

" Backspace allowed for line breaks, text that existed before you entered insert mode, and auto indentation
set backspace=eol,start,indent

" Delays screen redraws during macros and scripts, making them run faster
set lazyredraw

" Briefly jumps the cursor to the matching bracket when you type a closing bracket
set showmatch
" for x tenths of a second
set mat=1

" short for timeoutlen-gives you x ms to complete a key mapping sequence
set tm=500

" Forces new NFA regex engine, which is faster for syntax highlighting in most cases
set regexpengine=2

" If you're in a file bigger than 2 MB or more than 5000 lines, locally disable syntax highlighting, remove cursor line, and disable lazyredraw. Set bufferwide variable to 1 so other plugins know
augroup BigFileMode
  autocmd!
  autocmd BufReadPre * if getfsize(expand('%')) > 2*1024*1024 || line('$') > 5000
        \ | setlocal syn=off nocursorline nolazyredraw
        \ | let b:bigfile=1
        \ | endif
augroup END

" Going to the end of the line is now ; instead of $, pressing 0 brings you to the beginning of the first character in the line instead of beginning of the line
noremap ; $
map 0 ^

" If you do vim ./x/y/z, and then do leader cd, your working directory becomes that directory
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" Better movement.
nnoremap J :m .+1<CR>==
nnoremap K :m .-2<CR>==
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

nnoremap H <<
nnoremap L >>

xnoremap H :<C-u>call VisualNudge('l')<CR>
xnoremap L :<C-u>call VisualNudge('r')<CR>

function! VisualNudge(dir) abort
  let l1 = line("'<")
  let l2 = line("'>")
  if l1 != l2
    execute "normal! gv" . (a:dir == 'l' ? '<' : '>')
    normal! gv
    return
  endif
  let s = getline(l1)
  let c1 = col("'<")
  let c2 = col("'>")
  if c1 > c2
    let [c1, c2] = [c2, c1]
  endif
  let line_len = strlen(s)
  if a:dir == 'l' && c1 <= 1 || a:dir == 'r' && c2 >= line_len
    normal! gv
    return
  endif
  let before = strpart(s, 0, c1 - 1)
  let sel    = strpart(s, c1 - 1, c2 - c1 + 1)
  let after  = strpart(s, c2)
  if a:dir == 'l'
    let swap = strpart(before, -1)
    call setline(l1, strpart(before, 0, strlen(before) - 1) . sel . swap . after)
  else
    let swap = strpart(after, 0, 1)
    call setline(l1, before . swap . sel . strpart(after, 1))
  endif
  let offset = a:dir == 'l' ? -1 : 1
  call setpos("'<", [0, l1, c1 + offset, 0])
  call setpos("'>", [0, l1, c2 + offset, 0])
  normal! gv
endfunction

" Set clipboard to system clipboard
if has('clipboard')
	set clipboard^=unnamed,unnamedplus
endif

" Save with leader wf, save all with leader wa, save everything and quit with qs, force quit with qf.
nnoremap <leader>wf :w<cr>
nnoremap <leader>wa :wa<cr>
nnoremap <leader>qs :wqa<cr>
nnoremap <leader>qf :q!<cr>

" Sudo save with fwf
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
nnoremap <leader>fwf :W<cr>

" Q is now macro recording. Regular q does nothing
nnoremap Q q
nnoremap q <Nop>

let g:user_emmet_install_global = 0
autocmd FileType html,css,jsx,tsx,vue,svelte,astro,php,blade,eruby EmmetInstall
let g:user_emmet_leader_key = ','

" Tab: SnipMate expand/jump (auto-pairs and emmet handle the rest)
imap <expr> <Tab> "\<Plug>snipMateNextOrTrigger"
smap <expr> <Tab> "\<Plug>snipMateNextOrTrigger"

" ── Scrolling ───────────────────────────────────────────────
nnoremap 2 5<C-e>
nnoremap 9 5<C-y>
xnoremap 2 5<C-e>
xnoremap 9 5<C-y>

" ── Delete/wipe helpers ─────────────────────────────────────
xnoremap <silent> <leader>dd "_d
nnoremap <silent> <leader>wipe :silent! %delete _<CR>


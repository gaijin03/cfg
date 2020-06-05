execute pathogen#infect()

"Auto-detect filetype.
filetype plugin indent on

"Highlighted serach - highlights
set hlsearch

" The leader defaults to backslash, so (by default) this
" maps \* and \g* (see :help Leader).
" These work like * and g*, but do not move the cursor and always set hls.
" https://superuser.com/a/255120
"map <Leader>* :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>
"map <Leader>g* :let @/ = expand('<cword>')\|set hlsearch<C-M>

noremap * :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>
noremap g* :let @/ = expand('<cword>')\|set hlsearch<C-M>

"Syntax highlighting - figures out highliging when opening files like with .c
syntax on

color darkblue
"color desert
"if (&diff)
"    color desert
"else
"    "My favorite color scheme
"    color darkblue
"endif


"Change spelling colors
"hi clear SpellBad
"hi SpellBad cterm=undercurl,bold
"hi SpellBad ctermfg=red

"Really write out whether I have permissions
cmap w!! !sudo tee %

"Highlight and find search as you type
set incsearch

"Case insensitive
set ic

"Turn off ci when searching with captial letters
set smartcase

"Wrap lines
set wrap

"Allows you to open multiple buffers without having to write.
"It also keeps your changes history so you can undo in the buffer.
set hidden

"Use the mouse
set mouse=a

"Keep indenting of previous lines
set autoindent

"Show '\' when the line wraps
set showbreak=\

"Line numbers
set number

"Show the line and column numbers of current position.
set ruler

"Briefly jump to matching bracket when inserted
set showmatch

"Puts you in paste mode
set pastetoggle=<F10>

"When opening and switching buffers tab to those opened already.
set switchbuf=useopen

"Show highlighted counts
set showcmd

"Show status line always (2=always 1=only if two windows)
set laststatus=2

" When opening a new vertical split, open it on the right.
set splitright

" When opening a new horizontal split, open it on the bottom.
set splitbelow

" no two spaces after period with using gq
set nojoinspaces

"Highlight white space at the end of the line.
"http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=yellow guibg=yellow
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

let g:ws_on = 0
function! ShowWhiteSpace()
  if g:ws_on
    let g:ws_on = 0
    call clearmatches()
  else
    let g:ws_on = 1
    match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+\|^\t*\zs \+/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+\|^\t*\zs \+/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+\|^\t*\zs \+/
    autocmd BufWinLeave * call clearmatches()
  endif
endfunction

map <silent> <F3> :echo ShowWhiteSpace()<CR>

" 50/72 rule -- 72/72 rule
autocmd Filetype gitcommit setlocal tw=72
autocmd Filetype gitcommit syn match   gitcommitSummary	"^.\{0,72\}" contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
autocmd Filetype gitcommit hi def link gitcommitSummary		Keyword
"autocmd Filetype expect setlocal tw=0

autocmd FileType python,sh,lua,conf,tf
    \ setlocal tabstop=4       |
    \ setlocal softtabstop=4   |
    \ setlocal shiftwidth=4    |
    \ setlocal tw=79           |
    \ setlocal expandtab       |

" shiftwidht: Number of spaces to indent when entering new scope (cindent). ex.
"   if ()
"   <shiftwidht>
"   Also is the number of spaces to shift when using '>>' and '<<'
"   set shiftwidth=2
" expandtab: Turn tabs into spaces
autocmd FileType c,cpp,expect
    \ setlocal tabstop=8           |
    \ setlocal shiftwidth=8        |
    \ setlocal noexpandtab         |
    \ setlocal tw=80               |
    \ setlocal cinoptions=(0,u0,U0 | " Slurm indentation

" Remove trailing white space at the end when writing
"autocmd BufWritePre * %s/\s\+$//e

"Show trailing whitespace and spaces before a tab:
"match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
"match ExtraWhitespace /[^\t]\zs\t\+/

" Show spaces used for indenting (so you use only tabs for indenting).
"match ExtraWhitespace /^\t*\zs \+/


" When more than one match, list all matches and
" complete till longest common string.
set wildmode=list:longest

"Turn off last highlighted search.
map <F9> :nohl<CR>

"Tab complete
function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

inoremap <silent> <TAB> <c-r>=InsertTabWrapper ("backward")<cr>
inoremap <silent> <s-tab> <c-r>=InsertTabWrapper ("forward")<cr>

function! FunctionName()
  " set the flags to search backwards and not move the cursor
  let flags = "bn"
  " get the line number of the most recent function declaration
  let fNum = search('^\w\+\s\+\w\+.*\n*\s*[(){:].*[,)]*\s*$', flags)

  " paste the matching line into a variable to return
  let tempstring = getline(fNum)

  " return the line we found and what number it's on
  return "line " . fNum . ": " . tempstring
endfunction

map \func<CR> :echo FunctionName()<CR>
map <silent> <F2> :echo FunctionName()<CR>

"expands gvim to the full screen size for vdiffer
if has("gui_running")
  if (&diff)
    :set lines=60
    :set columns=180
    set cc=81
    "set list listchars=tab:>-,trail:~,extends:>,precedes:<
    "set list listchars=tab:>-,trail:~,extends:>,precedes:<,space:␣
  endif
endif


" Close buffer without closing split window
" http://stackoverflow.com/a/8585343/839788
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Highlight column 81
hi ColorColumn ctermbg=lightgrey guibg=lightgrey
"set cc=81

" Be able to run aliases from cmd
" Bash must needs interactive
"set shellcmdflag=-ic

" vim air-line
"let g:airline_theme='dark'
"let g:airline_section_error =''
"let g:airline_section_warning =''
"let g:airline#extensions#tabline#enabled = 1

" https://superuser.com/a/402084
" Send ctrl+<arrow> to vim within tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

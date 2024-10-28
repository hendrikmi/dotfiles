"  ------ CONFIG -------
" Don't try to be vi compatible
set nocompatible
" Turn on syntax highlighting
syntax on
" Ensure space isn't mapped to anything before making it the leader key
nnoremap <SPACE> <Nop>
" Set leader key as space
let mapleader = " "

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Encoding
set encoding=utf-8

" Whitespace
" set wrap
" set textwidth=88
set formatoptions=cqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Set hybrid line number in normal move
" Set absolue line number in insert mode
set number
augroup numbertoggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

"make % vim match < > signs
setglobal matchpairs+=<:>
" This makes clipboard and yanking the same
" set clipboard+=unnamed

" TODO: This is no longer needed but leaving it in incase it is
" Change the shape of the cursor in normal and insert mode
" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_SR = "\<Esc>]50;CursorShape=2\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"


let &t_SI = "\e[6 q" " Inser mode, steady bar cursor
let &t_EI = "\e[2 q" " Normal Mode strady block cursor
let &t_SR = "\e[4 q" " Underline for replace cursor
" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

set ttimeout
set ttimeoutlen=1
set ttyfast

" ------ MAPPINGS -------

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes
Plug 'unblevable/quick-scope'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" LSP for coding
Plug 'dense-analysis/ale'
" Smooth scroll 
Plug 'yuttie/comfortable-motion.vim'
Plug 'dracula/vim', { 'as': 'dracula' } " Dracula theme
Plug 'junegunn/vim-peekaboo'
" {} will also jump to lines with only whitespace
Plug 'dbakker/vim-paragraph-motion'
" " Highlight copied text
Plug 'machakann/vim-highlightedyank'
call plug#end()

" Setting bottomr vim-airline theme
let g:airline_theme='bubblegum'
" Use quickscope only when pressing one of these keys
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
" map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
colorscheme dracula

" Mappings
" Scrolling
nnoremap z zz
nnoremap G Gzz
nnoremap gg ggzz
" nnoremap <C-f> <C-f>zz
" nnoremap <C-d> <C-d>zz
" nnoremap <C-u> <C-u>zz
" nnoremap <C-b> <C-b>zz
nnoremap <CR> :noh<CR><CR>


" -- Misc Mapping --
" H moves down from top of page
" Remap for addicental left arrow 
map H h 

"" Find impulse for given amount of lines
"function! ComforableMotionFindImpulse(diff)
"    let l:X = pow(abs(a:diff), 0.5)
"    let l:impulse =  0.7642497185838693
"                \  +11.916201835589376*l:X
"                \   +1.4842847475051253*(pow(l:X, 2))
"                \   +0.01733669295908215*(pow(l:X, 3))
"                \   -0.00034498320824916107*(pow(l:X, 4))
"                \   +2.941264385825093e-06*(pow(l:X, 5))
"    return l:impulse
"endfunction
"
"" Comforable-motion equivalent to zz
"function! ComforableMotionCenter(...)
"    " Save original cursor position
"    let s:orig_line = line('.')
"    let s:orig_curs = col('.')
"
"    " Count visble difference to top
"    let s:abs_top = line('w0')
"    let s:vis_top_diff = 0
"    while (line('.') > s:abs_top)
"        normal 1k
"        let s:vis_top_diff += 1
"    endwhile
"
"    let s:vis_center = winheight('.')/2
"    let s:vis_center_diff = s:vis_top_diff - s:vis_center
"
"    " Restore original cursor position
"    call cursor(s:orig_line, s:orig_curs)
"
"    if s:vis_center_diff == 0
"        return
"    endif
"
"    if (a:0 > 0 && ((a:1 == 'up' && s:vis_center_diff > 0) ||
"                  \ (a:1 == 'down' && s:vis_center_diff < 0)))
"        return
"    endif
"
"    let l:impulse = ComforableMotionFindImpulse(s:vis_center_diff)
"    call comfortable_motion#flick(s:vis_center_diff/abs(s:vis_center_diff)*l:impulse)
"endfunction
"
"" Comforable-motion equivalent to zt
"function! ComforableMotionTop()
"    let s:curLine = line('.')
"    let s:curCurs = col('.')
"    let s:absTop =  line('w0')
"    let s:visTopDif = 0
"    while (line('.') > s:absTop )
"        normal 1k
"        let s:visTopDif = s:visTopDif + 1
"    endwhile
"
"    let l:impulse = ComforableMotionFindImpulse(s:visTopDif)
"    call comfortable_motion#flick(l:impulse)
"    call cursor(s:curLine, s:curCurs)
"endfunction
"
"" Comforable-motion equivalent to zb
"function! ComforableMotionBottom()
"    let s:curLine = line('.')
"    let s:curCurs = col('.')
"    let s:absTop =  line('w0')
"    let s:visTopDif = 0
"
"    " counts difference to top
"    while (line('.') > s:absTop )
"        normal 1k
"        let s:visTopDif = (s:visTopDif + 1)
"    endwhile
"
"    let s:visBotDif = winheight('.') - s:visTopDif
"    let l:impulse = ComforableMotionFindImpulse(s:visBotDif-1)
"    call comfortable_motion#flick(-l:impulse)
"    call cursor(s:curLine, s:curCurs)
"endfunction
"
"nmap <silent> zz :call ComforableMotionCenter()<CR>
"nmap <silent> zt :call ComforableMotionTop()<CR>
"nmap <silent> zb :call ComforableMotionBottom()<CR>
"nmap <silent> {  {:call ComforableMotionCenter('up')<CR>
"nmap <silent> }  }:call ComforableMotionCenter('down')<CR>

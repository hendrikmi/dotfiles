" This file contains my custom Vim keybinds for Obsidian.
" Requires the obsidian-vimrc-support plugin.
" Put this in the `VAULT_ROOT/.obsidian.vimrc` file.

unmap <Space>
map <C-k> <nop>

" Better scrolling and searching with centered always
noremap <c-d> <C-d>zz
noremap <c-u> <C-u>zz
noremap <n> nzzzv
noremap <N> Nzzzv

" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

" H and L for beginning/end of line
nmap H ^
nmap L $

" <Esc> clears highlights
nnoremap <Esc> :nohl

" Yank to system clipboard
set clipboard=unnamed

" Tabs
exmap tabNext obcommand workspace:next-tab
nmap <Tab> :tabNext

exmap tabPrev obcommand workspace:previous-tab
nmap <S-Tab> :tabPrev

exmap wsClose obcommand workspace:close
map <Space>x :wsClose

" Explorer / Sidebar
exmap exToggle obcommand app:toggle-left-sidebar
map <Space>e :exToggle

exmap exReveal obcommand file-explorer:reveal-active-file
map <Space>r :exReveal

" Pane navigation
exmap focusLeft obcommand editor:focus-left
map <C-h> :focusLeft

exmap focusRight obcommand editor:focus-right
map <C-l> :focusRight

" Splits
exmap splitVertical obcommand workspace:split-vertical
nnoremap <Space>v :splitVertical

" [g]oto [o]pen file (= Quick Switcher)
exmap quickSwitcher obcommand obsidian-another-quick-switcher:search-command_recent-search
nnoremap go :quickSwitcher


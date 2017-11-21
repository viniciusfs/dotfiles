" .vimrc file
" Vinicius Figueiredo <viniciusfs@gmail.com>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" begin Vundle.vim setup - https://github.com/VundleVim/Vundle.vim
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Bundle 'VundleVim/Vundle.vim'

" list of plugins
"
" python code folding for Vim
Plugin 'tmhedberg/SimpylFold'
" python code indentation script
Plugin 'vim-scripts/indentpython.vim'
" python PEP8 syntax and style checker, requires 'python2-flake8', run with F7
Plugin 'nvie/vim-flake8'
" whitespace highlighting - to clean extra whitespace call :StripWhitespace
Plugin 'ntpeters/vim-better-whitespace'
" syntax highlighting
Plugin 'pearofducks/ansible-vim'
Plugin 'godlygeek/tabular'
" file type
Plugin 'vim-scripts/vim-json-bundle'
Plugin 'plasticboy/vim-markdown'
" indentLine
Plugin 'Yggdroot/indentLine'
" NERDtree, file browser
Plugin 'scrooloose/nerdtree'
" color schemes, term
Plugin 'tyrannicaltoucan/vim-deep-space'
Plugin 'vim-scripts/jellybeans.vim'
Plugin 'fxn/vim-monochrome'
" color schemes, gui
Plugin 'altercation/vim-colors-solarized'

call vundle#end()

filetype plugin indent on
" end of Vundle.vim setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set backspace=indent,eol,start
set title

syntax on

" enable filetype plugins and indention
filetype on
filetype plugin on

" set color scheme
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  set t_Co=256
  colorscheme deep-space
endif

set cmdheight=2
set showcmd
set laststatus=2
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})

" line numbers, F2 to enable/disable
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

" highlight current line, F3 to enable/disable
set cursorline
nnoremap <F3> :set cursorline!<CR>

" visual margin, F4 to enable/disable
set colorcolumn=81
function! VisualMargin()
  if(&colorcolumn == 81)
    set colorcolumn=0
  else
    set colorcolumn=81
  endif
endfunc
nnoremap <F4> :call VisualMargin()<CR>

" indentLines plugin, F5 to enable/disable
nnoremap <F5> :IndentLinesToggle<CR>

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" enable folding with spacebar
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Map NERDtree to CTRL+n
nnoremap <C-n> :NERDTreeToggle<CR>

" file encoding and format
set encoding=utf-8
set fileformats=unix,dos,mac

let g:indentLine_char = '→'

" disable syntax concealing in vim-markdown
let g:vim_markdown_conceal = 0


" python
au BufNewFile,BufRead *.py
  \ set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 |
  \ set expandtab autoindent fileformat=unix

let python_highlight_all=1

" HTML, CSS, JavaScript and Shell
au BufNewFile,BufRead *.js, *.html, *.css, *.sh
  \ set tabstop=2 softtabstop=2 shiftwidth=2 textwidth=79 |
  \ set expandtab autoindent

" JSON
au BufNewFile,BufRead *.json
  \ set filetype=json autoindent formatoptions=tcq2l textwidth=79 |
  \ set shiftwidth=2 softtabstop=2 tabstop=8 expandtab foldmethod=syntax

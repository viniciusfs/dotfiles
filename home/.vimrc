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
Plugin 'VundleVim/Vundle.vim'

" list of plugins
"""""""""""""""""
" color scheme
Plugin 'tyrannicaltoucan/vim-deep-space'

" shows identation levels (when using spaces) with special character
Plugin 'Yggdroot/indentLine'

" whitespace highlighting, to clean extra whitespace call :StripWhitespace
Plugin 'ntpeters/vim-better-whitespace'

" NERDtree file browser
Plugin 'scrooloose/nerdtree'

" python code folding
Plugin 'tmhedberg/SimpylFold'
" python code indentation script
Plugin 'vim-scripts/indentpython.vim'
" python PEP8 syntax and style checker, requires 'python2-flake8'
Plugin 'nvie/vim-flake8'

" terraform
Plugin 'hashivim/vim-terraform'

call vundle#end()

filetype plugin indent on
" end of Vundle.vim setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set title

syntax on

set background=dark
set termguicolors
colorscheme deep-space

set backspace=indent,eol,start
set encoding=utf-8
set fileformats=unix,dos,mac

set cmdheight=2
set showcmd
set laststatus=2
" https://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
set statusline=[%l,%v\ %L\ %P\]\ %f\ %y%m\ %r%h%w

" line numbers, F2 to enable/disable
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

" highlight current line, F3 to enable/disable
set cursorline
nnoremap <F3> :set cursorline!<CR>

" visual margin, f4 to enable/disable
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
let g:indentLine_char = '→'
nnoremap <F5> :IndentLinesToggle<CR>

" enable folding with spacebar
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Map NERDtree to CTRL+n
nnoremap <C-n> :NERDTreeToggle<CR>

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" enable filetype detection, plugins and indention
" https://vimdoc.sourceforge.net/htmldoc/filetype.html
filetype on
filetype plugin on
filetype plugin indent on

" python
au BufNewFile,BufRead *.py
  \ set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 |
  \ set expandtab autoindent fileformat=unix

let python_highlight_all=1

" HTML, CSS, JavaScript and Shell
au BufNewFile,BufRead *.js, *.html, *.css, *.sh, .bashrc, .bash_prompt, .bash_aliases
  \ set tabstop=2 softtabstop=2 shiftwidth=2 textwidth=79 |
  \ set expandtab autoindent

" JSON
au BufNewFile,BufRead *.json
  \ set filetype=json autoindent formatoptions=tcq2l textwidth=79 |
  \ set shiftwidth=2 softtabstop=2 tabstop=8 expandtab foldmethod=syntax

" YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

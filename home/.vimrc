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
Plugin 'rose-pine/vim'

" shows identation levels (when using spaces) with special character
Plugin 'Yggdroot/indentLine'

" whitespace highlighting
Plugin 'ntpeters/vim-better-whitespace'

" NERDtree file browser
Plugin 'scrooloose/nerdtree'

" python code folding
Plugin 'tmhedberg/SimpylFold'
" python code indentation script
Plugin 'vim-scripts/indentpython.vim'
" python PEP8 syntax and style checker, requires 'python2-flake8'
Plugin 'nvie/vim-flake8'

" markdown
Plugin 'godlygeek/tabular'
Plugin 'preservim/vim-markdown'

" terraform
Plugin 'hashivim/vim-terraform'

" go
Plugin 'fatih/vim-go'

" ale
Plugin 'dense-analysis/ale'

" codeium/windsurf
Plugin 'Exafunction/windsurf.vim'

call vundle#end()

filetype plugin indent on
" end of Vundle.vim setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set title

syntax on
colorscheme deep-space

set background=dark
set termguicolors
set backspace=indent,eol,start
set encoding=utf-8
set fileformats=unix,dos,mac
set cmdheight=2
set showcmd
set laststatus=2
" https://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
set statusline=[%l,%v\ %L\ %P\]\ %f\ %y%m\ %r%h%w
set splitbelow
set splitright
set conceallevel=2
set concealcursor-=n

" line numbers, F2 to enable/disable
set number
nnoremap <F2> :set number!<CR>

" highlight current line, F3 to enable/disable
set cursorline
nnoremap <F3> :set cursorline!<CR>

" visual margin, f4 to enable/disable
nnoremap <F4> :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>

" indentLines plugin, F5 to enable/disable
nnoremap <F5> :IndentLinesToggle<CR>

" enable folding with spacebar
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Map NERDtree to CTRL+n
nnoremap <C-n> :NERDTreeToggle<CR>

nnoremap <F10> :term<CR>

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

autocmd FileType sh set tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent

" ale plugin
let g:ale_completion_enabled = 1

" indentLines plugin
let g:indentLine_setConceal = 0
let g:indentLine_char = '┆'

" vim-better-whitespace plugin
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" vim-terraform plugin
let g:terraform_fmt_on_save=1
let g:terraform_fold_sections=1

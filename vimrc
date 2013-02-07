" Used by command-t to filter its list. TODO make ack use the same?
set wildignore+=*.jar,*.o,*.hi,*.obj,*.class,dist/**,build/**,*.png,*~,static/tmp/*,tmp/*,**/*.build/**,cabal-dev,*.gz,*.p12,*.zip,_darcs/*
set wildignore+=*/coverage/*,*/.bundle/*
set wildignore+=vendor/cache/*
set wildignore+=cabal-src/*,.hsenv/*
set wildignore+=target/*,project/target/*,*/target/scala-*,*/target/*$global*

set tags+=gems.tags,cabal.tags
set iskeyword=a-z,A-Z,_,.,39 " For hothasktags, tags can be qualified

set synmaxcol=350 " Prevents vim getting really sluggish if there are long lines of data
set t_Co=256 " Colors yo, we have some.

set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set showcmd

set history=1000
set mouse=a
set nocompatible
set autowriteall
set autoread
set clipboard+=unnamed " yank goes to clipboard
set modeline
set noswapfile
set nowritebackup
set number
set numberwidth=5
set winwidth=79
set hidden " prevents losing undo history after save

" Search
set ignorecase 
set smartcase
set gdefault
set incsearch
set hlsearch
set showmatch

set formatoptions+=o " auto insert current comment leader
set formatoptions-=r " but not after <enter> 
set formatoptions-=t " no autowrap

set nowrap
set wildmode=list:longest
set backspace=indent,eol,start

" space/tab settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent

syntax on

" More sane vim settings from 'Coming home to vim'
set wildmenu
set visualbell
set ttyfast
set laststatus=2

let mapleader = ","

runtime macros/matchit.vim

" Vundle start
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" The Bundles

" CORE
Bundle "gmarik/vundle"
Bundle "sjl/vitality.vim"
Bundle "scrooloose/syntastic"
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['scala'] }
Bundle "nkpart/command-t"
Bundle "mileszs/ack.vim" 
let g:ackprg = 'ag --nogroup --nocolor --column'
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "vim-scripts/Rename"
Bundle "tComment"
Bundle "Shougo/neocomplcache"

" Languages
Bundle "vim-ruby/vim-ruby" 
Bundle 'derekwyatt/vim-scala'
  " Toggles ruby blocks
Bundle "jgdavey/vim-blockle"
Bundle "tpope/vim-rails"
Bundle "kchmck/vim-coffee-script"
Bundle "Markdown"
Bundle "dag/vim2hs"
  " dependency for ghcmod-vim
Bundle "Shougo/vimproc" 
Bundle "eagletmt/ghcmod-vim"
let g:haskell_conceal_enumerations = 0
Bundle "pbrisbin/html-template-syntax"
Bundle "ujihisa/neco-ghc"

" Visual / UI / Colors
Bundle "tomasr/molokai"
Bundle "nanotech/jellybeans.vim"
Bundle "ColorV"
Bundle "chriskempson/base16-vim"

" Text objects
Bundle "kana/vim-textobj-user"
Bundle "nelstrom/vim-textobj-rubyblock" 
Bundle "vim-scripts/argtextobj.vim" 
Bundle "michaeljsmith/vim-indent-object" 

filetype plugin indent on

" VISUAL SETTINGS
set fillchars=vert:\ 
set background=dark
colorscheme base16-default

" AUTOBOTS ASSEMBLE
au BufLeave,FocusLost * silent! wall " Write all files whenever
au BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru} set ft=ruby
au BufRead,BufNewFile {*.md,*.markdown} set ft=markdown
au BufRead,BufNewFile *.coffee set filetype=coffee
au BufRead,BufNewFile {COMMIT_EDITMSG} set ft=gitcommit
au BufRead,BufNewFile {gitconfig,.gitconfig} set ft=gitconfig
au BufRead,BufNewFile *.hs set path+=templates,src | set suffixesadd+=.hamlet | setlocal omnifunc=necoghc#omnifunc | normal zR

" Autocreate directories for a new file
augroup BWCCreateDir
  au!
  autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END

" KEYS AND WHATNOT
nnoremap <leader><leader> <C-^>
nnoremap <leader>aa :Ack<space>
nnoremap <leader>s <C-w>v<C-w>w:A<cr> " Split with alternate
nnoremap <C-j> :cn<cr>
nnoremap <C-k> :cp<cr> 
nnoremap <cr> :noh<cr>

" Command Ts
runtime finders.vim
nnoremap <leader>gf :call CommandTShowMyFileFinder('*')<cr>
nnoremap <leader>gh :call CommandTShowHoogleFinder()<cr>
nnoremap <leader>gg :call CommandTShowGemfileFinder()<cr>
nnoremap <leader>gt :call CommandTShowMyTagFinder()<cr>
nnoremap <leader>gS :call ShowSchemaFinder()<cr>
nnoremap <leader>gm :call GitStatusFinder()<cr>
nnoremap <leader>ga :call AckLol()<cr>
nnoremap <leader>gw :call Widget()<cr>
" For yesod apps
function! Widget()
  let dir = expand('%:h')
  if dir == "templates"
    let base = expand('%:t:r')
  else
    let base = expand('<cword>')
  endif
  call CommandTShowMyFileFinder('templates/' . base . '.*')
endfunction

nnoremap <leader>/ :GhcModTypeClear<cr>
" nnoremap <leader>. :GhcModType<cr>
nnoremap <leader>T :GhcModTypeInsert<cr>
nnoremap <leader>c :wa<cr>:GhcModCheckAsync<cr>

nnoremap <leader>ms :call MapSpecFile()<cr>
func! MapSpecFile()
  let command = "any_test " . expand("%")
  exe 'map <leader>t :wa\|!any_test ' . expand("%") . '<cr>'
endfunc

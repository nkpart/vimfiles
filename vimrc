" Used by command-t to filter its list. TODO make ack use the same?
set wildignore+=*.o,*.hi,*.obj,*.class,dist/**,build/**,*.png,*~,static/tmp/*,tmp/*,**/*.build/**,cabal-dev,*.gz,*.p12
set synmaxcol=240

" Making insert/normal caret look different in iTerm
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Mouse support TURN ON
set mouse=a

" General "{{{
set nocompatible
set history=50		" keep 50 lines of command line history
set autowrite
set autoread
set clipboard+=unnamed " yank goes to clipboard
" Modeline
set modelines=5
set modeline
" Backup
set noswapfile
set nowritebackup
set nobackup
set backupdir=/var/tmp
set directory=/var/tmp
" Buffers
set hidden
" Search/Match
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
" "}}}

" Formatting "{{{
set fo+=o " auto insert current comment leader
set fo-=r " but not after <enter> 
set fo-=t " no autowrap

set nowrap
set textwidth=0
set wildmode=list:longest

set backspace=indent,eol,start

" space/tab settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set linespace=4
set smarttab

set cindent
set autoindent
set smartindent

syntax on
filetype plugin indent on
" "}}}

" More sane vim settings from 'Coming home to vim'
set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set wildmenu
set visualbell
set ttyfast
set ruler
set laststatus=2
set number

set guifont=Anonymous\ Pro:h14

let mapleader = ","

" Vundles " {{{ 
set rtp+=~/.vim/vundle.git
call vundle#rc()

" The Bundles

" Bundle Config
" Bundle "git://github.com/altercation/vim-colors-solarized.git" 
Bundle "git://git.wincent.com/command-t.git"
Bundle "git://github.com/mileszs/ack.vim.git" 
Bundle "git://github.com/vim-ruby/vim-ruby.git" 
Bundle "git://github.com/tpope/vim-rails.git"

runtime macros/matchit.vim
Bundle "git://github.com/kana/vim-textobj-user.git"
Bundle "git://github.com/nelstrom/vim-textobj-rubyblock.git"
Bundle "Lokaltog/vim-easymotion"

Bundle "https://github.com/ewiplayer/vim-scala.git"
au BufRead,BufNewFile *.scala set filetype=scala
au! Syntax scala source ~/.vim/bundle/vim-scala/syntax/scala.vim

Bundle "tlib"
Bundle "https://github.com/MarcWeber/vim-addon-manager.git"
Bundle "https://github.com/MarcWeber/vim-addon-mw-utils.git"
Bundle "https://github.com/MarcWeber/vim-addon-actions.git"
Bundle "https://github.com/MarcWeber/vim-addon-sbt.git"

Bundle "jQuery"
Bundle "Markdown"
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "fugitive.vim"
Bundle "Conque-Shell"
Bundle "tComment"
Bundle "gitv"
Bundle "haskell.vim"
Bundle "L9"

Bundle "bufexplorer.zip"

if $PRESENTATION_MODE
  colorscheme github
  set background=light
else
  set background=dark
  colorscheme tir_black
end

let g:Gitv_OpenHorizontal=1

au Bufenter *.hs compiler ghc
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"

" " }}}

set statusline="%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{fugitive#statusline()} %P"

"Auto commands
au BufLeave,FocusLost * silent! wall
au BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru} set ft=ruby
au BufRead,BufNewFile {*.md,*.mkd,*.markdown} set ft=markdown
au BufRead,BufNewFile {COMMIT_EDITMSG} set ft=gitcommit

" au BufRead * silent! exe '!echo -e "\033];%:t\007"'
" au VimLeave * silent! exe '!echo -e "\033];\007"'

" === My Keys ===

nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %
vnoremap / /\v
nnoremap <leader><leader> <C-^>
" Sets a mark then start an ack search
nnoremap <leader>A mA:Ack<space>
nnoremap <leader>aa mA:Ack<space>
nnoremap <leader>aw mA:Ack<space><cword><cr>
nnoremap <leader>ad mA:Ack<space>"def <cword>"<cr>

" Command Ts
nnoremap <leader>gf :CommandTFlush<cr>:CommandT<cr>
  " Rails
nnoremap <leader>gs :CommandTFlush<cr>:CommandT spec<cr>
nnoremap <leader>ga :CommandTFlush<cr>:CommandT app<cr>
nnoremap <leader>gm :CommandTFlush<cr>:CommandT app/models<cr>
nnoremap <leader>gl :CommandTFlush<cr>:CommandT lib<cr>
nnoremap <leader>gv :CommandTFlush<cr>:CommandT app/views<cr>
nnoremap <leader>gc :CommandTFlush<cr>:CommandT app/controllers<cr>

" Horizontal splits of specific things, ctrl-c to close
"  - routes
nnoremap <leader>gr <C-w>n:e config/routes.rb<cr>:call MapEscClose()<cr>
"  - rake routes
nnoremap <leader>rr <C-w>n:read !rake routes<cr>:call MapEscClose()<cr>
"  - schema
nnoremap <leader>gS <C-w>n:e db/schema.rb<cr>:call MapEscClose()<cr>

nnoremap <leader>o <C-w>n:call MapEscClose()<cr>:CommandTFlush<cr>:CommandT<cr>

if filereadable("build.sbt")
  nnoremap <leader>gs :CommandTFlush<cr>:CommandT src/main/scala<cr>
endif

func! MapEscClose()
  exe 'map <buffer> <C-c> :bd!<cr>'
endfunc

nnoremap <leader>hc :call Hoogle()<cr>

func! Hoogle()
  let h = input("Hoogle: ", "")
  exe '!hoogle --color -n 10 "' . h . '"' 
endfunc

" Append to end of line
nnoremap ,p A<space><esc>p

nnoremap <C-N> :cn<cr>
nnoremap <C-P> :cp<cr> 

nnoremap <esc><esc> :ccl<cr>:noh<cr>
nnoremap <CR> :noh<cr>
inoremap jj <esc>:ccl<cr>:noh<cr>

cnoremap %% <C-R>=expand('%:h').'/'<cr>

nnoremap <leader>w ?{\\|[\\|(<cr>:noh<cr>v% 

nnoremap <leader>r :A<cr> 
nnoremap <leader>s <C-w>v<C-w>w:A<cr> " Split with alternate
nnoremap <leader>ms :call MapSpecFile()<cr>

func! MapSpecFile()
  exe 'map ,t :wa\|!any_test ' . expand("%") . '<cr>'
endfunc

" Hax intentions
nnoremap <leader>mf yiwo@<esc>pa<space>=<space><esc>p
nnoremap <leader>mi :call MakeInstanceVar()<cr>

nnoremap <leader>ghci :ConqueTermVSplit ghci<cr>

au BufEnter ghci* set insertmode
au BufEnter ghci* inoremap <buffer> <C-w>w <esc><esc><C-w>w
au BufLeave ghci* set noinsertmode

func! MakeInstanceVar()
  let saved = getpos('.')
  normal ebh
  let foo = getline(".")[col(".") - 1]
  if foo == "@"
    normal x
  else
    normal a@
  endif
  call setpos('.', saved)
endfunc
" test @words
"  @foo @foo Bar

" Make a haskell import qualified
nnoremap <leader>mq 0wiqualified<space><esc>$bea<space>as<space>

" Add a language pragma to a haskell file
nnoremap <leader>ml ggO{-#<space>LANGUAGE<space><space>#-}<esc>bhi


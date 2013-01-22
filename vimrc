" Used by command-t to filter its list. TODO make ack use the same?
set wildignore+=*.o,*.hi,*.obj,*.class,dist/**,build/**,*.png,*~,static/tmp/*,tmp/*,**/*.build/**,cabal-dev,*.gz,*.p12,*.zip,_darcs/*
set wildignore+=*.jar
set wildignore+=*/coverage/*,*/.bundle/*
set wildignore+=tmp/capybara/*
set wildignore+=vendor/cache/*
set wildignore+=*/content_bundles/*/original/*
set wildignore+=cabal-src/*,.hsenv/*
set wildignore+=target/*
set wildignore+=project/target/*
set wildignore+=*/target/scala-*
set wildignore+=*/target/*$global*

set tags+=gems.tags,cabal.tags
set iskeyword=a-z,A-Z,_,.,39 " For hothasktags, tags can be qualified

" Prevents vim getting really sluggish if there are long lines of data
set synmaxcol=350
set t_Co=256 " Colors yo, we have some.

" Making insert/normal caret look different in iTerm/tmux
if exists('$TMUX')
  " let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  " let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  " let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  " let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" let g:vitality_fix_cursor=0

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

" Cargoing in from GB
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
set encoding=utf-8
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
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "vim-scripts/Rename"
Bundle "tComment"
Bundle "Shougo/neocomplcache"
Bundle "majutsushi/tagbar"
Bundle "benmills/vimux"
Bundle "UltiSnips"

" Languages
Bundle "pufuwozu/roy", { 'rtp': 'misc/vim' }
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
set guioptions-=L
set guioptions-=r
set guioptions-=T
if has("gui_running")
  set guifont=Menlo:h13
  set linespace=3
  colorscheme smyck
else
  " if $PRESENTATION_MODE
    " set background=dark
    if 0
      set background=light
      " colorscheme base16-default
      " colorscheme 
      colorscheme solarized
    else
      set background=dark
      colorscheme base16-default
    end
  " else
    " set background=dark
    " colorscheme grb4
    " tir_black, jellybeans, grb4, smyck, molokai, solarized
    " hi Search ctermbg=234
    " hi Define ctermfg=9
  " end
end
" AUTOBOTS ASSEMBLE
" Write all files whenever
au BufLeave,FocusLost * silent! wall
au BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru} set ft=ruby
au BufRead,BufNewFile {*.md,*.mkd,*.markdown} set ft=markdown
au BufRead,BufNewFile *.coffee set filetype=coffee
au BufRead,BufNewFile {COMMIT_EDITMSG} set ft=gitcommit
au BufRead,BufNewFile gitconfig set ft=gitconfig
au BufRead,BufNewFile .gitconfig set ft=gitconfig
au BufRead,BufNewFile *.hs set path+=templates
au BufRead,BufNewFile *.hs set path+=src
au BufRead,BufNewFile *.hs set suffixesadd+=.hamlet
au BufRead,BufNewFile *.hs setlocal omnifunc=necoghc#omnifunc 
au BufRead,BufNewFile *.hs normal zR
au BufRead,BufNewFile *.rb setlocal omnifunc=necoghc#omnifunc 

" Autocreate directories for a new file
augroup BWCCreateDir
  au!
  autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END

" KEYS AND WHATNOT
nnoremap <leader><leader> <C-^>
  " Split last
nnoremap <leader>. <C-w>v<C-w>w<C-^>

nnoremap <leader>aa mA:Ack<space>

runtime finders.vim

" Command Ts
nnoremap <leader>gf :call CommandTShowMyFileFinder('*')<cr>
nnoremap <leader>gh :call CommandTShowHoogleFinder()<cr>
nnoremap <leader>gg :call CommandTShowGemfileFinder()<cr>
nnoremap <leader>gt :call CommandTShowMyTagFinder()<cr>
  " Rails
nnoremap <leader>gs :call CommandTShowMyFileFinder('spec')<cr>
nnoremap <leader>gS :call ShowSchemaFinder()<cr>
nnoremap <leader>gm :call GitStatusFinder()<cr>
nnoremap <leader>ga :call AckLol()<cr>
nnoremap <leader>gw :call Widget()<cr>

function! Widget()
  let dir = expand('%:h')
  if dir == "templates"
    let base = expand('%:t:r')
  else
    let base = expand('<cword>')
  endif
  call CommandTShowMyFileFinder('templates/' . base . '.*')
endfunction

nnoremap <C-j> :cn<cr>
nnoremap <C-k> :cp<cr> 

" Navigate with control in insert mode
inoremap <C-j> <esc>ja
inoremap <C-k> <esc>ka
inoremap <C-h> <esc>i
inoremap <C-l> <esc>la

" Line rocking!
nnoremap <BS> $
nnoremap ` ^

nnoremap <leader>/ :GhcModTypeClear<cr>
" TODO give this something
" nnoremap <leader>. :GhcModType<cr>
nnoremap <leader>T :GhcModTypeInsert<cr>
nnoremap <leader>c :wa<cr>:GhcModCheckAsync<cr>

inoremap Ll λ

nnoremap <cr> :noh<cr>

nnoremap <leader>s <C-w>v<C-w>w:A<cr> " Split with alternate

nnoremap <leader>ms :call MapSpecFile()<cr>
func! MapSpecFile()
  let command = "any_test " . expand("%")
  exe 'map <leader>t :wa\|!any_test ' . expand("%") . '<cr>'
  " exe 'map <leader>t :wa\|silent call VimuxRunCommand("clear; echo Running ' . expand('%') . '; ' . command . ' && exit")<cr>'
endfunc

" Show syntax for a bit
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

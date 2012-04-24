" Used by command-t to filter its list. TODO make ack use the same?
set wildignore+=*.o,*.hi,*.obj,*.class,dist/**,build/**,*.png,*~,static/tmp/*,tmp/*,**/*.build/**,cabal-dev,*.gz,*.p12,*.zip
set wildignore+=*/coverage/*
set wildignore+=*/.bundle/*
set wildignore+=*/content_bundles/*/original/*
set wildignore+=*/rss_images/*.jpg,*/rss_images/*.gif
set wildignore+=vendor/cache/*
set wildignore+=_darcs/*
set wildignore+=cabal-src/*
set wildignore+=.hsenv/*

set tags+=gems.tags
set tags+=cabal.tags
set iskeyword=a-z,A-Z,_,.,39 " For hothasktags, tags can be qualified

" Prevents vim getting really sluggish if there are long lines of data
set synmaxcol=400
set t_Co=256

" Making insert/normal caret look different in iTerm
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

set mouse=a
set nocompatible
set history=50		" keep 50 lines of command line history
set autowrite
set autoread
set clipboard+=unnamed " yank goes to clipboard
set modelines=5
set modeline
set noswapfile
set nowritebackup
set nobackup
set backupdir=/var/tmp
set directory=/var/tmp
set hidden
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

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

syntax enable
filetype plugin indent on

" More sane vim settings from 'Coming home to vim'
set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set wildmenu
set visualbell
set ttyfast
set ruler
set laststatus=2 " Always show the statusline
set number

set guifont=Anonymous\ Pro:h14

let mapleader = ","
" nnoremap <space> :

runtime macros/matchit.vim

set rtp+=~/.vim/vundle.git
call vundle#rc()

" The Bundles
Bundle "msanders/snipmate.vim"
Bundle "https://github.com/scrooloose/syntastic.git"
Bundle "https://github.com/Lokaltog/vim-powerline.git"
Bundle "jellybeans.vim"
Bundle "git://github.com/nkpart/command-t.git"
Bundle "git://github.com/mileszs/ack.vim.git" 
Bundle "git://github.com/vim-ruby/vim-ruby.git" 
Bundle "git://github.com/tpope/vim-rails.git"
Bundle "https://github.com/kchmck/vim-coffee-script.git"
Bundle "https://github.com/jgdavey/vim-blockle.git"
Bundle "Markdown"
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "tComment"
Bundle "https://github.com/lukerandall/haskellmode-vim.git"
Bundle "https://github.com/pbrisbin/html-template-syntax.git"
Bundle "https://github.com/Shougo/vimproc.git"
Bundle "https://github.com/eagletmt/ghcmod-vim.git"
  " Useful text objects
Bundle "https://github.com/kana/vim-textobj-user.git"
Bundle "https://github.com/nelstrom/vim-textobj-rubyblock.git" 
Bundle "https://github.com/vim-scripts/argtextobj.vim.git" 
Bundle "https://github.com/michaeljsmith/vim-indent-object.git" 

if $PRESENTATION_MODE
  set background=light
  colorscheme github
else
  set background=dark
  " wombat256, tir_black
  colorscheme jellybeans_jason
end

" Haskell config
au Bufenter *.hs compiler ghc
function! SetToCabalBuild()
  if glob("*.cabal") != ''
    set makeprg=cabal\ build
  endif
endfunction
autocmd BufEnter *.hs,*.lhs :call SetToCabalBuild()

let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"

" haskell-mode.vim does bad things to shellpipe that break ack, this is the fix
let g:original_shellpipe=&shellpipe
au QuickFixCmdPre grep setlocal shellpipe=2>&1\|tee

set statusline="%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P"

" Write all files whenever
au BufLeave,FocusLost * silent! wall

au BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru} set ft=ruby
au BufRead,BufNewFile {*.md,*.mkd,*.markdown} set ft=markdown
au BufRead,BufNewFile *.coffee set filetype=coffee
au BufRead,BufNewFile {COMMIT_EDITMSG} set ft=gitcommit

" === My Keys ===
nnoremap <leader><leader> <C-^>
" Sets a mark then start an ack search
nnoremap <leader>aa mA:Ack<space>
nnoremap <leader>ad mA:Ack<space>"def (self\.)?<cword>"<cr>
nnoremap <leader>ac mA:Ack<space>"<<<<"<cr><C-w>w

runtime finders.vim

" Command Ts
nnoremap <leader>gF :CommandTFlush<cr>:CommandT<cr>
nnoremap <leader>gf :call CommandTShowMyFileFinder('*')<cr>
nnoremap <leader>gb :CommandTFlush<cr>:CommandTBuffer<cr>
nnoremap <leader>gh :call CommandTShowHoogleFinder()<cr>
inoremap <C-\> :call CommandTShowHoogleFinder()<cr>
nnoremap <leader>gg :call CommandTShowGemfileFinder()<cr>
nnoremap <leader>gt :call CommandTShowMyTagFinder()<cr>
  " Rails
nnoremap <leader>gs :CommandTFlush<cr>:CommandT spec<cr>
nnoremap <leader>gm :call GitStatusFinder()<cr>
nnoremap <leader>gl :CommandTFlush<cr>:CommandT lib<cr>
nnoremap <leader>gv :CommandTFlush<cr>:CommandT app/views<cr>
nnoremap <leader>gc :CommandTFlush<cr>:CommandT app/controllers<cr>

nnoremap <C-j> :cn<cr>
nnoremap <C-k> :cp<cr> 

nnoremap <leader>t :GhcModType<cr>
nnoremap <leader>T :silent :GhcModTypeClear<cr>
nnoremap <leader>c :wa<cr>:GhcModCheck<cr>

nnoremap <CR> :noh<cr>

nnoremap <leader>s <C-w>v<C-w>w:A<cr> " Split with alternate

" Make field
nnoremap <leader>mf yiwo@<esc>pa<space>=<space><esc>p
" Toggle instance var
nnoremap <leader>mi :call ToggleInstanceVar()<cr>

func! ToggleInstanceVar()
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

" Make a haskell import qualified
nnoremap <leader>mq 0wiqualified<space><esc>$bea<space>as<space>

" Add a language pragma to a haskell file
nnoremap <leader>ml ggO{-#<space>LANGUAGE<space><space>#-}<esc>bhi

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    exec '!any_test ' . a:filename
    return

    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
" map <leader>c :w\|:!script/features<cr>
" map <leader>w :w\|:!script/features --profile wip<cr>

" nnoremap <leader>ms :call MapSpecFile()<cr>
func! MapSpecFile()
  let command = "any_test " . expand("%")
  exe 'map ,t :wa\|!any_test ' . expand("%") . '<cr>'
endfunc

fun! Snip(snippet)
	if exists('g:SuperTabMappingForward')
		if g:SuperTabMappingForward == "<tab>"
			let SuperTabKey = "\<c-n>"
		elseif g:SuperTabMappingBackward == "<tab>"
			let SuperTabKey = "\<c-p>"
		endif
	endif

	if pumvisible() " Update snippet if completion is used, or deal with supertab
		if exists('SuperTabKey')
			call feedkeys(SuperTabKey) | return ''
		endif
		call feedkeys("\<esc>a", 'n') " Close completion menu
		call feedkeys("\<tab>") | return ''
	endif

	if exists('g:snipPos') | return snipMate#jumpTabStop(0) | endif

  if a:snippet != ''
    return snipMate#expandSnip(a:snippet, col('.'))
  endif

	if exists('SuperTabKey')
		call feedkeys(SuperTabKey)
		return ''
	endif
	return "\<tab>"
endf

nnoremap <leader>1 i<C-r>=Snip("a ${1:one} $1 b")<cr>



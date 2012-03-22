" Used by command-t to filter its list. TODO make ack use the same?
set wildignore+=*.o,*.hi,*.obj,*.class,dist/**,build/**,*.png,*~,static/tmp/*,tmp/*,**/*.build/**,cabal-dev,*.gz,*.p12,*.zip
set wildignore+=*/coverage/*
set wildignore+=*/.bundle/*
set wildignore+=*/content_bundles/*/original/*
set wildignore+=*/rss_images/*.jpg,*/rss_images/*.gif
set wildignore+=vendor/cache/*
set wildignore+=_darcs/*

set tags+=gems.tags

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
nnoremap <space> :

runtime macros/matchit.vim

set rtp+=~/.vim/vundle.git
call vundle#rc()

" The Bundles
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

" Command T Finders Rule

ruby $LOAD_PATH << File.expand_path("~/.vim/ruby")
ruby require "command-t-finders"
function! s:CommandTShowHoogleFinder()
ruby << RUBY
finder = Finder.base.
  find_command { |str| 
    modules = VIM::evaluate("exists(\"g:hoogle_modules\") ? g:hoogle_modules : \"\" ")
    %`hoogle #{modules} -n 10 "#{str}"` 
  }.
  copy_selection
$command_t.show_finder(finder)
RUBY
endfunction

function! s:CommandTShowMyTagFinder()
ruby << RUBY
finder = Finder.base.
  with_matcher { |str| 
    if !str || str.empty? || str.length < 3
      ""
    else
      a, b = *str.split(' ')
      if b
        tag = b
        file = a
      else
        tag = a
        file = nil
      end
      if !tag || tag.empty? || tag.length < 3
        ""
      else
        VIM::evaluate("taglist(#{tag.inspect})").select { |x| !file || x['filename'].include?(file) }.map { |t| 
          t['name'] + " - " + t['filename'].gsub(Dir.pwd + '/', '')#.gsub(/.*\/gems\//, '') 
        }
      end
    end
  }.
  vim_handler { |selection|
    md = selection.match(/(.*) - (.*)/)
    tag = md[1]
    file = md[2] 
    <<-EOC
silent! e #{file}
silent! tag #{tag}
normal zz
    EOC
  }
$command_t.show_finder(finder)
RUBY
endfunction

function! s:CommandTShowGemfileFinder()
ruby << RUBY
pwd = ::VIM::evaluate 'getcwd()'
gems = IO.read(File.join(pwd, "Gemfile.lock"))[/specs:(.*)PLATFORMS/m,1].split("\n").grep(/\s\s\s\s.*\(\d\..*\)/).map { |x| x.strip }
finder = Finder.base.
  grep_list(gems).
  vim_handler { |selection|
    gem_name = selection[/\s*(.*)\s*\(.*/, 1]
    dir = `bundle show #{gem_name}`.chomp
    <<-VIM
    :Sexplore #{dir}
    :lcd #{dir}
    VIM
  }
$command_t.show_finder(finder)
RUBY
endfunction

" Command Ts
nnoremap <leader>gf :CommandTFlush<cr>:CommandT<cr>
nnoremap <leader>gb :CommandTFlush<cr>:CommandTBuffer<cr>
nnoremap <leader>gh :CommandTFlush<cr>:call <SID>CommandTShowHoogleFinder()<cr>
nnoremap <leader>gg :CommandTFlush<cr>:call <SID>CommandTShowGemfileFinder()<cr>
nnoremap <leader>gt :CommandTFlush<cr>:call <SID>CommandTShowMyTagFinder()<cr>
  " Rails
nnoremap <leader>gs :CommandTFlush<cr>:CommandT spec<cr>
nnoremap <leader>ga :CommandTFlush<cr>:CommandT app<cr>
nnoremap <leader>gm :CommandTFlush<cr>:CommandT app/models<cr>
nnoremap <leader>gl :CommandTFlush<cr>:CommandT lib<cr>
nnoremap <leader>gv :CommandTFlush<cr>:CommandT app/views<cr>
nnoremap <leader>gc :CommandTFlush<cr>:CommandT app/controllers<cr>

nnoremap <leader>B :silent !osascript ~/chrome_refresh.scpt<cr><C-l>

nnoremap <C-j> :cn<cr>
nnoremap <C-k> :cp<cr> 

nnoremap <leader>t :GhcModType<cr>
nnoremap <leader>T :silent :GhcModTypeClear<cr>

nnoremap <CR> :noh<cr>
inoremap jj <esc>:ccl<cr>:noh<cr>

cnoremap %% <C-R>=expand('%:h').'/'<cr>

nnoremap <leader>r :A<cr> 
nnoremap <leader>s <C-w>v<C-w>w:A<cr> " Split with alternate
nnoremap <leader>ms :call MapSpecFile()<cr>

nnoremap <leader>c :wall<cr>:make<cr>

func! MapSpecFile()
  let command = "any_test " . expand("%")
  exe 'map ,t :wa\|!any_test ' . expand("%") . '<cr>'
endfunc

" Make field
nnoremap <leader>mf yiwo@<esc>pa<space>=<space><esc>p
" Toggle instance var
nnoremap <leader>mi :call ToggleInstanceVar()<cr>
nnoremap <leader>G :GHCi<space>

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


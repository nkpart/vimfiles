" Used by command-t to filter its list. TODO make ack use the same?
set wildignore+=*.jar,*.o,*.hi,*.obj,*.class,dist/**,build/**,*.png,*~,static/tmp/*,tmp/*,**/*.build/**,cabal-dev/*,*.gz,*.p12,*.zip,_darcs/*
set wildignore+=*/coverage/*,*/.bundle/*
set wildignore+=vendor/cache/*
set wildignore+=cabal-src/*,.hsenv/*
set wildignore+=target/*,project/target/*,*/target/scala-*,*/target/*$global*
set wildignore+=*/.git/*

set tags+=gems.tags,cabal.tags
set iskeyword=a-z,A-Z,_,.,39 " For hothasktags, tags can be qualified

set synmaxcol=400 " Prevents vim getting really sluggish if there are long lines of data

set statusline=%<%f\ (%{&ft})

set history=1000
set mouse=a
set nocompatible
set autowriteall
set autoread
set clipboard+=unnamed " yank goes to clipboard
set noswapfile
set nowritebackup
set number
set hidden " prevents losing undo history after save
set nofoldenable

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

" Change cursor in iTerm on insert
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

syntax on

" More sane vim settings from 'Coming home to vim'
set wildmenu
set visualbell
set ttyfast
set laststatus=2

set completeopt=longest,menuone

let mapleader = ","

runtime macros/matchit.vim

" Vundle start
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle "gmarik/vundle"

" The Bundles

" CORE
Bundle "terryma/vim-multiple-cursors"
Bundle "scrooloose/syntastic"
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['scala'] }
Bundle "nkpart/command-t"
Bundle "rking/ag.vim"
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "tComment"

let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 0
let g:neocomplcache_lock_buffer_name_pattern = "" "'\*ku\*'
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

Bundle "Shougo/neocomplcache"
Bundle "vim-scripts/Rename"
Bundle "tpope/vim-dispatch"
Bundle "tpope/vim-fugitive"
Bundle "tpope/vim-abolish"
Bundle "Shougo/vimproc" 
Bundle "Shougo/unite.vim"

" Languages
Bundle "vim-ruby/vim-ruby" 
Bundle "derekwyatt/vim-scala"
Bundle "gre/play2vim"
" Bundle "Rip-Rip/clang_complete"
" Bundle "eraserhd/vim-ios"
" Bundle "msanders/cocoa.vim"
Bundle "othree/html5.vim"

  " Toggles ruby blocks
Bundle "jgdavey/vim-blockle"
Bundle "tpope/vim-rails"

Bundle "Markdown"

Bundle "dag/vim2hs"
" 
Bundle "eagletmt/ghcmod-vim"
let g:haskell_conceal_enumerations = 0
Bundle "pbrisbin/html-template-syntax"
Bundle "ujihisa/neco-ghc"
" 
" " Visual / UI / Colors
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
" set background=dark
"
if has('gui_running')
  colorscheme base16-monokai
  set guioptions=-ace
  set guifont=Source\ Code\ Pro\ Light:h13
  set linespace=2
else
  colorscheme base16-default
endif
hi Keyword cterm=bold

highlight clear SignColumn
" AUTOBOTS ASSEMBLE
au BufLeave,FocusLost * silent! wall " Write all files whenever
au BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru} set ft=ruby
au BufRead,BufNewFile {*.md,*.markdown} set ft=markdown
au BufRead,BufNewFile {COMMIT_EDITMSG} set ft=gitcommit
au BufRead,BufNewFile {gitconfig,.gitconfig} set ft=gitconfig
au BufRead,BufNewFile *.hs set path+=templates,src | set suffixesadd+=.hamlet | setlocal omnifunc=necoghc#omnifunc
au BufRead,BufNewFile {*.h,*.m} setlocal tabstop=4 | setlocal shiftwidth=4 | setlocal softtabstop=4 | setlocal noexpandtab

au BufNewFile *.hs call InsertHsModule()
function! InsertHsModule()
  let parts = split(bufname("%"), '/')
  call filter(parts, 'v:val =~ "\\u.*"')
  let decl = "module " . substitute(join(parts, '.'), ".hs", "", "") . " where"
  execute "normal i" . decl
endfunction

" Autocreate directories for a new file
augroup BWCCreateDir
  au!
  autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END

" MAPS AND WHATNOT
inoremap jk <esc>
nnoremap <leader><leader> <C-^>
nnoremap <leader>aa :Ag<space>
nnoremap <leader>s <C-w>v<C-w>w:A<cr> " Split with alternate
nnoremap <C-j> :cn<cr>
nnoremap <C-k> :cp<cr> 
nnoremap <cr> :noh<cr>
vnoremap S y:exec "silent !git log -p -S\"" . @" . "\""<cr>:redraw!<cr>
nnoremap <Space> :wa<cr>

" Command Ts
runtime finders.vim
nnoremap <leader>gg :call CommandTShowGemfileFinder()<cr>
nnoremap <leader>gt :call CommandTShowMyTagFinder()<cr>
nnoremap <leader>gS :call ShowSchemaFinder()<cr>
nnoremap <leader>gM :call CommandTListChanges()<cr>

" THE UNITE CONFIG
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" See unite-filter-sorter_rank, but this is basically how command-t works.
" Any file sources should go in this list
call unite#custom#source('buffer,file,file_mru,file_rec,file_rec/async', 'sorters', 'sorter_rank')
" Screw caching. Get faster hardware.
" This doesn't work as well as I'd hoped.
let g:unite_source_file_rec_min_cache_files=0

let g:unite_enable_start_insert = 1
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  map <buffer> <ESC>      <Plug>(unite_exit)
  map <buffer> <C-c>      <Plug>(unite_exit)
  imap <buffer> <ESC>      <Plug>(unite_exit)
  imap <buffer> <C-c>      <Plug>(unite_exit)
  imap <buffer> <C-j>     <Plug>(unite_select_next_line)
  imap <buffer> <C-k>     <Plug>(unite_select_previous_line)
endfunction

nnoremap <leader>gf :Unite file_rec/async<cr>
nnoremap <leader>gh :Unite hoogle<cr>
nnoremap <leader>ga :Unite ag<cr>
nnoremap <leader>gm :Unite git_status<cr>

nnoremap <leader>ge :Unite quickfix<cr>

nnoremap <leader>/ :GhcModTypeClear<cr>
nnoremap <leader>. :GhcModType<cr>
nnoremap <leader>T :GhcModTypeInsert<cr>
nnoremap <leader>c :wa<cr>:GhcModCheckAsync<cr>

nnoremap <leader>e :cfile ./target/streams/compile/compile/\$global/out<cr>

nnoremap <leader>ms :call MapSpecFile()<cr>
func! MapSpecFile()
  exe 'map <leader>t :wa\|!any_test ' . expand("%") . '<cr>'
endfunc

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

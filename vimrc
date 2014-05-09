set synmaxcol=400 " Prevents vim getting really sluggish if there are long lines of data
set mouse=a
set nocompatible
set autowriteall
set clipboard+=unnamed " yank goes to clipboard
set number
set hidden " prevents losing undo history after save
set nofoldenable
set noswapfile

" Search
set ignorecase 
set smartcase
set gdefault
set hlsearch

" space/tab settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent

" set formatoptions+=o " auto insert current comment leader
" set formatoptions-=r " but not after <enter> 
" set formatoptions-=t " no autowrap

set nowrap
set wildmode=list:longest

" Change cursor in iTerm on insert
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

syntax on

set visualbell

set completeopt=longest,menuone

let mapleader = ","

" Vundle start
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle "gmarik/vundle"

" The Bundles
"



Bundle "bitc/lushtags"
Bundle "majutsushi/tagbar"

Bundle "justinmk/vim-sneak"
Bundle "QuickFixCurrentNumber"
Bundle "tpope/vim-sensible"
Bundle "tpope/vim-repeat"
Bundle "tpope/vim-surround"

" CORE
Bundle "terryma/vim-multiple-cursors"
Bundle "scrooloose/syntastic"
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['scala'] }
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_haskell_checkers = ['ghc_mod']

Bundle "rking/ag.vim"
Bundle "tComment"
Bundle "Rename"

let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 0
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#min_syntax_length = 0
let g:neocomplete#lock_buffer_name_pattern = "" "'\*ku\*'
let g:necoghc_enable_detailed_browse = 1
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

Bundle "Shougo/neocomplete.vim"

" Languages
Bundle "derekwyatt/vim-scala"
Bundle "othree/html5.vim"
Bundle "kongo2002/fsharp-vim"
Bundle "vim-ruby/vim-ruby" 
Bundle "jgdavey/vim-blockle"
Bundle "tpope/vim-rails"
Bundle "jhenahan/idris-vim"

Bundle "Markdown"

Bundle "dag/vim2hs"
Bundle "Shougo/vimproc" 
Bundle "eagletmt/ghcmod-vim"
let g:haskell_conceal_enumerations = 0
Bundle "pbrisbin/html-template-syntax"
Bundle "ujihisa/neco-ghc"
" 
" " Visual / UI / Colors
Bundle "chriskempson/base16-vim"

" Text objects
Bundle "kana/vim-textobj-user"
Bundle "nelstrom/vim-textobj-rubyblock" 
Bundle "vim-scripts/argtextobj.vim" 
Bundle "michaeljsmith/vim-indent-object" 

filetype plugin indent on

" VISUAL SETTINGS
set background=dark
colorscheme base16-default
hi Keyword cterm=bold

highlight clear SignColumn

au BufLeave,FocusLost * silent! wall " Write all files whenever
au BufRead,BufNewFile {COMMIT_EDITMSG} set ft=gitcommit
au BufRead,BufNewFile {gitconfig} set ft=gitconfig

au BufNewFile *.hs call InsertHsModule()
function! InsertHsModule()
  let parts = split(bufname("%"), '/')
  call filter(parts, 'v:val =~ "\\u.*"')
  let decl = "module " . substitute(join(parts, '.'), ".hs", "", "") . " where"
  execute "normal i" . decl
endfunction

function! RenameModule()
  let newName = input("New module name: ")
  let srcDir = "src"
  let path = srcDir . "/" . substitute(newName, "\\.", "/", "g") . ".hs"
  call Rename(path, '')
endfunction

nnoremap <F6> :call RenameModule()<cr>

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
nnoremap <Space> :wa \| SyntasticCheck<cr>

" Selectas
runtime selecta.vim
runtime finders.vim

nnoremap <leader>gS :call ShowSchemaFinder()<cr>
nnoremap <leader>gM :call CommandTListChanges()<cr>
nnoremap <leader>gg :call GemfileSelecta()<cr>
nnoremap <leader>gf :call SelectaCommand("files", ":e")<cr>
nnoremap <leader>gh :call ProducaCommand('xargs -I {} hoogle -n 10 "{}"', ":echom")<cr>
nnoremap <leader>ga :call ProducaFunction('xargs -I {} ag -S --nocolor --nogroup --search-files "{}" . 2>/dev/null', "EditJump")<cr>
nnoremap <leader>gd :call ProducaFunction('xargs -I {} ag -S --nocolor --nogroup --search-files "\({}.*::\\|\(newtype\\|data\).*{}\)" . ', "EditJump")<cr>
nnoremap <leader>gm :call SelectaCommand("git status -s --porcelain", ":e")<cr>
nnoremap <leader>ge :call SelectaCommand2(getqflist(), ":e")<cr>

function! EditJump(jumpLine)
  let [fname, lineno] = matchlist(a:jumpLine,'\v(.{-}):(\d+):.*$')[1:2]
  exec ":e +" . lineno . " " . fname
endfunction

function! EditGitStatus(statusLine)
endfunction

nnoremap <leader>ms :call MapSpecFile()<cr>
func! MapSpecFile()
  exe 'map <leader>t :wa\|!any_test ' . expand("%") . '<cr>'
endfunc

" Run selection as vimscript
vnoremap <f2> :<c-u>exe join(getline("'<","'>"),'<bar>')<cr>

nnoremap <leader>al ggO{-#<space>LANGUAGE<space><space>#-}<left><left><left><left><C-x><C-o>

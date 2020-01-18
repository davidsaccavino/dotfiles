call plug#begin('~/.vim/plugged')
  " UI Related
  Plug 'chriskempson/base16-vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Nerd Tree File Browser
  Plug 'scrooloose/nerdtree'

  " Nerd Tree Git Plugin
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " Fuzzy File Finder and Autocomplete
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " Better Visual Guide
  Plug 'Yggdroot/indentLine'

  " Syntax Check
  Plug 'w0rp/ale'

  " Async Autocompletion
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " Adds Complete From Other Opened Files
  Plug 'Shougo/context_filetype.vim'

  " Python autocompletion
  Plug 'zchee/deoplete-jedi', { 'do': ':UpdateRemotePlugins' }

  " Adds python go-to-definitions, but disabled autocompletion
  Plug 'davidhalter/jedi-vim'

  " Closes Parenthesis Automatically
  Plug 'Townk/vim-autoclose'

  " Surround Word Objects
  Plug 'tpope/vim-surround'

  " Treat Indents as Word Objects
  Plug 'michaeljsmith/vim-indent-object'

  " Better Language Packs
  Plug 'sheerun/vim-polyglot'

  " Many Color Schemes
  Plug 'flazz/vim-colorschemes'

  " Adds Git Diff Icons
  Plug 'mhinz/vim-signify'

  " Grep for Source Code
  Plug 'mileszs/ack.vim'

  Plug 'derekwyatt/vim-scala'

  " HOCON Support
  Plug 'geverding/vim-hocon', { 'for': 'hocon' } " Play config format (HOCON) syntax highlighting

call plug#end()

" filetype plugin indent on

" Disable beep / flash
set vb t_vb=

" Configurations Part
" UI configuration
syntax on
syntax enable
set incsearch
set hlsearch
set scrolloff=3
set background=dark

set clipboard+=unnamed " Makes yank and paste global
"colorscheme dracula
"colorscheme materialtheme
colorscheme vim-material

if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

if has("gui_running")
  set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:blocks
endif

set number
set hidden
set mouse=a
set noshowmode
set noshowmatch
set nolazyredraw

" Turn off backup
set nobackup
set noswapfile
set nowritebackup

" Search configuration
set ignorecase                    " ignore case when searching
set smartcase                     " turn on smartcase

" Tab and Indent configuration
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Deoplete Will Autoselect the First Selection
set completeopt+=noinsert

" Autocompletion of files and commands behaves like shell
" (completes only the common part, lists the options that match)
set wildmode=list:longest

" Clear search results
noremap <silent> // :noh<CR>

" Delete empty spaces after a line in python files
autocmd BufWritePre *.py :%s/\s\+$//e

" PLugins Settings
"=============================================

" NERD Tree ------------------------
" Auto start NERDTree when opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif

" Auto start NERDTree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif

" Let quit work as expected if after entiering :q the only window open is NERDTree itself
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeQuitOnOpen = 1

" Toggle NERD Tree display
map <silent> <C-t> :NERDTreeToggle <CR>
nmap <silent> <F2> :NERDTreeFind <CR>

" Files to leave out of NERDTree
let NERDTreeIgnore = ['\.pyc$', '\.py0$']


" Ack ------------------------
nmap ,r :Ack
nmap ,wr :Ack <cword><CR>

" Deoplete ------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1


" Jedi-vim ------------------------
" Disable autocompletion (deoplete is much better)
let g:jedi#completions_enabled = 0

" Mappings only work for python code
let g:jedi#goto_command = ',d'
" Find occurences
let g:jedi#usages_command = ',o'
" Find assignments
let g:jedi#goto_assignments_command = ',a'
" Go to definition in new tab
nmap ,D :tab split<CR>:call jedi#goto()<CR>


" Signify ------------------------
let g:signify_vcs_list = [ 'git' ]

" Mapping to jump to changed blocks
nmap <leader>sn <plug>(signify-next-hunk)
nmap <leader>sp <plug>(signify-prev-hunk)


" Better colors
highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
highlight DiffChange        cterm=bold ctermbg=none ctermfg=227
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227


" Autoclose ------------------------
" Let ESC work as expected with Autoclose
let g:AutoClosePumvisible = { "Enter": "\<C-Y>", "ESC": "\<ESC>" }

" Ale ------------------------
let g:ale_linters = {'python': ['flake8']}

" Airline ------------------------
"let g:airline_left_sep  = ''
"let g:airline_right_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'
let g:airline#extensions#whitespace#enabled = 0

" Linting information for airline
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'

"" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
"
let $BAT_THEME = 'DarkNeon'

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg --column --no-heading --line-number --color=always '.shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview(),
  \ <bang>0)

syntax on
set mouse=
set number
set expandtab
set autoindent
set tabstop=4
set shiftwidth=4
set ignorecase
set smartcase
set cursorline
set termguicolors
set completeopt=menuone,noselect
if exists('&pumblend')
    set pumblend=30
endif
if exists('&winblend')
    set winblend=30
endif
set relativenumber
set clipboard+=unnamedplus

let mapleader = "\<Space>"

" python path
let g:python3_host_prog = expand('~/.dotfiles/venv/bin/python')

tnoremap <silent> <ESC> <C-\><C-n>
nnoremap @t :botright split<CR>:terminal<CR>i
nnoremap @T :tabnew<CR>:terminal<CR>i

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')
Plug 'NLKNguyen/papercolor-theme'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rust-lang/rust.vim'
"Plug 'nvie/vim-flake8'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'yuttie/comfortable-motion.vim'
Plug 'cespare/vim-toml'
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons'
call plug#end()

" theme
set background=light
colorscheme PaperColor

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline_powerline_fonts = 1

" coc.neovim
set hidden
set nobackup
set nowritebackup

set updatetime=300
set shortmess+=c

set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" keep transparent
" https://stackoverflow.com/questions/37712730/set-vim-background-transparent
hi Normal guibg=NONE ctermbg=NONE

" no term number
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * setlocal signcolumn=

" https://github.com/yuttie/comfortable-motion.vim
let g:comfortable_motion_friction = 80.0
let g:comfortable_motion_air_drag = 2.0

" NERDTree
nnoremap <silent><C-n> :NERDTreeToggle<CR>

" NERDTree-git-plugin
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowClean = 1
let g:NERDTreeGitStatusLogLevel = 3 " https://github.com/ryanoasis/vim-devicons/pull/355

" ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" TermColor (Pencil Light)
let g:terminal_color_0  = "#212121" "black
let g:terminal_color_1  = "#c30771" "red
let g:terminal_color_2  = "#10a778" "green
let g:terminal_color_3  = "#a89c14" "yellow
let g:terminal_color_4  = "#008ec4" "blue
let g:terminal_color_5  = "#523c79" "magenta
let g:terminal_color_6  = "#20a5ba" "cyan
let g:terminal_color_7  = "#e0e0e0" "white
let g:terminal_color_8  = "#212121" "bright black
let g:terminal_color_9  = "#fb007a" "bright red
let g:terminal_color_10 = "#5fd7af" "bright green
let g:terminal_color_11 = "#f3e430" "bright yellow
let g:terminal_color_12 = "#20bbfc" "bright blue
let g:terminal_color_13 = "#6855de" "bright magenta
let g:terminal_color_14 = "#4fb8cc" "bright cyan
let g:terminal_color_15 = "#f1f1f1" "bright white
let g:terminal_color_background = "#f1f1f1" "background
let g:terminal_color_foreground = "#424242" "foreground

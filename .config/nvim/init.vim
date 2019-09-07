syntax on
set mouse=
set number
set expandtab
set autoindent
set tabstop=4
set shiftwidth=4
set cursorline
set termguicolors
set completeopt=menuone,noselect
if exists('&pumblend')
    set pumblend=30
endif
if exists('&winblend')
    set winblend=30
endif

" python path
let g:python3_host_prog = expand('~/.dotfiles/venv/bin/python')

tnoremap <silent> <ESC> <C-\><C-n>
nnoremap @t :botright split<CR>:terminal<CR>i
nnoremap @T :tabnew<CR>:terminal<CR>i

let g:ale_completion_enabled = 1

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
"Plug 'junegunn/fzf'
Plug 'rust-lang/rust.vim'
"Plug 'nvie/vim-flake8'
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'yuttie/comfortable-motion.vim'
Plug 'cespare/vim-toml'
Plug 'junegunn/fzf.vim'
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

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 0
"" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"imap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : deoplete#mappings#manual_complete()
"function! s:check_back_space() abort
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~ '\s'
"endfunction

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

" LanguageClient-neovim
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls'],
    \ 'python': ['pyls'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

let g:LanguageClient_selectionUI = 'fzf'

"au User lsp_setup call lsp#register_server({
"    \ 'name': 'pyls',
"    \ 'cmd': {server_info->[expand('~/.dotfiles/venv/bin/pyls')]},
"    \ 'whitelist': ['python'],
"    \ })
"let g:lsp_signs_enabled = 1         " enable signs
"let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

" flake8
"let g:flake8_cmd="pipenv run flake8"

" ale
"let g:ale_linters = {
"    \ 'python': ['flake8', 'mypy', 'pyls'],
"    \ 'rust': ['cargo', 'rls'],
"    \ }
"let g:airline#extensions#ale#enabled = 1
"let g:ale_python_auto_pipenv = 1
"let g:ale_sign_error = '✗'
"let g:ale_sign_warning = '➔'
"let g:ale_python_pyls_executable = expand('~/.dotfiles/venv/bin/pyls')
"let g:ale_python_flake8_auto_pipenv = 1
"let g:ale_python_mypy_auto_pipenv = 1

" keep transparent
" https://stackoverflow.com/questions/37712730/set-vim-background-transparent
hi Normal guibg=NONE ctermbg=NONE

" no term number
autocmd TermOpen * setlocal nonumber

" https://github.com/yuttie/comfortable-motion.vim
let g:comfortable_motion_friction = 80.0
let g:comfortable_motion_air_drag = 2.0

" NERDTree
nnoremap <silent><C-n> :NERDTreeToggle<CR>

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

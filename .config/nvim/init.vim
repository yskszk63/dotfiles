syntax on
set mouse=
set number
set expandtab
set autoindent
set tabstop=4
set shiftwidth=4

" python path
let g:python3_host_prog = expand('~/.dotfiles/venv/bin/python')

tnoremap <silent> <ESC> <C-\><C-n>

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
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

" Let <Tab> also do completion
inoremap <silent><expr> <Tab>
\ pumvisible() ? "\<C-n>" :
\ deoplete#mappings#manual_complete()

" Close the documentation window when completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif


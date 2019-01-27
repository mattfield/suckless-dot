call plug#begin('~/.local/share/nvim/plugged')
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'plasticboy/vim-markdown'
Plug 'pearofducks/ansible-vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'iamcco/markdown-preview.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-speeddating'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'wikitopian/hardmode'

Plug 'w0rp/ale', { 'for': 'scala' }

Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
call plug#end()

set nofoldenable
set nobackup
set nowb
set noswapfile
set nowrap

" Proper encoding
set encoding=utf-8

" Change mapleader and localleader
let mapleader=","
let maplocalleader=","

" Local dirs
set backupdir=~/.config/nvim/tmp/backups/
set undodir=~/.config/nvim/tmp/undo/

if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), 'p')
endif

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), 'p')
endif

" Get rid of the delay when hitting esc!
set timeoutlen=1000 ttimeoutlen=0
let g:bufferline_echo = 0

" Get off my lawn!
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

set t_Co=256
set termguicolors
"colorscheme wal
syntax on

" Quit yo jibber-jabber, foo'
set visualbell t_vb=

" 2 space softabs default
set expandtab
set ts=2
set sw=2

" Set some junk
set backspace=indent,eol,start
set hlsearch " Highlight searches
set ignorecase " Ignore case of searches.
set incsearch " Highlight dynamically as pattern is typed.
set laststatus=2 " Always show status line
set nostartofline " Don't reset cursor to start of line when moving around.
set ruler " Show the cursor position
set splitbelow " Split behaviour that actually makes sense
set splitright

set clipboard+=unnamedplus

set showmode " Show the current mode.
set scrolloff=3 " Start scrolling three lines before horizontal border of window.
set wildmenu " Hitting TAB in command mode will show possible completions above command line.

" Status Line
hi User1 guibg=bg guifg=fg term=bold
"hi User2 guibg=#455354 guifg=#CC4329 ctermbg=238 ctermfg=196 gui=bold           cterm=bold           term=bold
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction
"set statusline=%1*%<%.99f\ %h%w%m%r\ %{LinterStatus()?:''}\%=%-16(\ %l,%c-%v\ %)%P
set statusline=%1*%<%.99f\ %h%w%m%r\%=%-16(\ %l,%c-%v\ %)%P

" Speed up viewport scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Show trailing whitespace
set list
set listchars=tab:>.,trail:·,nbsp:·

" Search and replace word under cursor (,*)
nnoremap <leader>* :%s/\<<C-r><C-w>\>//<Left>

au BufRead,BufNewFile *.json set ft=json syntax=javascript

au BufRead,BufNewFile *.py setl shiftwidth=4 tabstop=4

" Common Ruby files
au BufRead,BufNewFile Rakefile,Capfile,Gemfile,.autotest,.irbrc,*.treetop,*.tt set ft=ruby syntax=ruby
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2

" Common HCL
au BufRead,BufNewFile *.nomad set ft=hcl syntax=hcl
autocmd FileType hcl setlocal shiftwidth=2 tabstop=2

" Add spell checking and auto wrapping for git commits
autocmd Filetype gitcommit setlocal spell textwidth=72

" fzf
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

if executable('fzf')
  nnoremap <leader>F :Files<CR>
  nnoremap <leader>u :Tags<cr>
  nnoremap <leader>jt :call fzf#vim#tags("'".expand('<cword>'))<cr>
endif

" <leader>ws removes all blank lines
map <leader>ws :g/^\s*$/d<CR>

" <leader>/ kills highlighted search
map <leader>/ :nohl<CR>

" General useful leader commands
map <leader>pn :vs ~/src/project-notes.md<CR>

" git gutter
highlight clear SignColumn

" Inserts tab if at beginning of line,
" else uses completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

" Tab/Shift-Tab for autocomplete
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Terminal show/hide
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Toggle terminal on/off
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" fugitive mappings
map <leader>gs :Gstatus<CR>
map <leader>gc :Gcommit<CR>
map <leader>gb :Gblame<CR>
map <leader>gd :Gdiff<CR>
map <leader>gbr :Gbrowser<CR>

" Index ctags from any project
map <Leader>ct :!ctags .<CR>

" Golang
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

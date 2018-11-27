" ==============================================================================
" Load Plugins
" ==============================================================================

source $HOME/.dotfiles/vim/plugins.vim

" ==============================================================================
" General
" ==============================================================================

" a mighty good leader
let mapleader = ','
" automatically refresh externally changed files
set autoread
" hide abandoned buffers (allows for leaving them unsaved)
set hidden
" show partial comments at bottom of screen
set showcmd
" split new windows at bottom
set splitbelow
" vsplit new windows at right
set splitright
" disable backups and swaps
set nobackup
set nowritebackup
set noswapfile


" ==============================================================================
" Interface
" ==============================================================================

" infer background from named iterm profile (light or dark)
" in vim I was using `set background=$ITERM_PROFILE`, but I haven’t got this
" working in neovim
if $ITERM_PROFILE == 'light'
      set background=light
else
      set background=dark
endif

" set colorscheme
colorscheme solarized
" don't try and highlight crazy long lines
set synmaxcol=800
" where to highlight column and wrap text (when enabled)
set textwidth=80
" highlight column after textwidth
set colorcolumn=+1
" highlight line of cursor
set cursorline
" see `:help fo-table`
set formatoptions+=tcqjn
" always show status line
set laststatus=2
" show some invisible characters
set list listchars=tab:»·,trail:·,nbsp:·
" keep cursor in same column when moving over lines
set nostartofline
" by default, don't wrap lines
set nowrap
" show absolute number for current line
set number
" use relative numbers for other lines
set relativenumber
" nice padding for line numbers
set numberwidth=5
" see `:help wildmode` for a description of these
set wildmode=list:longest,full
" standard ignore patterns for expanding wildcards
set wildignore=*.o,*~,*/.git,*/tmp/*,*/node_modules/*,*/_build/*,*/deps/*,*/target/*
" use popup menu for Insert mode completion, even when only one match
" don't automatically select a match in the menu
set completeopt=menu,menuone,noselect
" fix end tag highlighting in html etc
highlight link xmlEndTag xmlTag


" ==============================================================================
" Editing
" ==============================================================================

" apply current line indent when starting new line
set autoindent
" preserve current structure when changing indent
set preserveindent
" use 2 spaces for indentation steps
set shiftwidth=2
" round indents to multiples of `shiftwidth`
set shiftround
" expands tabs to appropriate number of spaces
set expandtab
" `<Tab>` counts for `shiftwidth` spaces in edits
set softtabstop=-1
" use `shiftwidth` for front of line inserts, otherwise `tabstop` or `softtabstop`
set smarttab
" allow backspacing over more things
set backspace=indent,eol,start
" only insert one space after '.', '?' and '!' when joining
set nojoinspaces
" include extended matching for `%` command
runtime macros/matchit.vim
" indent p and li tags
let g:html_indent_tags = ['p', 'li']

" strip trailing whitespace, maintaining last search and cursor position.
function! <SID>StripTrailingWhitespace()
      let _s = @/
      let l = line(".")
      let c = col(".")

      %s/\s\+$//e

      let @/=_s
      call cursor(l, c)
endfunction

augroup editing
      au!

      " set filetypes for given files/extensions
      au BufRead *.md set filetype=markdown
      au BufRead .{babel,jshint,eslint}rc set filetype=json
      " return to same line when re-opening files
      au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   execute 'normal! g`"zvzz' |
      \ endif
      " strip trailing whitespace when saving files
      au BufWritePre * :call <SID>StripTrailingWhitespace()
augroup END


" ==============================================================================
" Search
" ==============================================================================

" highlight search matches
set hlsearch
" highlight searches as typing pattern
set incsearch
" ignore case when searching
set ignorecase
" override `ignorecase` when pattern contains uppercase characters
set smartcase
" searches wrap around file
set wrapscan


" ==============================================================================
" Plugin Configuration
" ==============================================================================

" ale
let g:ale_completion_enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'elixir': ['credo'], 'ruby': ['reek', 'rubocop']}
let g:ale_fixers = {'javascript': ['prettier']}
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_elixir_elixir_ls_release = '~/Developer/Tools/elixir-ls/rel'

" deoplete.vim
call deoplete#custom#option('sources', {
      \ '_': ['omni', 'buffer'],
      \ 'elixir': ['omni', 'buffer']
      \ })
call deoplete#custom#source('omni', 'functions', {
      \ 'elixir': 'lsp#complete'
      \ })
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'elixir': ['\w+', '[^. *\t]\.\w*']
      \ })
let g:deoplete#enable_at_startup = 1

" echodoc.vim
let g:echodoc_enable_at_startup = 1

" emmet-vim
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \}

" neosnippet
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

" tmuxline.vim
let g:tmuxline_powerline_separators = 0

" vim-airline
let g:airline_theme = 'solarized'

" vim-fzf
command! -bang -nargs=* Rg
      \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --hidden --glob "!.git/" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

" vim-gutentags
let g:gutentags_ctags_exclude = [
      \ 'node_modules',
      \ 'vendor',
      \ '.elixir_ls',
      \ 'dist',
      \ '_build'
      \]

" vim-lsp
augroup lsp
  au!

  au User lsp_setup call lsp#register_server({
        \ 'name': 'elixir-ls',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, '~/Developer/Tools/elixir-ls/rel/language_server.sh']},
        \ 'whitelist': ['elixir', 'eelixir'],
        \ })
augroup END

" vim-peekaboo
let g:peekaboo_window = 'vertical botright 60new'

" vim-polyglot
let g:jsx_ext_required = 0

" vim-test
let test#strategy = 'dispatch'


" ==============================================================================
" Mappings
" ==============================================================================

" faster escape from insert mode
inoremap jk <ESC>

" add blank lines without ending up in insert mode
map <leader>o o<Esc>
map <leader>O O<Esc>j

" shortcuts for macos clipboard register
map <leader>y "*y
map <Leader>p :set paste<CR>"*p:set nopaste<cr>

" align from visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" align from motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" common alignment shortcuts
map <leader>= :EasyAlign =<cr>
map <leader>; :EasyAlign :<cr>

" quickly clear search highlights
nnoremap <leader><leader> :noh<cr>

" project search using custom Rg command and vim-fzf
nnoremap \ :Rg<space>

" get to beginning/end of line when in insert mode
imap <C-a> <Esc>I
imap <C-e> <Esc>A

" open a new vertical split and go to it
nnoremap <leader>w <C-w>v<C-w>l

" quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" no arrow keys in normal mode
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" fuzzy-find files and buffers with fzf
nnoremap <leader>f :Files<cr>
nnoremap <leader>gf :GFiles<cr>
nnoremap <leader>bf :Buffers<cr>

" vim-test mappings
nmap <silent> <leader>t :w<CR>:TestNearest<CR>
nmap <silent> <leader>T :w<CR>:TestFile<CR>
nmap <silent> <leader>a :w<CR>:TestSuite<CR>
nmap <silent> <leader>l :w<CR>:TestLast<CR>
nmap <silent> <leader>g :w<CR>:TestVisit<CR>


" ==============================================================================
" Local Overrides
" ==============================================================================

let s:localConfig = $HOME . '/.vimrc.local'
if filereadable(s:localConfig)
  execute 'source' s:localConfig
endif

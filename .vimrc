"
"   V I M R C
"
"   @updated:   Mi 29 Jun 2012
"   @revision:  3

set nocompatible               " be iMproved

" Vundle {{{
  filetype off
  set rtp+=~/.vim/bundle/Vundle.vim/
  call vundle#begin()

  " let Vundle manage Vundle
  Plugin 'gmarik/Vundle.vim'

  " Vundles
  "
  " github repos
  Plugin 'tpope/vim-fugitive'
  Plugin 'tpope/vim-rails'
  Plugin 'tpope/vim-haml'
  Plugin 'tpope/vim-endwise'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-ragtag'
  Plugin 'tpope/vim-markdown'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'scrooloose/nerdtree'
  " Plugin 'msanders/snipmate.vim'
  Plugin 'ervandew/supertab'
  Plugin 'tomtom/tlib_vim'
  Plugin 'tomtom/tcomment_vim'
  Plugin 'tomtom/tselectbuffer_vim'
  " Plugin 'tsaleh/vim-matchit'
  Plugin 'vim-scripts/taglist.vim'
  Plugin 'Townk/vim-autoclose'
  Plugin 'trapd00r/x11colors.vim'
  Plugin 'lilydjwg/colorizer'
  " Plugin 'fholgado/minibufexpl.vim'
  Plugin 'shemerey/vim-project'
  " Plugin 'Twinside/vim-codeoverview'
  Plugin 'nanotech/jellybeans.vim'

  " vim-scripts repos

  " non github repos

  call vundle#end()

" }}}
" General settings {{{
  filetype on
  filetype plugin indent on
  syntax on

  set title
  "set mouse=a

  set shortmess=at      " shorten error messages

  set nrformats+=alpha  " in-/decrease letters with C-a/C-x

  set modeline          " enable modelines
  set modelines=5

  set number            " enable line numbers
  set ruler             " enable something
  set cursorline        " enable hiliting of cursor line

  set backspace=2       " backspace over EOL etc.

  set background=dark   " i prefer dark backgrounds

  set hidden            " buffer switching should be quick
  set confirm           " ask instead of just print errors
  set equalalways       " make splits equal size

  set lazyredraw        " don't redraw while executing macros

  set noshowmode        " don't display mode, it's already in the status line

  let mapleader=","
  let maplocalleader=","
" }}}
" General Keybinds {{{

  " Set MapLeader
  let mapleader = ","

  " Delete previous word with C-BS
  imap <C-BS> <C-W>

  " Toggle Buffer Selection and list Tag Lists
  map <F2> <Esc>:TSelectBuffer<CR>
  map <F4> <Esc>:TlistToggle<CR>

   
  " Set text wrapping toggles
  nmap <silent> <leader>w :set invwrap<CR>:set wrap?<CR> 
   
  " Set up retabbing on a source file
  nmap <silent> <leader>rr :1,$retab<CR> 
   
  " cd to the directory containing the file in the buffer
  nmap <silent> <leader>cd :lcd %:h<CR> 
   
  " Make the directory that contains the file in the current buffer.
  " This is useful when you edit a file in a directory that doesn't
  " (yet) exist
  nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

  " Increase @revision # by 1
"  nmap <silent> <leader>incr /@updated
"wwwd$"=strftime("%a %d %b %Y")
"p/@revision
"$

" }}}
" {{{ Window movement
  nmap <M-h> :winc h<CR>
  nmap <M-j> :winc j<CR>
  nmap <M-k> :winc k<CR>
  nmap <M-l> :winc l<CR>
" }}}
" GUI or no GUI, that's the question {{{
  if has('gui_running')
    set guicursor+=a:blinkon0       " Cursor doesn't blink - it's annoying
    set guioptions-=m               " No Menubar
    set guioptions-=T               " No Toolbar
    set guioptions-=l               " No Scrollbar left
    set guioptions-=L               " No Scrollbar left when split
    set guioptions-=r               " No Scrollbar right
    set guioptions-=r               " No Scrollbar right when split

    set laststatus=2                " always show statusline

    " set gfn=Pragmata\ 6.5
    set gfn=Neep\ Medium\ Semi-Condensed\ 9
    " set gfn=Mensch\ 7

    set lines=40                    " Height
    set columns=85                  " Width

    colorscheme wombat256mod 

  else
    colorscheme jellybeans
  endif
" }}}
" Status line {{{
  set laststatus=2      " always show statusline

  " Generic Statusline {{{
  function! SetStatus()
    setl statusline+=
          \%1*\ %f
          \%H%M%R%W%7*\ ┃
          \%2*\ %Y\ <<<\ %{&ff}%7*\ ┃
  endfunction

  function! SetRightStatus()
    setl statusline+=
          \%5*\ %{StatusFileencoding()}%7*\ ┃
          \%5*\ %{StatusBuffersize()}%7*\ ┃
          \%=%<%7*\ ┃
          \%5*\ %{StatusWrapON()}
          \%6*%{StatusWrapOFF()}\ %7*┃
          \%5*\ %{StatusInvisiblesON()}
          \%6*%{StatusInvisiblesOFF()}\ %7*┃
          \%5*\ %{StatusExpandtabON()}
          \%6*%{StatusExpandtabOFF()}\ %7*┃
          \%5*\ w%{StatusTabstop()}\ %7*┃
          \%3*\ %l,%c\ >>>\ %P
          \\ 
  endfunction " }}}

  " Update when leaving Buffer {{{
  function! SetStatusLeaveBuffer()
    setl statusline=""
    call SetStatus()
  endfunction
  au BufLeave * call SetStatusLeaveBuffer() " }}}

  " Update when switching mode {{{
  function! SetStatusInsertMode(mode)
    setl statusline=%4*
    if a:mode == 'i'
      setl statusline+=\ Insert\ ◥
    elseif a:mode == 'r'
      setl statusline+=\ Replace\ ◥
    elseif a:mode == 'normal'
      setl statusline+=\ \ ◥
    endif
    call SetStatus()
    call SetRightStatus()
  endfunction

  au VimEnter     * call SetStatusInsertMode('normal')
  au InsertEnter  * call SetStatusInsertMode(v:insertmode)
  au InsertLeave  * call SetStatusInsertMode('normal')
  au BufEnter     * call SetStatusInsertMode('normal') " }}}

  " Some Functions shamelessly ripped and modified from Cream
  "fileencoding (three characters only) {{{
  function! StatusFileencoding()
    if &fileencoding == ""
      if &encoding != ""
        return &encoding
      else
        return " -- "
      endif
    else
      return &fileencoding
    endif
  endfunc " }}}
  " &expandtab {{{
  function! StatusExpandtabON()
    if &expandtab == 0
      return "tabs"
    else
      return ""
    endif
  endfunction "
  function! StatusExpandtabOFF()
    if &expandtab == 0
      return ""
    else
      return "tabs"
    endif
  endfunction " }}}
  " tabstop and softtabstop {{{
  function! StatusTabstop()

    " show by Vim option, not Cream global (modelines)
    let str = "" . &tabstop
    " show softtabstop or shiftwidth if not equal tabstop
    if   (&softtabstop && (&softtabstop != &tabstop))
    \ || (&shiftwidth  && (&shiftwidth  != &tabstop))
      if &softtabstop
        let str = str . ":sts" . &softtabstop
      endif
      if &shiftwidth != &tabstop
        let str = str . ":sw" . &shiftwidth
      endif
    endif
    return str

  endfunction " }}}
  " Buffer Size {{{
  function! StatusBuffersize()
    let bufsize = line2byte(line("$") + 1) - 1
    " prevent negative numbers (non-existant buffers)
    if bufsize < 0
      let bufsize = 0
    endif
    " add commas
    let remain = bufsize
    let bufsize = ""
    while strlen(remain) > 3
      let bufsize = "," . strpart(remain, strlen(remain) - 3) . bufsize
      let remain = strpart(remain, 0, strlen(remain) - 3)
    endwhile
    let bufsize = remain . bufsize
    " too bad we can't use "¿" (nr2char(1068)) :)
    let char = "b"
    return bufsize . char
  endfunction " }}}
  " Show Invisibles {{{
  function! StatusInvisiblesON()
    "if exists("g:LIST") && g:LIST == 1
    if &list
      if     &encoding == "latin1"
        return "¶"
      elseif &encoding == "utf-8"
        return "¶"
      else
        return "$"
      endif
    else
      return ""
    endif
  endfunction
  function! StatusInvisiblesOFF()
    "if exists("g:LIST") && g:LIST == 1
    if &list
      return ""
    else
      if     &encoding == "latin1"
        return "¶"
      elseif &encoding == "utf-8"
        return "¶"
      else
        return "$"
      endif
    endif
  endfunction " }}}
  " Wrap Enabled {{{
  function! StatusWrapON()
    if &wrap
      return "wrap"
    else
      return ""
    endif
  endfunction
  function! StatusWrapOFF()
    if &wrap
      return ""
    else
      return "wrap"
    endif
  endfunction
  " }}}
" }}}
" Tabstops {{{
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set autoindent
  set smartindent
  set expandtab
" }}}
" Invisibles {{{
"  set listchars=tab:>\ ,eol:<
"  set list
"  nmap <silent> <F5> :set list!<CR>
" }}}
" Folds {{{
  set foldmethod=marker
  set foldcolumn=1
  " au BufWinLeave * mkview
  " au BufWinEnter * silent loadview
" }}}
" Pairings {{{
  set showmatch
" }}}
" Margins {{{
  set scrolloff=5
  set sidescroll=5
" }}}
" Search {{{
  set incsearch
  set ignorecase

  " Toggle that stupid highlight search
  nmap <silent> ,n :set invhls<CR>:set hls?<CR> 
" }}}
" Backup files {{{
  set nobackup
  set nowb
  set noswapfile
" }}}
" Completion {{{
  set wildmenu
  set wildmode=longest,full,list

  set ofu=syntaxcomplete#Complete
" }}}
" Snipmate {{{
  imap <tab> <C-r>=TriggerSnippet()<CR>
" }}}
" NERDTree {{{
  map <F3> :NERDTreeToggle<CR>

  let NERDTreeChDirMode = 2
  let NERDTreeShowBookmarks = 1
" }}}
" Wrapping {{{
  set linebreak
  set showbreak=↳\ 
" toggle wrapping
  nmap <silent> <F12> :let &wrap = !&wrap<CR>
" }}}
" RagTag {{{
  imap <M-O> <Esc>o
  imap <C-J> <Down>
  let g:ragtag_global_maps = 1

  imap <C-Space> <C-X><Space>
  imap <C-CR> <C-X><CR>
" }}}
" 'Bubbling' {{{
  nmap <C-up> [e
  nmap <C-down> ]e
  vmap <C-up> [egv
  vmap <C-down> ]egv
" }}}
" Formatting with Par (gqip) {{{
  set formatprg=par\ -req
  nmap <F9> gqip
" }}}
" Pasting {{{
  set paste
  nnoremap p ]p
  nnoremap <c-p> p
" }}}
" Macros {{{
  " Execute macro "q" with space
  nmap <Space> @q
  " Map @ to + for more comfortable macros on DE kb layout
  nmap + @
" }}}
" VIM Addon Manager {{{
  fun! EnsureVamIsOnDisk(vam_install_path)
    " windows users want to use http://mawercer.de/~marc/vam/index.php
    " to fetch VAM, VAM-known-repositories and the listed plugins
    " without having to install curl, unzip, git tool chain first
    " -> BUG [4] (git-less installation)
    if !filereadable(a:vam_install_path.'/vim-addon-manager/.git/config')
       \&& 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
        " I'm sorry having to add this reminder. Eventually it'll pay off.
      call confirm("Remind yourself that most plugins ship with ".
                  \"documentation (README*, doc/*.txt). It is your ".
                  \"first source of knowledge. If you can't find ".
                  \"the info you're looking for in reasonable ".
                  \"time ask maintainers to improve documentation")
      call mkdir(a:vam_install_path, 'p')
      execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
      " VAM runs helptags automatically when you install or update 
      " plugins
      exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
    endif
  endf

  fun! SetupVAM()
    " Set advanced options like this:
    " let g:vim_addon_manager = {}
    " let g:vim_addon_manager['key'] = value

    " Example: drop git sources unless git is in PATH. Same plugins can
    " be installed from www.vim.org. Lookup MergeSources to get more control
    " let g:vim_addon_manager['drop_git_sources'] = !executable('git')

    " VAM install location:
    let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
    call EnsureVamIsOnDisk(vam_install_path)
    exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

    " Tell VAM which plugins to fetch & load:
    call vam#ActivateAddons([], {'auto_install' : 0})
    " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

    " Addons are put into vam_install_path/plugin-name directory
    " unless those directories exist. Then they are activated.
    " Activating means adding addon dirs to rtp and do some additional
    " magic

    " How to find addon names?
    " - look up source from pool
    " - (<c-x><c-p> complete plugin names):
    " You can use name rewritings to point to sources:
    "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
    "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
    " Also see section "2.2. names of addons and addon sources" in VAM's documentation
  endfun
  call SetupVAM()
  " experimental [E1]: load plugins lazily depending on filetype, See
  " NOTES
  " experimental [E2]: run after gui has been started (gvim) [3]
  " option1:  au VimEnter * call SetupVAM()
  " option2:  au GUIEnter * call SetupVAM()
  " See BUGS sections below [*]
  " Vim 7.0 users see BUGS section [3]
" }}}

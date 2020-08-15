" Personal vimrc file.
"
" Based on `vimrc_example.vim`, `defaults.vim`, sensible.vim, Vim Tips Wiki's
" Example vimrc and Best Vim Tips, and MIT's Missing Semester class' basic
" vimrc.

"-------------------------------------------------------------------------------

" COMPATIBILITY & KEY FEATURES {{{

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
if &compatible
  set nocompatible
endif

"----------------------------------------------------------------------------}}}
" PLUGINS {{{

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" VIM-PLUG
" Automatic installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Register vim-plug as a plugin for Vim help for vim-plug itself.
Plug 'junegunn/vim-plug'

" ctrlp.vim fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'

" fugitive.vim Git wrapper
Plug 'tpope/vim-fugitive'

" ALE (Asynchronous Lint Engine)
Plug 'dense-analysis/ale'

" Emmet-vim support for expanding abbreviations
Plug 'mattn/emmet-vim'

" Initialize plugin system
call plug#end()

"----------------------------------------------------------------------------}}}
" GENERAL {{{

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Better command-line completion
set wildmenu
set wildignore=*.o,*.obj,*.bak,*.exe

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline
set modeline

" Tell Vim to check for the final 2 lines of the file for a modeline
set modelines=2

" Set tab page limit to 50
if &tabpagemax < 50
  set tabpagemax=50
endif

" Keep 1000 lines of command line history
if &history < 1000
  set history=1000
endif

if !empty(&viminfo)
  set viminfo^=!
endif

set sessionoptions-=options
set viewoptions-=options

" Disable the default Vim startup message.
set shortmess+=I

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

set autoread

set noerrorbells

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Refrain from updating the display while executing macros
set lazyredraw

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=100

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F2>

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

"----------------------------------------------------------------------------}}}
" INDENTATION {{{

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab

"----------------------------------------------------------------------------}}}
" APPEARANCE {{{

" Show partial commands in the last line of the screen
set showcmd

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Show a few columns of context around the cursor.
set sidescrolloff=5

" Show @@@ in the last line if it is truncated.
set display=lastline

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 80 characters.
  autocmd FileType text setlocal textwidth=80
augroup END

" Always display the status line, even if only one window is displayed
set laststatus=2
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Enable list mode
set list

" Set list characters
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Disable folding by default
set nofoldenable

" Fold based on syntax
set foldmethod=syntax

"----------------------------------------------------------------------------}}}
" MAPPINGS {{{

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Move to beginning/end of line
nnoremap B ^
nnoremap E $

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Move vertically by visual line
nnoremap j gj
nnoremap k gk

" Select the last changed (or pasted) text with the visual mode last used
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Open/close folds
nnoremap <Space> za

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohlsearch<CR><C-L>

" Set comma as leader
let mapleader=","

" Save session. To reopen session, use vim -S. Mapped to ,s as "super save."
nnoremap <Leader>s :mksession<CR>

" Source $MYVIMRC reloads the saved $MYVIMRC. (Mnemonic for the key sequence
" is 's'ource 'v'imrc).
nnoremap <silent> <Leader>sv :source $MYVIMRC<CR>

" Opens $MYVIMRC for editing in a new tab. (Mnemonic for the key sequence is
" 'e'dit 'v'imrc).
nnoremap <silent> <Leader>ev :tabedit $MYVIMRC<CR>

" Move between ALE warnings and errors quickly.
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"----------------------------------------------------------------------------}}}

"-------------------------------------------------------------------------------
" Folds sections by marker rather than syntax. Closes every fold by default.
" vim:fen:fdm=marker:fdl=0
" vim:set ft=vim et sw=2:
